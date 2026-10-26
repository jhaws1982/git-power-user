#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
lab_env
mkdir -p "$LAB/git/work" "$LAB/git/personal"
(cd "$LAB/git/work" && lgit init -q sensor-fw)
(cd "$LAB/git/personal" && lgit init -q blog)
ready
echo "First run: . $LAB/env.sh"
echo "Work repos live under $(gitpath "$LAB/git/work")/ (write the gitdir: path exactly like that)"
