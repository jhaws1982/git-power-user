#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
command -v ssh >/dev/null || fail "this lesson needs the ssh client installed"
cfg=$LAB/ssh_config
[ -f "$cfg" ] || fail "write the config to $cfg"
G=$(ssh -G -F "$cfg" github-personal 2>/dev/null) || fail "ssh can't read $cfg; run ssh -G -F $cfg github-personal to see why"
grep -qx 'hostname github.com' <<<"$G" || fail "github-personal should connect to HostName github.com"
grep -qx 'user git' <<<"$G" || fail "set User git"
grep -qx 'identitiesonly yes' <<<"$G" || fail "set IdentitiesOnly yes, so ssh offers only that key"
grep -Eq '^identityfile .*id_ed25519_personal$' <<<"$G" || fail "use IdentityFile ~/.ssh/id_ed25519_personal"
W=$(ssh -G -F "$cfg" github.com 2>/dev/null)
grep -Eq '^identityfile .*id_ed25519_personal$' <<<"$W" && fail "plain github.com should still use your default key"
pass "git@github-personal:you/repo.git will use your personal key"
