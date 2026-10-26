# Checks the Windows-specific steps the posts give, on a real Windows machine
# (the windows-latest runner in CI). Each check prints "ok" or "FAIL"; failures
# are also GitHub annotations. Exit code is the number of failures.
#   Lesson 4 (SSH keys): the OpenSSH agent service, ssh-add, keys surviving an
#     agent restart, Git for Windows' own ssh not seeing that agent, core.sshCommand.
#   Lesson 5 (credential helpers): Git Credential Manager ships with Git for Windows.
#   Bonus 2 (line endings): what a Windows checkout gets for each attribute.
# It changes the machine it runs on (starts ssh-agent, adds a key, sets global git
# config), so run it on a CI runner or a throwaway VM, not your own computer.
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false
$script:failures = 0
$script:report = @()

function Check([string]$name, [scriptblock]$test) {
    try {
        $note = & $test
        $line = "ok   $name" + $(if ($note) { " ($note)" } else { "" })
    } catch {
        $script:failures++
        $line = "FAIL ${name}: $($_.Exception.Message)"
        Write-Output "::error title=Windows: $name::$($_.Exception.Message)"
    }
    Write-Output $line
    $script:report += $line
}
function Assert([bool]$cond, [string]$msg) { if (-not $cond) { throw $msg } }

$openssh = 'C:\Windows\System32\OpenSSH'
$gitBashSsh = 'C:\Program Files\Git\usr\bin'
git --version
"core.autocrlf (system): $(git config --system --get core.autocrlf)"

# ---- Lesson 4: SSH keys ----------------------------------------------------
Check 'Windows ships OpenSSH and an ssh-agent service' {
    Assert (Test-Path "$openssh\ssh.exe") "no $openssh\ssh.exe"
    Assert (Test-Path "$openssh\ssh-add.exe") "no $openssh\ssh-add.exe"
    $svc = Get-Service ssh-agent
    "service start type before setup: $($svc.StartType)"
}
Check 'Set-Service / Start-Service from the post start the agent' {
    Set-Service ssh-agent -StartupType Automatic
    Start-Service ssh-agent
    $svc = Get-Service ssh-agent
    Assert ($svc.Status -eq 'Running') "ssh-agent is $($svc.Status)"
    Assert ($svc.StartType -eq 'Automatic') "start type is $($svc.StartType)"
}
$key = Join-Path $HOME '.ssh\id_ed25519'
Check 'ssh-add $HOME\.ssh\id_ed25519 loads the key' {
    New-Item -ItemType Directory -Force (Split-Path $key) | Out-Null
    if (-not (Test-Path $key)) { & "$openssh\ssh-keygen.exe" -q -t ed25519 -N '' -C ci@example.com -f $key }
    Assert (Test-Path $key) "ssh-keygen didn't create $key"
    & "$openssh\ssh-add.exe" $key 2>&1 | Out-Null
    $list = & "$openssh\ssh-add.exe" -l 2>&1 | Out-String
    Assert ($list -match 'ci@example.com|ED25519') "ssh-add -l doesn't list the key: $list"
}
Check 'the Windows agent keeps the key across a service restart' {
    Restart-Service ssh-agent
    $list = & "$openssh\ssh-add.exe" -l 2>&1 | Out-String
    Assert ($list -match 'ED25519') "after Restart-Service, ssh-add -l says: $list"
    "a restart stands in for the post's 'across reboots'"
}
Check "Git for Windows' bundled ssh doesn't see the Windows agent" {
    $out = & "$gitBashSsh\ssh-add.exe" -l 2>&1 | Out-String
    Assert ($LASTEXITCODE -ne 0) "Git's ssh-add listed keys: $out"
    $out.Trim()
}
Check 'core.sshCommand makes git use the Windows ssh' {
    git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
    $env:GIT_TRACE = '1'
    $trace = git ls-remote git@nonexistent.invalid:owner/repo.git 2>&1 | Out-String
    Remove-Item Env:GIT_TRACE
    git config --global --unset core.sshCommand
    Assert ($trace -match 'C:/Windows/System32/OpenSSH/ssh\.exe') "git didn't run the Windows ssh: $trace"
}

# ---- Lesson 5: credential helpers --------------------------------------------
Check 'Git Credential Manager ships with Git for Windows' {
    $v = git credential-manager --version 2>&1 | Out-String
    Assert ($LASTEXITCODE -eq 0) "git credential-manager --version failed: $v"
    $helper = git config --system --get credential.helper
    "version $($v.Trim()); system credential.helper = $helper"
}

# ---- Bonus 2: line endings ---------------------------------------------------
$work = Join-Path ([IO.Path]::GetTempPath()) "eol-$([guid]::NewGuid())"
New-Item -ItemType Directory $work | Out-Null
Push-Location $work
git -c init.defaultBranch=main init -q src
$lf = "line one`nline two`n"
foreach ($f in 'build.sh', 'flash.bat', 'notes.txt') { [IO.File]::WriteAllText("$work\src\$f", $lf) }
[IO.File]::WriteAllBytes("$work\src\cal.bin", [byte[]](0x7f, 0x43, 0x41, 0x4c, 0x0a, 0x0d, 0x0a))
[IO.File]::WriteAllText("$work\src\.gitattributes", "* text=auto`n*.sh  text eol=lf`n*.bat text eol=crlf`n*.bin binary`n")
git -C src -c core.autocrlf=false add . 2>&1 | Out-Null
git -C src -c user.name=ci -c user.email=ci@example.com commit -q -m init
function Ending([string]$path) {
    $b = [IO.File]::ReadAllBytes($path)
    $t = [Text.Encoding]::ASCII.GetString($b)
    if ($t.Contains("`r`n")) { 'CRLF' } else { 'LF' }
}
foreach ($autocrlf in 'true', 'false') {
    git -c core.autocrlf=$autocrlf clone -q src "clone-$autocrlf" 2>&1 | Out-Null
    $d = "$work\clone-$autocrlf"
    Check "core.autocrlf=${autocrlf}: build.sh (eol=lf) checks out LF" { Assert ((Ending "$d\build.sh") -eq 'LF') "got $(Ending "$d\build.sh")" }
    Check "core.autocrlf=${autocrlf}: flash.bat (eol=crlf) checks out CRLF" { Assert ((Ending "$d\flash.bat") -eq 'CRLF') "got $(Ending "$d\flash.bat")" }
    Check "core.autocrlf=${autocrlf}: notes.txt (text=auto, no eol) checks out CRLF on Windows" { Assert ((Ending "$d\notes.txt") -eq 'CRLF') "got $(Ending "$d\notes.txt")" }
    Check "core.autocrlf=${autocrlf}: cal.bin (binary) is untouched" {
        $b = [IO.File]::ReadAllBytes("$d\cal.bin")
        Assert ($b.Length -eq 7 -and $b[4] -eq 0x0a -and $b[5] -eq 0x0d) "cal.bin changed: $($b -join ',')"
    }
}
Pop-Location
Remove-Item -Recurse -Force $work

if ($env:GITHUB_STEP_SUMMARY) {
    "## Windows checks`n" + ($script:report | ForEach-Object { "- $_" } | Out-String) | Out-File -Append $env:GITHUB_STEP_SUMMARY
}
"$($script:failures) failure(s)"
exit $script:failures
