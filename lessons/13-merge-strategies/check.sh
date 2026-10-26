#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
cd "$LAB/sensor-fw" || exit 1
base=$(cat "$LAB/.base")
[ "$(lgit branch --show-current)" = main ] || fail "do the merge on main"
n=$(lgit rev-list --count "$base"..main)
[ "$n" -ge 1 ] || fail "main doesn't have the feature yet"
[ "$n" = 1 ] || fail "main should gain exactly one commit (a squash), not $n"
[ "$(lgit rev-list --parents -1 main | wc -w)" = 2 ] || fail "that's a merge commit; squash it into a normal commit instead"
[ "$(lgit log -1 --format=%s main)" = "Add ADC filter (#7)" ] || fail "use the message: Add ADC filter (#7)"
[ "$(lgit rev-parse main^{tree})" = "$(cat "$LAB/.expected-tree")" ] || fail "main's files don't match a full merge of the feature"
pass "one commit on main with the whole feature in it"
