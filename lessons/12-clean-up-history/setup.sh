#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
cd "$LAB" && lgit init -q sensor-fw && cd sensor-fw
commit main.c "init" "Initial commit"
lgit switch -q -c feature/adc-filter
commit filter.h "int filter(int x);" "Add filter interface"
commit filter.c "int filter(int x) { return x; }" "Implement moving average"
commit filter.c "/* window */" "wip"
commit test_filter.c "test" "Add filter tests"
commit window.h "#define WINDOW 4" "fixup! Implement moving average"
lgit rev-parse HEAD^{tree} > "$LAB/.expected-tree"
ready
