#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
cd "$LAB" && lgit init -q sensor-fw && cd sensor-fw
commit main.c "init" "Initial commit"
commit uart.c "uart" "Add UART driver"
lgit switch -q -c experiment/dma
commit adc.c "dma" "Try DMA for ADC"
lgit switch -q main
commit wdt.c "kick" "Add watchdog"
commit wdt.c "kick in idle" "Kick watchdog in idle"
lgit branch -q -D experiment/dma
lgit reset -q --hard HEAD~2
ready
