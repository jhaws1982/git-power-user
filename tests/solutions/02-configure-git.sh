# A reference solution for lessons/02-configure-git: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
export GIT_CONFIG_GLOBAL="$LAB/home/.gitconfig"
git config --global user.name "Jon Example"; git config --global user.email jon@work.example
git config --global init.defaultBranch main; git config --global pull.ff only; git config --global fetch.prune true
git -C "$LAB/oss-project" config user.email jon@personal.example
