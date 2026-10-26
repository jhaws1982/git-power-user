#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
cd "$LAB/sensor-fw" || exit 1
[ -z "$(lgit status --porcelain)" ] || fail "commit both changes; the working tree isn't clean yet"
[ "$(lgit rev-list --count HEAD)" = 3 ] || fail "make exactly two new commits, one per change"
a=$(lgit show HEAD~1 --format= -U0 | grep -c '^[-+] '); b=$(lgit show HEAD --format= -U0 | grep -c '^[-+] ')
[ "$a" = 2 ] && [ "$b" = 2 ] || fail "each commit should change one line (one hunk); use git add -p"
lgit show HEAD~1 --format= | grep -q '3300L' && first=scale || first=range
lgit show HEAD --format= | grep -q '3300L' && second=scale || second=range
[ "$first" != "$second" ] || fail "the two commits should hold different changes"
pass "two commits, one purpose each"
