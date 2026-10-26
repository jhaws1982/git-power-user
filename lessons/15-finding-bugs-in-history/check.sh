#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
cd "$LAB/sensor-fw" || exit 1
[ -f ../answer.txt ] || fail "write the first bad commit's id to $LAB/answer.txt"
got=$(tr -d '[:space:]' < ../answer.txt)
[ ${#got} -ge 7 ] || fail "write at least 7 characters of the id"
c=$(lgit rev-parse -q --verify "$got^{commit}") || fail "$got isn't a commit in this repository"
[ "$(lgit log -1 --format=%s "$c")" = "Tidy constants" ] || fail "that commit isn't the one that broke test.sh"
[ -z "$(lgit bisect log 2>/dev/null)" ] || fail "found it; now end the session with git bisect reset"
pass "found the culprit"
