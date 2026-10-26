#!/usr/bin/env bash
# Bonus lesson 1, tags, releases, and signed commits: reproduces every transcript in the post.
# Lightweight vs annotated tags, describe, version sort, pushing tags, git archive,
# and SSH signing with an allowed-signers file. Runs in a throwaway HOME with a
# bare repository at ~/server standing in for the remote; needs ssh-keygen.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me
git init -q --bare server/sensor-fw.git
git clone -q server/sensor-fw.git sensor-fw 2>/dev/null && cd sensor-fw || exit 1
c() { echo "$1" >> notes.txt; git add notes.txt; git commit -qm "$1"; tick; }
c "Add ADC driver"; c "Add UART console"
git push -q origin main 2>/dev/null

# Lightweight vs annotated
run "git tag v1.0-rc1"
show "git tag -a v1.0 -m 'Sensor firmware 1.0'"
run "git cat-file -t v1.0-rc1"
show "git cat-file -t v1.0"
show "git cat-file -p v1.0"

# describe
c "Fix ADC offset"; c "Add watchdog"
run "git describe"
echo "/* wip */" >> notes.txt
show "git describe --dirty"
git checkout -q notes.txt

# version sort
git tag v1.2 HEAD~1; git tag v1.10; git tag v1.9 HEAD~1
show "git tag -l 'v1.*'"
run "git config --global tag.sort version:refname"
show "git tag -l 'v1.*'"
run "git config --global versionsort.suffix -rc"
show "git tag -l 'v1.*'"
git tag -d v1.2 v1.9 v1.10 >/dev/null

# pushing tags
{
show "git push origin main"
show "git ls-remote --tags origin"
show "git push --follow-tags origin"
show "git ls-remote --tags origin"
} 2>&1 | server_urls

# a release tarball
run "git archive --prefix=sensor-fw-1.0/ -o sensor-fw-1.0.tar.gz v1.0"
show "tar tzf sensor-fw-1.0.tar.gz"
rm sensor-fw-1.0.tar.gz

# SSH signing
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
ssh-keygen -q -t ed25519 -N '' -C jon@example.com -f "$HOME/.ssh/id_ed25519"
run "git config --global gpg.format ssh"
run "git config --global user.signingKey ~/.ssh/id_ed25519.pub"
c "Add sleep mode"
echo "/* sleep */" >> notes.txt; git add notes.txt
show "git commit -S -q -m 'Add sleep current limit' && git log --show-signature -1 --oneline"
run "echo \"jon@example.com \$(cat ~/.ssh/id_ed25519.pub)\" > ~/.ssh/allowed_signers"
run "git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers"
show "git log --show-signature -1 --oneline"
tick
show "git tag -s v1.1 -m 'Sensor firmware 1.1'"
show "git verify-tag v1.1"
show "git log --format='%h %G? %s' -3"
