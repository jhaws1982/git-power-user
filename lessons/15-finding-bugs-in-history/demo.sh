#!/usr/bin/env bash
# Lesson 15, finding where a bug came in: reproduces every transcript in the post.
# Builds a 27-commit history with one bad commit, then finds it with bisect run
# (using the post's test.sh, snippet 1), log -S/-G, blame, and log -L.
# Runs in a throwaway HOME; needs a C compiler.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me
git init -q sensor-fw && cd sensor-fw || exit 1
cat > adc.c <<'C'
#define VREF_MV 3300
#define FULL_SCALE 4096

int adc_read_mv(int raw)
{
    return raw * VREF_MV / FULL_SCALE;
}
C
cat > test_adc.c <<'C'
#include <stdio.h>
int adc_read_mv(int raw);
int main(void)
{
    if (adc_read_mv(4096) != 3300) { puts("FAIL: full scale"); return 1; }
    puts("ok");
    return 0;
}
C
snippet 1 > test.sh && chmod +x test.sh
printf 'build/\n' > .gitignore
git add . && git commit -qm "Add ADC driver and test" && tick
note() { echo "/* $1 */" >> log.c; git add log.c; git commit -qm "$1"; tick; }
for m in "Add log ring buffer" "Log ADC errors" "Add version banner"; do note "$m"; done
git tag -a v1.0 -m "Release 1.0"
for m in "Add UART console" "Echo console input" "Add help command" "Add I2C bus" "Read TMP102" \
         "Average temperature" "Add watchdog" "Kick watchdog in idle" "Add flash driver" \
         "Store calibration in flash" "Add CRC-16" "Check flash CRC on boot"; do note "$m"; done
# The bad commit: a "tidy-up" that changes the reference voltage.
sed -i 's/#define VREF_MV 3300/#define VREF_MV 3000  \/* 3.0 V reference *\//' adc.c
git commit -qam "Tidy ADC constants" && tick
for m in "Add sleep mode" "Wake on UART" "Add battery monitor" "Report battery voltage"; do note "$m"; done
# A whitespace-only reformat of adc.c.
sed -i 's|^    return raw \* VREF_MV / FULL_SCALE;|\treturn raw * VREF_MV / FULL_SCALE;|' adc.c
git commit -qam "Reformat adc.c" && tick
for m in "Add LED status" "Blink on error" "Add build info" "Update README" "Add release script"; do note "$m"; done

show "git log --oneline | wc -l"
show './test.sh; echo "exit $?"'
show "git bisect start HEAD v1.0"
show "git bisect run ./test.sh"
show "git bisect reset"

show "git log -S'3000' --oneline"
show "git log -G'VREF_MV' --oneline"
show "git log -L :adc_read_mv:adc.c -s --oneline"

show "git blame -L 1,2 adc.c"
show "git blame -L '/return/,+1' adc.c"
show "git blame -w -L '/return/,+1' adc.c"
run "git log --format=%H --grep='^Reformat' > .git-blame-ignore-revs"
run "git config blame.ignoreRevsFile .git-blame-ignore-revs"
show "git blame -L '/return/,+1' adc.c"
