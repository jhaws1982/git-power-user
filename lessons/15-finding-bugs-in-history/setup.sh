#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
cd "$LAB" && lgit init -q sensor-fw && cd sensor-fw
printf '#define VREF_MV 3300\nint adc_read_mv(int raw) { return raw * VREF_MV / 4096; }\n' > adc.c
printf '#!/bin/sh\ngrep -q "VREF_MV 3300" adc.c\n' > test.sh && chmod +x test.sh
lgit add . && lgit commit -q -m "Add ADC driver"
lgit tag v1.0
bad=$(( (RANDOM % 25) + 3 ))
for i in $(seq 1 30); do
    if [ "$i" = "$bad" ]; then sed -i 's/VREF_MV 3300/VREF_MV 3000/' adc.c && lgit commit -qam "Tidy constants"
    else commit log.c "/* $i */" "Change $i"; fi
done
ready
