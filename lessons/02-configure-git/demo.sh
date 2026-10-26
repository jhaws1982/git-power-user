#!/usr/bin/env bash
# Lesson 2, configuring git: reproduces every transcript in the post.
# Runs in a throwaway HOME; safe to run on your own machine.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"

git config --global user.name "Jonathan Haws"
git config --global user.email "jon@work.example"
git config --global init.defaultBranch main
git init -q firmware && cd firmware || exit 1
git config user.email "jon@personal.example"

show "git config --list --show-origin --show-scope"
show "git config --show-origin --show-scope user.email"
show "git -c user.email=ci-bot@example.com config user.email"

# A server and two clones, to show pull.ff and push.autoSetupRemote.
cd "$HOME" || exit 1
git init -q --bare server.git
git clone -q server.git a 2>/dev/null && cd a && echo 1 > f && git add f && git commit -qm one && git push -q origin main 2>/dev/null
git switch -qc fix-uart-overrun && echo 2 >> f && git commit -qam two
show "git push"
printf '$ git config --global push.autoSetupRemote true\n'
git config --global push.autoSetupRemote true
show "git push"
# Diverge main: a teammate pushes, we commit locally, then pull with pull.ff=only.
cd "$HOME" && git clone -q server.git b && cd b && echo b >> f && git commit -qam from-b && git push -q 2>/dev/null
cd "$HOME/a" && git switch -q main && echo a >> f && git commit -qam from-a
git config --global pull.ff only
git fetch -q    # the post shows pull after a fetch, so no "From ..." lines
show "git pull"
