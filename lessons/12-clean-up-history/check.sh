#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
cd "$LAB/sensor-fw" || exit 1
subjects=$(lgit log --format=%s --reverse main..feature/adc-filter | paste -sd '|')
[ "$(lgit rev-parse feature/adc-filter^{tree})" = "$(cat "$LAB/.expected-tree")" ] || fail "the code at the tip changed; a cleanup should only change history (git reset --hard feature/adc-filter@{1} to start over)"
[ "$subjects" = "Add filter interface|Implement moving average|Add filter tests" ] || fail "the branch should be three commits: Add filter interface, Implement moving average, Add filter tests (now: ${subjects//|/, })"
pass "three commits, one purpose each, same code"
