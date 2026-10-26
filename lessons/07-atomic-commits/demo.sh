#!/usr/bin/env bash
# Lesson 7, atomic commits with git add -p: reproduces every transcript in the post.
# Runs in a throwaway HOME; safe to run on your own machine. Needs make and a C compiler.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PTY="python3 $HERE/../../tests/pty_answer.py"
me
git init -q sensor-fw && cd sensor-fw || exit 1
mkdir -p src
cat > src/sensor.c <<'C'
#include "sensor.h"

static int read_raw(void)
{
    return hal_adc_read(SENSOR_CH);
}

int sensor_read_mv(void)
{
    int raw = read_raw();
    return raw * 3300 / 4096;
}

int sensor_is_valid(int mv)
{
    return mv > 0;
}
C
cat > src/sensor.h <<'C'
#ifndef SENSOR_H
#define SENSOR_H
#define SENSOR_CH 3
int hal_adc_read(int ch);
int sensor_read_mv(void);
int sensor_is_valid(int mv);
#endif
C
cat > Makefile <<'M'
CFLAGS ?= -Wall -Wextra -Werror -std=c11
all: build/sensor.o
build/sensor.o: src/sensor.c src/sensor.h
	@mkdir -p build
	$(CC) $(CFLAGS) -Isrc -c $< -o $@
.PHONY: all
M
printf 'build/\n' > .gitignore
git add . && git commit -qm "Add sensor driver" && tick

# Two unrelated edits in one file: the hunk add -p offers first.
python3 - <<'P'
from pathlib import Path
p = Path('src/sensor.c'); s = p.read_text()
s = s.replace("return raw * 3300 / 4096;", "return (int)(raw * 3300L / 4096);")
s = s.replace("return mv > 0;", "return mv > 0 && mv < 3300;")
p.write_text(s)
P
printf '$ git add -p src/sensor.c\n'
printf 'q\n' | git add -p src/sensor.c 2>&1; echo; echo
# Split it, stage the first half, commit each half separately.
printf 's\ny\nn\n' | git add -p src/sensor.c >/dev/null 2>&1
git commit -qm "Fix ADC scaling overflow on 16-bit int" && tick
git commit -qam "Reject readings above full scale" && tick

# Two adjacent edits: one hunk that can't be split.
python3 - <<'Q'
from pathlib import Path
p = Path('src/sensor.c'); s = p.read_text()
s = s.replace("    int raw = read_raw();\n", "    const int raw = read_raw();\n    hal_gpio_toggle(DEBUG_PIN); /* scope trigger */\n")
p.write_text(s)
Q
printf '$ git add -p src/sensor.c\n'
$PTY "Stage this hunk=s" "Stage this hunk=q" -- git add -p src/sensor.c
echo
# Stage only the const change by editing the hunk (e), as the post describes.
cat > "$HOME/edit-hunk.sh" <<'S'
#!/bin/sh
grep -v 'hal_gpio_toggle' "$1" > "$1.tmp" && mv "$1.tmp" "$1"
S
chmod +x "$HOME/edit-hunk.sh"
printf 'e\n' | GIT_EDITOR="$HOME/edit-hunk.sh" git add -p src/sensor.c >/dev/null 2>&1
run "git status --short"
run "git diff --staged"
show "git diff"
git restore src/sensor.c
git commit -qm "Make raw ADC reading const" && tick

# Undo a stage.
echo "scratch" > notes.txt
run "git add ."
run "git status --short"
run "git restore --staged notes.txt"
show "git status --short"
rm notes.txt

# Fix the last commit's message.
echo "int sensor_selftest(void);" >> src/sensor.h
git add src/sensor.h && git commit -qm "Add selftest prototyp" && tick
run "git log --oneline -1"
show 'git commit --amend -m "Add sensor_selftest prototype"'
tick

# Take the last commit apart, then put it back together.
git reset -q --soft HEAD~1
git commit -qm "Add sensor_selftest prototype" && tick
run "git reset --hard HEAD~1"
run "git reflog -3"
show "git reset --hard HEAD@{1}"

# Undo a commit that's already shared.
show "git revert --no-edit $(git log --format=%h --grep='Reject readings')"
tick

# Does every commit build? rebase -x runs make after each one.
git switch -qc selftest
python3 - <<'Q'
from pathlib import Path
p = Path('src/sensor.c')
p.write_text(p.read_text() + "\nint sensor_init(void)\n{\n    return sensor_calibrate();\n}\n")
Q
git commit -qam "Calibrate at init" && tick
python3 - <<'Q'
from pathlib import Path
h = Path('src/sensor.h'); h.write_text(h.read_text().replace("#endif", "int sensor_init(void);\nint sensor_calibrate(void);\n#endif"))
c = Path('src/sensor.c')
c.write_text(c.read_text() + "\nint sensor_calibrate(void)\n{\n    return sensor_is_valid(sensor_read_mv()) ? 0 : -1;\n}\n")
Q
git commit -qam "Add sensor_calibrate" && tick
run "git log --oneline main.."
show "make -s && echo OK"
show "git rebase -x 'make -s' main"
git rebase --abort

# Stash only what's staged.
git switch -q main
echo "/* wip a */" >> src/sensor.c; echo "/* wip b */" >> src/sensor.h
git add src/sensor.h
run 'git stash push --staged -m "header only"'
show "git status --short"
