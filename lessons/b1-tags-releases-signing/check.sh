#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
cd "$LAB/sensor-fw" || exit 1
lgit rev-parse -q --verify refs/tags/v1.0 >/dev/null || fail "create a tag called v1.0"
[ "$(lgit cat-file -t v1.0)" = tag ] || fail "v1.0 is a lightweight tag; make it annotated (-a, with a message)"
[ "$(lgit log -1 --format=%s 'v1.0^{commit}')" = "Prepare release 1.0" ] || fail "tag the commit \"Prepare release 1.0\", not the latest one"
[ "$(lgit -C "$LAB/server/sensor-fw.git" rev-parse -q --verify refs/tags/v1.0)" = "$(lgit rev-parse v1.0)" ] || fail "push the tag to origin"
[ "$(lgit describe main)" = "$(printf 'v1.0-1-g%s' "$(lgit rev-parse --short main)")" ] || fail "git describe main should now say v1.0-1-g..."
pass "release 1.0 is tagged, annotated, and on the server"
