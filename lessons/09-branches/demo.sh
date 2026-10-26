#!/usr/bin/env bash
# Lesson 9, branches day to day: reproduces every transcript in the post.
# Runs in a throwaway HOME; ~/server/ stands in for git@example.com:jon/.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me
{
git init -q --bare server/sensor-fw.git
git clone -q server/sensor-fw.git sensor-fw 2>/dev/null; cd sensor-fw || exit 1
printf 'int main(void) { return 0; }\n' > main.c; printf '# sensor-fw\n' > README.md
git add . && git commit -qm "Initial commit" && git push -q -u origin main && tick

show "git switch -c feature/adc-filter"
printf 'int adc_filter(int x) { return x; }\n' > filter.c
git add filter.c && git commit -qm "Add ADC filter stub" && tick
printf '\nThe ADC filter lives in filter.c.\n' >> README.md && git commit -qam "Document the filter" && tick
run "git log --oneline --graph --all --decorate"
show "git branch -v"

# An uncommitted change that doesn't conflict comes along when you switch.
echo "/* todo */" >> main.c
show "git switch main"
git switch -q feature/adc-filter && git restore main.c
# One that conflicts stops the switch.
echo "More notes." >> README.md
show "git switch main"
git restore README.md

run "git push -u origin feature/adc-filter"
show "git branch -vv"

# A teammate pushes two commits to main.
cd "$HOME" && git clone -q server/sensor-fw.git teammate && cd teammate || exit 1
git config user.name "Teammate"; git config user.email "t@example.com"
echo "/* init order */" >> main.c && git commit -qam "Fix startup order" && tick
echo "/* wdt */" >> main.c && git commit -qam "Add watchdog kick" && git push -q && tick

cd "$HOME/sensor-fw" && git switch -q main
run "git fetch"
run "git status"
show "git log --oneline main..origin/main"
show "git pull --ff-only"

git switch -q feature/adc-filter
run "git rebase main"
show "git log --oneline --graph --decorate --all"
run "git push"
show "git push --force-with-lease"

git switch -q main
show "git merge feature/adc-filter"
git push -q
git switch -q -c experiment/dma; echo "int d;" > dma.c; git add dma.c; git commit -qm "Try DMA"; git switch -q main; tick
run "git branch -d feature/adc-filter"
show "git branch -d experiment/dma"
run "git branch --merged"
show "git branch --no-merged"

run "git push origin --delete feature/adc-filter"
cd "$HOME/teammate" && git fetch -q
show "git fetch --prune"

cd "$HOME/sensor-fw" && git config --global push.autoSetupRemote true
git switch -q -c fix/uart-timeout; echo "int u;" > uart.c; git add uart.c; git commit -qm "Fix UART timeout"; tick
git push -q 2>/dev/null
run "git worktree add ../sensor-fw-main main"
show "git worktree list"
} 2>&1 | server_urls
