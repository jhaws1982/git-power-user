#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
cd "$LAB" && lgit init -q --bare server/sensor-fw.git
lgit clone -q server/sensor-fw.git sensor-fw 2>/dev/null && cd sensor-fw
commit main.c "init" "Initial commit"
lgit switch -q -c old/done && commit notes.txt "done" "Finished work" && lgit switch -q main && lgit merge -q --ff-only old/done
lgit push -q origin main
ready
