#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
cd "$LAB/sensor-fw" || exit 1
[ "$(GIT_CONFIG_GLOBAL=/dev/null git config --local core.hooksPath)" = .githooks ] || fail "point core.hooksPath at .githooks so the hooks can be committed and shared"
h=.githooks/commit-msg
[ -f "$h" ] || fail "write the hook as $h"
[ -x "$h" ] || fail "make $h executable (git ignores it otherwise)"
lgit ls-files --error-unmatch "$h" >/dev/null 2>&1 || fail "commit $h so the team gets it"
t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
lgit clone -q . "$t/c" 2>/dev/null
tg() { GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t git -C "$t/c" -c core.hooksPath=.githooks "$@"; }
tg commit -q --allow-empty -m "fixed stuff" >/dev/null 2>&1 && fail "a lowercase subject got through"
tg commit -q --allow-empty -m "Fix ADC offset" >/dev/null 2>&1 || fail "a subject starting with a capital letter was rejected"
pass "the hook is shared through the repository and does its job"
