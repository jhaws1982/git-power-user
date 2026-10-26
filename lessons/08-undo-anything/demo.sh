#!/usr/bin/env bash
# Lesson 8, undo anything: reproduces every transcript in the post.
# Runs in a throwaway HOME; ~/server/ is the remote. Safe to run on your own machine.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me
{
git init -q --bare server/sensor-fw.git
git clone -q server/sensor-fw.git sensor-fw 2>/dev/null; cd sensor-fw || exit 1
printf 'int main(void) { return 0; }\n' > main.c && git add . && git commit -qm "Initial commit" && tick
printf 'int uart_init(void) { return 0; }\n' > uart.c && git add . && git commit -qm "Add UART driver" && tick
printf 'int adc_read(void) { return 0; }\n' > adc.c && git add . && git commit -qm "Add ADC driver" && tick
git push -q -u origin main

# 1. Changes not committed yet: restore.
echo "/* experiment */" >> uart.c && echo "/* staged too */" >> adc.c && git add adc.c
run "git status --short"
run "git restore uart.c"
run "git restore --staged adc.c"
run "git status --short"
show "git restore adc.c && git status --short"

# 2. The last commit, kept as changes: reset --soft.
printf 'int wdt_kick(void) { return 0; }\n' > wdt.c && git add . && git commit -qm "Add watchdgo kick" && tick
run "git reset --soft HEAD~1"
run "git status --short"
show 'git commit -q -m "Add watchdog kick" && git log --oneline -1'

# 3. A reset --hard too far, and the reflog.
run "git reset --hard HEAD~2"
show "git log --oneline"
show "git reflog -4"
run "git reset --hard HEAD@{1}"
show "git log --oneline -1"

# 4. A deleted branch.
git switch -q -c experiment/dma && printf 'int dma_start(void) { return 0; }\n' > dma.c && git add . && git commit -qm "Try DMA for ADC" && tick
git switch -q main
dma=$(git rev-parse --short experiment/dma)
show "git branch -D experiment/dma"
show "git reflog | grep 'experiment/dma'"
run "git branch experiment/dma $dma"
show "git log --oneline -1 experiment/dma"

# 5. A merge you didn't mean to make (not pushed yet).
git switch -q -c feature/adc-filter && echo "/* filter */" >> adc.c && git commit -qam "Filter ADC samples" && tick
git switch -q main && echo "/* boot */" >> main.c && git commit -qam "Fix boot order" && tick
run "git merge --no-edit feature/adc-filter"
run "git reset --hard ORIG_HEAD"
show "git log --oneline -1"

# 6. A rebase that went wrong.
git switch -q feature/adc-filter
run "git rebase main"
show "git reflog -3 feature/adc-filter"
run "git reset --hard feature/adc-filter@{1}"
show "git log --oneline --graph --all -4"
git switch -q main

# 7. A file you deleted a few commits ago.
git rm -q uart.c && git commit -qm "Remove old UART driver" && tick
echo "/* more boot */" >> main.c && git commit -qam "Tidy boot" && tick
run "git log --oneline -1 -- uart.c"
run "git restore --source=HEAD~2 uart.c"
show "git status --short"
git restore --staged uart.c 2>/dev/null; rm -f uart.c

# 8. A stash you dropped.
echo "/* half-done calibration */" >> adc.c && git stash -q -m "calibration, half done"
st=$(git rev-parse --short stash@{0})
show "git stash drop"
show "git stash apply -q $st && git status --short"
} 2>&1 | server_urls
