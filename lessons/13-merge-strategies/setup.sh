#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
cd "$LAB" && lgit init -q sensor-fw && cd sensor-fw
commit main.c "init" "Initial commit"
lgit switch -q -c feature/adc-filter
commit filter.c "a" "Add filter stub"
commit filter.c "b" "Implement filter"
commit filter.c "c" "Fix typo"
lgit switch -q main
commit wdt.c "wdt" "Add watchdog"
base=$(lgit rev-parse HEAD)
lgit merge -q --no-edit feature/adc-filter && lgit rev-parse HEAD^{tree} > "$LAB/.expected-tree" && lgit reset -q --hard "$base"
echo "$base" > "$LAB/.base"
ready
