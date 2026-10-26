#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Tells you whether the lab exercise is done, or what's still missing.
need_lab
cd "$LAB/sensor-fw" || exit 1
[ "$(lgit log -1 --format=%s main)" = "Kick watchdog in idle" ] || fail "main lost two commits to a reset --hard; git reflog shows where it was"
[ -z "$(lgit status --porcelain)" ] || fail "leave the working tree clean"
lgit rev-parse -q --verify refs/heads/experiment/dma >/dev/null || fail "experiment/dma was deleted; bring it back"
[ "$(lgit log -1 --format=%s experiment/dma)" = "Try DMA for ADC" ] || fail "experiment/dma should point at \"Try DMA for ADC\""
pass "both recovered from the reflog"
