#!/usr/bin/env bash
# Run every lesson's demo and check its transcripts. Exit non-zero if any fail.
# usage: tests/run-all.sh [lessons/NN-name ...]
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
lessons=("$@")
[ ${#lessons[@]} -eq 0 ] && lessons=(lessons/*/)
status=0
for l in "${lessons[@]}"; do
    [ -f "$l/demo.sh" ] && [ -f "$l/transcript.md" ] || { echo "skip ${l%/}: no demo yet"; continue; }
    python3 tests/check_lesson.py "$l" || status=1
done
exit $status
