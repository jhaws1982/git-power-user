#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
g() { egit config --global "$@"; }
[ -n "$(g user.name)" ] && [ -n "$(g user.email)" ] || fail "set a global user.name and user.email (after sourcing env.sh)"
[ "$(g init.defaultBranch)" = main ] || fail "set the global init.defaultBranch to main"
[ "$(g pull.ff)" = only ] || fail "make git pull refuse to create merge commits (pull.ff)"
[ "$(g fetch.prune)" = true ] || fail "make fetch prune deleted remote branches"
cd "$LAB/oss-project" || exit 1
local_email=$(GIT_CONFIG_GLOBAL=/dev/null git config --local user.email)
[ -n "$local_email" ] || fail "give oss-project its own user.email, in its local config"
[ "$local_email" != "$(g user.email)" ] || fail "oss-project's email should differ from your global one"
[ "$(egit config user.email)" = "$local_email" ] || fail "inside oss-project, git config user.email should show the local email"
pass "global defaults set, and oss-project overrides your email locally"
