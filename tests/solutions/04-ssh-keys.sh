# A reference solution for lessons/04-ssh-keys: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
cat > "$LAB/ssh_config" <<'C'
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
    IdentitiesOnly yes
C
