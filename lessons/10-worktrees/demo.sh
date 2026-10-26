#!/usr/bin/env bash
# Lesson 10, git worktree: reproduces every transcript in the post.
# Runs in a throwaway HOME; safe to run on your own machine.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me
# --- a small firmware repo: every source file includes board.h ---
git init -q --bare server/sensor-fw.git
git clone -q server/sensor-fw.git sensor-fw 2>/dev/null; cd sensor-fw
mkdir -p src include
cat > include/board.h <<'H'
#ifndef BOARD_H
#define BOARD_H
#define CPU_HZ   25000000u
#define UART_BAUD 115200u
#define I2C_HZ   100000u
#endif
H
for m in uart i2c spi gpio timer tmp102 flash crc log; do
  printf '#include "board.h"\nint %s_init(void) { return (int)(CPU_HZ %% 7u); }\n' "$m" > "src/$m.c"
done
cat > src/main.c <<'C'
#include "board.h"
int uart_init(void); int i2c_init(void);
int main(void) { return uart_init() + i2c_init(); }
C
cat > CMakeLists.txt <<'C'
cmake_minimum_required(VERSION 3.25)
project(sensor_fw C)
add_executable(fw src/main.c src/uart.c src/i2c.c src/spi.c src/gpio.c src/timer.c
                  src/tmp102.c src/flash.c src/crc.c src/log.c)
target_include_directories(fw PRIVATE include)
C
printf 'build/\n' > .gitignore
git add -A && git commit -qm "Sensor firmware skeleton" && git push -q -u origin main 2>/dev/null
# a teammate's branch to review later
git switch -q -c feature/spi-dma && sed -i 's/return (int)(CPU_HZ % 7u)/return (int)(CPU_HZ % 5u)/' src/spi.c && git commit -qam "Use DMA for SPI" && git push -q -u origin feature/spi-dma 2>/dev/null
git switch -q main && git branch -q -D feature/spi-dma
# my feature branch: changes board.h, plus uncommitted work
git switch -q -c feature/adc-filter
sed -i 's/#define I2C_HZ   100000u/#define I2C_HZ   100000u\n#define ADC_SAMPLE_HZ 1000u/' include/board.h
printf '#include "board.h"\nint adc_init(void) { return (int)(ADC_SAMPLE_HZ %% 3u); }\n' > src/adc.c
sed -i 's#src/log.c)#src/log.c src/adc.c)#' CMakeLists.txt
git add -A && git commit -qm "Add ADC sample rate"
echo '/* filter coefficients: in progress */' >> src/adc.c
cmake -S . -B build -G Ninja >/dev/null && cmake --build build >/dev/null

{
echo "== the stash way =="
show "git status --short"
show "git stash"
show "git switch main"
show "cmake --build build | tail -1"
show "git switch feature/adc-filter && git stash pop | tail -1"
show "cmake --build build | tail -1"

echo "== the worktree way =="
show "git worktree add ../sensor-fw-hotfix -b fix/i2c-timeout main"
show "git worktree list"
show "cat ../sensor-fw-hotfix/.git"
show "git -C ../sensor-fw-hotfix rev-parse --git-path HEAD --git-path index --git-path refs/stash --git-path config --git-path hooks"
show "cd ../sensor-fw-hotfix"
sed -i 's/return (int)(CPU_HZ % 7u)/return (int)(CPU_HZ % 11u) \/* timeout fix *\//' src/i2c.c
show "git commit -qam 'Bound the I2C timeout' && git log --oneline -1"
show "cmake -S . -B build -G Ninja >/dev/null && cmake --build build | tail -1"
show "cd ../sensor-fw"
show "git status --short"
show "cmake --build build"
show "git log --oneline -1 fix/i2c-timeout"

echo "== one branch, one worktree =="
show "git switch fix/i2c-timeout"
show "git worktree add ../sensor-fw-again fix/i2c-timeout"

echo "== shared: the stash =="
show "git stash push -q -m 'adc filter, half done' && git -C ../sensor-fw-hotfix stash list"
git stash pop -q

echo "== reviewing a teammate's branch =="
show "git fetch -q && git worktree add --detach ../sensor-fw-review origin/feature/spi-dma"
show "git -C ../sensor-fw-review log --oneline -1"

echo "== the default branch name trap =="
show "git worktree add ../sensor-fw-tmp"
show "git branch --list 'sensor-fw-tmp'"
git worktree remove ../sensor-fw-tmp && git branch -q -D sensor-fw-tmp

echo "== cleaning up =="
show "git worktree list"
echo "notes" > ../sensor-fw-hotfix/notes.txt
show "git -C ../sensor-fw-hotfix status --short --ignored"
show "git worktree remove ../sensor-fw-hotfix"
show "rm ../sensor-fw-hotfix/notes.txt && git worktree remove ../sensor-fw-hotfix && git worktree list"
show "ls ../sensor-fw-hotfix"
show "rm -rf ../sensor-fw-review && git worktree list"
show "git worktree prune -v && git worktree list"
show "git branch --list 'fix/*'"
} 2>&1 | server_urls
