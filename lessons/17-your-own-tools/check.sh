#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
cd "$LAB/sensor-fw" || exit 1
t=$(egit config --global diff.tool) || fail "set diff.tool to the name of your tool"
[ -n "$(egit config --global "difftool.$t.cmd")" ] || fail "define difftool.$t.cmd"
[ "$(egit config --global --bool difftool.prompt)" = false ] || fail "turn off the prompt before each file (difftool.prompt)"
out=$(egit difftool 2>&1 </dev/null)
grep -q '^-.*3300' <<<"$out" && grep -q '^+.*3000' <<<"$out" || fail "git difftool didn't print a unified diff; for this exercise use diff -u \"\$LOCAL\" \"\$REMOTE\" as the command"
pass "git difftool runs your own command"
