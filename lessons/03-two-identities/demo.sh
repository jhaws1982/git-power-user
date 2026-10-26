#!/usr/bin/env bash
# Lesson 3, two identities with includeIf: reproduces every transcript in the post.
# Runs in a throwaway HOME; safe to run on your own machine.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"

cat > ~/.gitconfig <<'G'
[user]
	name = Jonathan Haws
	email = jon@personal.example
[init]
	defaultBranch = main
[includeIf "gitdir:~/git/work/"]
	path = ~/.gitconfig-work
G
cat > ~/.gitconfig-work <<'G'
[user]
	email = jon@work.example
G
mkdir -p git/personal git/work
git init -q git/personal/blog
git init -q git/work/sensor-fw
mkdir -p git/work/sensor-fw/src

run "cd ~/git/personal/blog && git config user.email"
run "cd ~/git/work/sensor-fw && git config user.email"
run "cd ~/git/work/sensor-fw/src && git config user.email"
show "cd ~/git/work && git config user.email"

run "cd ~/git/work/sensor-fw"
run "git config --show-origin user.email"
show "git config -l --show-origin | grep -E 'email|includeif'"

run 'git commit -q --allow-empty -m "Initial commit"'
show "git log -1 --format='%an <%ae>'"

# The same rule without the trailing slash.
cd ~ && sed -i 's#gitdir:~/git/work/#gitdir:~/git/work#' ~/.gitconfig
run "grep includeIf ~/.gitconfig"
show "cd ~/git/work/sensor-fw && git config user.email"
cd ~ && sed -i 's#gitdir:~/git/work"#gitdir:~/git/work/"#' ~/.gitconfig

# Match on the remote URL instead of the folder.
cat >> ~/.gitconfig <<'G'
[includeIf "hasconfig:remote.*.url:git@github.com:acme/**"]
	path = ~/.gitconfig-work
G
run "git init -q ~/elsewhere/acme-tool && cd ~/elsewhere/acme-tool"
run "git config user.email"
run "git remote add origin git@github.com:acme/acme-tool.git"
show "git config user.email"
