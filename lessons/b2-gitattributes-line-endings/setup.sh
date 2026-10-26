#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
cd "$LAB" && lgit init -q sensor-fw && cd sensor-fw
printf '#!/bin/sh\r\nmake -C fw\r\n' > build.sh
printf 'openocd -f board.cfg\r\n' > flash.bat
printf 'Bring-up notes\r\n' > notes.txt
printf 'int main(void) { return 0; }\n' > main.c
printf '\x7fCAL\x01\x02' > cal.bin
lgit add . && lgit commit -q -m "Initial commit"
ready
