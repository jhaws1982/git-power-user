# A reference solution for lessons/16-aliases: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
export GIT_CONFIG_GLOBAL="$LAB/home/.gitconfig"
git config --global alias.st 'status -sb'; git config --global alias.unstage 'restore --staged'; git config --global alias.last 'log -1 --stat'
