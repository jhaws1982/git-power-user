#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
cd "$LAB/sensor-fw" || exit 1
lgit rev-parse -q --verify refs/heads/feature/led >/dev/null || fail "create a branch called feature/led"
[ "$(lgit rev-list --count main..feature/led)" -ge 1 ] || fail "commit something on feature/led"
[ "$(lgit rev-parse --abbrev-ref feature/led@{upstream} 2>/dev/null)" = origin/feature/led ] || fail "push feature/led and set its upstream (git push -u)"
[ "$(lgit -C "$LAB/server/sensor-fw.git" rev-parse -q --verify refs/heads/feature/led)" = "$(lgit rev-parse feature/led)" ] || fail "the server's feature/led doesn't match yours; push again"
lgit rev-parse -q --verify refs/heads/old/done >/dev/null && fail "old/done is merged; delete it with git branch -d"
pass "branch made, shared with upstream tracking, and the merged one cleaned up"
