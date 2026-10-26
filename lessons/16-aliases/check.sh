#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
a() { egit config --global "alias.$1"; }
[ "$(a st)" = "status -sb" ] || fail "make git st run status -sb"
[ "$(a unstage)" = "restore --staged" ] || fail "make git unstage run restore --staged"
[ -n "$(a last)" ] || fail "add a git last alias that shows the latest commit"
cd "$LAB/sensor-fw" || exit 1
egit last 2>/dev/null | grep -q "Initial commit" || fail "git last should show the latest commit"
pass "three aliases that earn their keep"
