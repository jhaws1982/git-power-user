#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
lab_env
cd "$LAB" && lgit init -q sensor-fw && (cd sensor-fw && commit main.c "init" "Initial commit")
ready
echo "First run: . $LAB/env.sh"
