#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
cd "$LAB/sensor-fw" || exit 1
[ -f .gitattributes ] && lgit ls-files --error-unmatch .gitattributes >/dev/null 2>&1 || fail "add and commit a .gitattributes file"
attr() { lgit check-attr "$1" -- "$2" | awk -F': ' '{print $3}'; }
[ "$(attr eol build.sh)" = lf ] || fail "shell scripts should always check out with LF (eol=lf)"
[ "$(attr eol flash.bat)" = crlf ] || fail "batch files should always check out with CRLF (eol=crlf)"
[ "$(attr text cal.bin)" = unset ] || fail "mark *.bin as binary"
[ "$(attr text notes.txt)" = auto ] || [ "$(attr text notes.txt)" = set ] || fail "let git normalize everything else (* text=auto)"
lgit ls-files --eol | grep -q '^i/crlf' && fail "the repository still stores CRLF; git add --renormalize . and commit"
[ -z "$(lgit status --porcelain)" ] || fail "commit your changes"
pass "LF in the repository, and the right endings in every checkout"
