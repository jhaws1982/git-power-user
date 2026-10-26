#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
cd "$LAB" && lgit init -q --bare server/kernel.git
lgit clone -q server/kernel.git work 2>/dev/null && cd work
for i in $(seq 1 20); do commit kernel.c "/* change $i */" "Change $i"; done
lgit push -q origin main
lgit switch -q -c smp
for i in 1 2 3; do commit smp.c "/* smp $i */" "SMP change $i"; done
lgit push -q origin smp
cd .. && rm -rf work
ready
echo "The server repository is $LAB/server/kernel.git; clone it to $LAB/clone"
