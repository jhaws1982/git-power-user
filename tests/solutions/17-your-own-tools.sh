# A reference solution for lessons/17-your-own-tools: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
export GIT_CONFIG_GLOBAL="$LAB/home/.gitconfig"
git config --global diff.tool plain; git config --global difftool.plain.cmd 'diff -u "$LOCAL" "$REMOTE"'; git config --global difftool.prompt false
