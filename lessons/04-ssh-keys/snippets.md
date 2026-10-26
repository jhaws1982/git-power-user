# Code from the post (not transcripts), numbered for demo.sh's `snippet N`

## snippet 1
```bash
cat ~/.ssh/id_ed25519.pub
```

## snippet 2
```bash
ssh -T git@github.com
```

## snippet 3
```text
Hi USERNAME! You've successfully authenticated, but GitHub does not provide shell access.
```

## snippet 4
```bash
# ~/.bashrc (or ~/.zshrc): one ssh-agent shared by every terminal
eval "$(keychain --eval --quiet id_ed25519)"
```

## snippet 5
```powershell
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent
Get-Service ssh-agent
```

## snippet 6
```powershell
ssh-add $HOME\.ssh\id_ed25519
```

## snippet 7
```powershell
git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
```

## snippet 8
```text
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
    AddKeysToAgent yes

Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
    IdentitiesOnly yes
    AddKeysToAgent yes
```
