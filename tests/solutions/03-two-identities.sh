# A reference solution for lessons/03-two-identities: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
export GIT_CONFIG_GLOBAL="$LAB/home/.gitconfig"
git config --global user.email jon@personal.example
printf '[user]\n\temail = jon@work.example\n' > "$LAB/home/.gitconfig-work"
work=$LAB/git/work; command -v cygpath >/dev/null && work=$(cygpath -m "$work")   # Git Bash on Windows
git config --global "includeIf.gitdir:$work/.path" "$LAB/home/.gitconfig-work"
