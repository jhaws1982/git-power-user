#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
lab_env
mkdir -p "$LAB/git/work" "$LAB/git/personal"
(cd "$LAB/git/work" && lgit init -q sensor-fw)
(cd "$LAB/git/personal" && lgit init -q blog)
ready
echo "First run: . $LAB/env.sh   (work repos live under $LAB/git/work/)"
