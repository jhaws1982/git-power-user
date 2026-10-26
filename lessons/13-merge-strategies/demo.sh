#!/usr/bin/env bash
# Lesson 13, merge commit, rebase, or squash: reproduces every transcript in the post.
# Runs in a throwaway HOME; safe to run on your own machine.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me
git config --global merge.log false
export GIT_EDITOR=true   # accept git's default merge message, as pressing save would
export GIT_AUTHOR_DATE="2026-10-23T09:00:00-0600" GIT_COMMITTER_DATE="2026-10-23T09:00:00-0600"

# The same starting point for every strategy: main and a feature branch that diverged.
setup() {
    cd "$HOME" && git init -q "$1" && cd "$1" || exit 1
    echo "int main(void) { return 0; }" > main.c; git add .; git commit -qm "Initial commit"
    echo "/* boot */" > boot.c; git add .; git commit -qm "Add boot sequence"
    git switch -qc feature/adc-filter
    echo "int adc_filter(int x);" > filter.h; git add .; git commit -qm "Add filter interface"
    echo "int adc_filter(int x) { return x; }" > filter.c; git add .; git commit -qm "Implement moving average"
    echo "/* test */" > test_filter.c; git add .; git commit -qm "Test the filter"
    git switch -q main
    echo "/* wdt */" > wdt.c; git add .; git commit -qm "Kick watchdog"
    echo "/* uart */" > uart.c; git add .; git commit -qm "Fix UART timeout"
}

setup start
show "git log --oneline --graph --all"

setup merge-commit
run "git merge --no-ff feature/adc-filter"
show "git log --oneline --graph"
show "git log --oneline --first-parent"
show "git revert -m 1 --no-edit $(git rev-parse --short HEAD)"

setup ff-only
show "git merge --ff-only feature/adc-filter"

setup rebase-ff
run "git switch feature/adc-filter"
run "git rebase main"
run "git switch main"
run "git merge --ff-only feature/adc-filter"
show "git log --oneline --graph"

setup semi-linear
git switch -q feature/adc-filter && git rebase -q main && git switch -q main
git merge -q --no-ff feature/adc-filter
show "git log --oneline --graph"

setup squash
run "git merge --squash feature/adc-filter"
run 'git commit -m "Add ADC moving-average filter (#42)"'
show "git log --oneline --graph"
show "git branch -d feature/adc-filter"
