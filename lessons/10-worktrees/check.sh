#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
cd "$LAB/sensor-fw" || exit 1
wt=$LAB/sensor-fw-hotfix
[ -e "$wt/.git" ] || fail "add a worktree at $wt"
[ "$(lgit -C "$wt" branch --show-current)" = fix/i2c-timeout ] || fail "the worktree should be on a new branch fix/i2c-timeout"
[ "$(lgit merge-base fix/i2c-timeout main)" = "$(lgit rev-parse main)" ] && ! lgit merge-base --is-ancestor feature/adc-filter fix/i2c-timeout || fail "start fix/i2c-timeout from main, not from the feature branch"
[ "$(lgit branch --show-current)" = feature/adc-filter ] || fail "the main checkout should still be on feature/adc-filter"
grep -q "half-done" filter.c || fail "your uncommitted change in filter.c is gone"
pass "two branches checked out at once, and your half-done work untouched"
