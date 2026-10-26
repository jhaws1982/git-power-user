#!/usr/bin/env bash
# Lesson 14, git hooks: reproduces every transcript in the post.
# Runs in a throwaway HOME; ~/server/ stands in for git@example.com:jon/.
# Needs clang-format, make and a C compiler.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me
export GIT_AUTHOR_DATE="2026-10-23T09:00:00-0600" GIT_COMMITTER_DATE="2026-10-23T09:00:00-0600"
{
git init -q --bare server/sensor-fw.git
git clone -q server/sensor-fw.git sensor-fw 2>/dev/null; cd sensor-fw || exit 1
show "ls .git/hooks"

# The project, and the three hooks from the post, in a versioned .githooks folder.
mkdir -p src .githooks
snippet 2 > .clang-format
cat > src/adc.c <<'C'
#include "adc.h"

int adc_read_mv(int raw)
{
    return (int)(raw * 3300L / 4096);
}
C
cat > src/adc.h <<'C'
#ifndef ADC_H
#define ADC_H
int adc_read_mv(int raw);
#endif
C
cat > Makefile <<'M'
CFLAGS ?= -Wall -Wextra -Werror -std=c11
test: build/test_adc
	./build/test_adc
build/test_adc: src/adc.c tests/test_adc.c
	@mkdir -p build
	$(CC) $(CFLAGS) -Isrc $^ -o $@
.PHONY: test
M
mkdir -p tests; cat > tests/test_adc.c <<'C'
#include "adc.h"
#include <stdio.h>
int main(void)
{
    int fails = 0;
    if (adc_read_mv(0) != 0) { puts("FAIL: 0 counts"); fails++; }
    if (adc_read_mv(4096) != 3300) { puts("FAIL: full scale"); fails++; }
    puts(fails ? "tests failed" : "all tests passed");
    return fails;
}
C
clang-format -i tests/test_adc.c src/adc.c src/adc.h
printf 'build/\n' > .gitignore
snippet 1 > .githooks/pre-commit   # the hooks are the post's own code
snippet 4 > .githooks/commit-msg
snippet 3 > .githooks/pre-push
chmod +x .githooks/*
run "ls .githooks"
show "git config core.hooksPath .githooks"
git add . && git commit -qm "Add ADC driver, tests, and shared hooks"
git push -q -u origin main 2>&1

# pre-commit: a badly formatted function.
cat >> src/adc.c <<'C'

int adc_clamp_mv(int mv) {
  if (mv<0) return 0;
  if (mv>3300) return 3300;
  return mv;
}
C
run "git add src/adc.c"
show 'git commit -m "Add ADC clamp helper"'
run "clang-format -i src/adc.c"
run "git add src/adc.c"
run "git diff --cached"
show 'git commit -m "Add ADC clamp helper"'

# commit-msg
echo "/* note */" >> src/adc.h && git add src/adc.h
run 'git commit -m "fixed stuff."'
show 'git commit -m "Document ADC header"'

# pre-push: a change that breaks the scaling test.
sed -i 's/3300L/3000L/' src/adc.c && git commit -qam "Scale ADC to 3.0 V reference"
show "git push"
git revert -q --no-edit HEAD && git push -q 2>/dev/null

# --no-verify skips the hooks.
echo "int  x ;" >> src/adc.c && git add src/adc.c
show 'git commit --no-verify -m "Sloppy commit"'
git reset -q --hard HEAD~1

# A fresh clone doesn't run the hooks until you opt in.
cd "$HOME" && git clone -q server/sensor-fw.git fresh 2>/dev/null && cd fresh || exit 1
show 'git config core.hooksPath || echo "(core.hooksPath not set)"'

# A hook that isn't executable is skipped, with a hint.
cd "$HOME/sensor-fw" && chmod -x .githooks/commit-msg
echo "/* x */" >> src/adc.h && git add src/adc.h
show 'git commit -m "lowercase subject."'
chmod +x .githooks/commit-msg
} 2>&1 | server_urls
