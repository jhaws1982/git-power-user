#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
cd "$LAB/sensor-fw" || exit 1
url=$(lgit remote get-url upstream 2>/dev/null) || fail "add a remote called upstream for the original project"
case $url in *upstream.git) ;; *) fail "upstream should point at $LAB/upstream.git";; esac
up=$(lgit -C "$LAB/upstream.git" rev-parse main)
[ "$(lgit rev-parse main)" = "$up" ] || fail "bring your main up to date with upstream/main"
[ "$(lgit -C "$LAB/fork.git" rev-parse main)" = "$up" ] || fail "push the updated main to your fork (origin)"
pass "your fork is in sync with the original project"
