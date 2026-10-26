#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
c=$LAB/clone
[ -d "$c/.git" ] || fail "clone the server repository to $c"
cd "$c" || exit 1
[ "$(lgit branch --show-current)" = smp ] || fail "check out the smp branch in the clone"
[ "$(lgit rev-parse --is-shallow-repository)" = true ] || fail "make it a shallow clone"
[ "$(lgit rev-list --count HEAD)" = 1 ] || fail "keep only the latest commit (depth 1)"
[ "$(lgit branch -r | grep -vc -- '->')" = 1 ] || fail "fetch only the smp branch, nothing else"
pass "one branch, one commit: the smallest clone that builds"
