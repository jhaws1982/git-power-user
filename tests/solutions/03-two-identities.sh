# A reference solution for lessons/03-two-identities: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
export GIT_CONFIG_GLOBAL="$LAB/home/.gitconfig"
git config --global user.email jon@personal.example
printf '[user]\n\temail = jon@work.example\n' > "$LAB/home/.gitconfig-work"
git config --global "includeIf.gitdir:$LAB/git/work/.path" "$LAB/home/.gitconfig-work"
