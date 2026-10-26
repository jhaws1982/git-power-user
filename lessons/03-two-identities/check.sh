#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
w=$(cd "$LAB/git/work/sensor-fw" && egit config user.email)
p=$(cd "$LAB/git/personal/blog" && egit config user.email)
[ -n "$p" ] || fail "set your personal email as the global user.email"
[ -n "$w" ] && [ "$w" != "$p" ] || fail "repos under $LAB/git/work/ should get a different email; add an includeIf \\"gitdir:$LAB/git/work/\\" section to the global config"
for r in "$LAB/git/work/sensor-fw" "$LAB/git/personal/blog"; do
    [ -z "$(GIT_CONFIG_GLOBAL=/dev/null git -C "$r" config --local user.email)" ] || fail "do it with includeIf, not a local user.email in $(basename "$r")"
done
pass "work repos commit as $w, everything else as $p"
