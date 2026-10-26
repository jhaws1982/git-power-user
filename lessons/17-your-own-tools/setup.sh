#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
lab_env
cd "$LAB" && lgit init -q sensor-fw && cd sensor-fw
commit adc.c "return raw * 3300 / 4096;" "Add ADC"
sed -i 's/3300/3000/' adc.c
ready
echo "First run: . $LAB/env.sh"
