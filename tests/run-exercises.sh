#!/usr/bin/env bash
# For every lesson: build the lab, check that check.sh says "not yet", apply the
# reference solution in tests/solutions/, and check that check.sh now passes.
# usage: tests/run-exercises.sh [lessons/NN-name ...]
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
lessons=("$@"); [ ${#lessons[@]} -eq 0 ] && lessons=(lessons/*/)
export LAB_ROOT; LAB_ROOT=$(mktemp -d)
trap 'rm -rf "$LAB_ROOT"' EXIT
status=0
for l in "${lessons[@]}"; do
    l=${l%/}; name=${l##*/}
    [ -x "$l/setup.sh" ] || { echo "skip $name: no exercise"; continue; }
    if ! out=$("$l/setup.sh" 2>&1); then echo "FAIL $name: setup.sh failed"; sed 's/^/    /' <<<"$out"; status=1; continue; fi
    if "$l/check.sh" >/dev/null 2>&1; then echo "FAIL $name: check.sh passes before the exercise is done"; status=1; continue; fi
    if ! out=$(LAB="$LAB_ROOT/$name" GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 \
               GIT_AUTHOR_NAME=Solver GIT_AUTHOR_EMAIL=solver@example.com \
               GIT_COMMITTER_NAME=Solver GIT_COMMITTER_EMAIL=solver@example.com \
               bash -e "tests/solutions/$name.sh" 2>&1); then
        echo "FAIL $name: the reference solution failed"; sed 's/^/    /' <<<"$out"; status=1; continue
    fi
    if out=$("$l/check.sh" 2>&1); then echo "ok   $name: $out"
    else echo "FAIL $name: check.sh rejects the reference solution"; sed 's/^/    /' <<<"$out"; status=1; fi
done
exit $status
