#!/usr/bin/env bash
# Lesson 4, SSH keys: reproduces every transcript in the post.
# Runs in a throwaway HOME and writes keys only there; safe to run on your own machine.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PTY="python3 $HERE/../../tests/pty_answer.py"
me
mkdir -p ~/.ssh && chmod 700 ~/.ssh

# ssh-keygen asks on the terminal. Answer the file prompt with a path inside the
# sandbox (ssh-keygen's default comes from the passwd entry, not $HOME) and press
# Enter for an empty passphrase, as the post does.
printf '$ ssh-keygen -t ed25519 -C "jon@work.example"\n'
$PTY "save the key=$HOME/.ssh/id_ed25519" "empty for no passphrase" "again" -- \
    ssh-keygen -t ed25519 -C "jon@work.example"
echo

run 'eval "$(ssh-agent -s)"'
run "ssh-add ~/.ssh/id_ed25519"
show "ssh-add -l"
ssh-agent -k >/dev/null

cat > ~/.ssh/config <<'C'
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
    IdentitiesOnly yes
C
# ssh finds ~/.ssh/config through the passwd entry, not $HOME, so point it at the
# sandbox copy. On your machine, plain `ssh` reads your real ~/.ssh/config.
ssh() { command ssh -T -F "$HOME/.ssh/config" "$@"; }
show "ssh -G github-personal | grep -E '^(hostname|user|identityfile|identitiesonly) '"

git init -q zRPC && cd zRPC || exit 1
git remote add origin git@github.com:jhaws1982/zRPC.git
run "git remote set-url origin git@github-personal:jhaws1982/zRPC.git"
show "git remote -v"
