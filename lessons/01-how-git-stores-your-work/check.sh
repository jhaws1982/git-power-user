#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
cd "$LAB/sensor-fw" || exit 1
[ -f ../answer.txt ] || fail "write the id to $LAB/answer.txt"
want=$(lgit rev-parse 'HEAD~1:src')
got=$(tr -d '[:space:]' < ../answer.txt)
[ -n "$got" ] || fail "answer.txt is empty"
[ "${want#"$got"}" != "$want" ] && [ ${#got} -ge 7 ] || fail "that isn't the src tree of the second commit; try git cat-file -p HEAD~1, then follow the tree"
pass "that's the tree git stored for src/ in \"Add main\""
