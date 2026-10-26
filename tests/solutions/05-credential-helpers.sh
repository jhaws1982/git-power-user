# A reference solution for lessons/05-credential-helpers: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
export GIT_CONFIG_GLOBAL="$LAB/home/.gitconfig"
git config --global credential.helper 'cache --timeout=3600'
git config --global credential.https://git.internal.example.helper store
