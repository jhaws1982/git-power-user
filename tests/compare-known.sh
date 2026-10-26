#!/usr/bin/env bash
# The posts show git 2.43's output. Newer git words some messages differently, so
# against a newer git the lessons are compared with a recorded list of known
# differences instead: the run fails only when that list changes, which means a
# new git release changed something a post shows.
#   tests/compare-known.sh            compare with tests/known-differences/<git version>.txt,
#                                     or the newest recorded file if that version has none
#   tests/compare-known.sh --update   record this git version's differences
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
ver=$(git --version | awk '{print $3}')
known=tests/known-differences/$ver.txt
report=$(mktemp)
tests/run-all.sh > "$report" 2>&1
if [ "${1:-}" = --update ]; then
    cp "$report" "$known" && echo "recorded $known" && exit 0
fi
if [ ! -f "$known" ]; then
    latest=$(ls tests/known-differences/*.txt 2>/dev/null | sort -V | tail -1)
    [ -n "$latest" ] || { cat "$report"; echo "no known differences recorded yet"; exit 1; }
    echo "git $ver has no recorded differences; comparing with ${latest##*/}"
    known=$latest
fi
if diff -u "$known" "$report"; then
    echo "git $ver: output matches the recorded differences in ${known##*/}"
else
    echo "git $ver changed output the posts show (diff above). Check the posts, then run tests/compare-known.sh --update."
    exit 1
fi
