#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
h() { egit config --get-urlmatch credential.helper "$1"; }
[ -n "$(h https://example.com/)" ] || fail "set a default credential.helper"
case $(h https://example.com/) in cache*) ;; *) fail "the default helper should be cache (in memory), not $(h https://example.com/)";; esac
case $(h https://example.com/) in *timeout=3600*) ;; *) fail "keep cached credentials for an hour: cache --timeout=3600";; esac
[ "$(h https://git.internal.example/team/repo.git)" = store ] || fail "https://git.internal.example should use the store helper (credential.https://git.internal.example.helper)"
pass "an hour in memory by default, and a stored login for git.internal.example"
