#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
cd "$LAB" && lgit init -q --bare upstream.git && lgit init -q --bare fork.git
lgit clone -q upstream.git seed 2>/dev/null && (cd seed && commit main.c "init" "Initial commit" && lgit push -q origin main)
lgit -C fork.git fetch -q ../upstream.git main:main
lgit clone -q fork.git sensor-fw 2>/dev/null
(cd seed && commit main.c "fix" "Fix boot order" && commit wdt.c "wdt" "Add watchdog" && lgit push -q origin main)
rm -rf seed
ready
echo "Your fork: $LAB/fork.git (origin). The original project: $LAB/upstream.git"
