#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
cd "$LAB" && lgit init -q sensor-fw && cd sensor-fw
commit main.c "init" "Initial commit"
lgit switch -q -c feature/adc-filter
commit filter.c "filter" "Add filter"
echo "/* half-done work */" >> filter.c
ready
