#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
cd "$LAB" && lgit init -q sensor-fw && cd sensor-fw
mkdir src
commit README.md "# sensor-fw" "Initial commit"
commit src/main.c "int main(void) { return 0; }" "Add main"
commit src/adc.c "int adc_read(void) { return 0; }" "Add ADC stub"
ready
