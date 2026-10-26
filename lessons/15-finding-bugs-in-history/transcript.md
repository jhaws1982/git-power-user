# Transcripts: Find the Commit That Broke It: git bisect run, log -S, and blame

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ git log --oneline | wc -l
27

$ ./test.sh; echo "exit $?"
FAIL: full scale
exit 1
```

```console
$ git bisect start HEAD v1.0
Bisecting: 11 revisions left to test after this (roughly 4 steps)
[49351b38a6a608a5921009ff90b3b0e818497ea8] Add CRC-16
```

```console
$ git bisect run ./test.sh
running './test.sh'
ok
Bisecting: 5 revisions left to test after this (roughly 3 steps)
[268ad169a409049c72dd21548b689e217950326f] Report battery voltage
running './test.sh'
FAIL: full scale
Bisecting: 2 revisions left to test after this (roughly 2 steps)
[c857c32d0f45a3097d3e3e972efbc9d4c3f76744] Add sleep mode
running './test.sh'
FAIL: full scale
Bisecting: 0 revisions left to test after this (roughly 1 step)
[498d2c723da6a5e2133de7cc88df71caf220ed42] Tidy ADC constants
running './test.sh'
FAIL: full scale
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[fa272d6c8801692191d257061fd3d393b0d9783e] Check flash CRC on boot
running './test.sh'
ok
498d2c723da6a5e2133de7cc88df71caf220ed42 is the first bad commit
commit 498d2c723da6a5e2133de7cc88df71caf220ed42
Author: Jonathan Haws <jon@example.com>
Date:   Tue Oct 20 09:16:00 2026 -0600

    Tidy ADC constants

 adc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
bisect found first bad commit
```

```console
$ git bisect reset
Previous HEAD position was fa272d6 Check flash CRC on boot
Switched to branch 'main'
```

```console
$ git log -S'3000' --oneline
498d2c7 Tidy ADC constants
```

```console
$ git log -G'VREF_MV' --oneline
cf5bd05 Reformat adc.c
498d2c7 Tidy ADC constants
daf20c8 Add ADC driver and test
```

```console
$ git log -L :adc_read_mv:adc.c -s --oneline
cf5bd05 Reformat adc.c
daf20c8 Add ADC driver and test
```

```console
$ git blame -L 1,2 adc.c
498d2c72 (Jonathan Haws 2026-10-20 09:16:00 -0600 1) #define VREF_MV 3000  /* 3.0 V reference */
^daf20c8 (Jonathan Haws 2026-10-20 09:00:00 -0600 2) #define FULL_SCALE 4096
```

```console
$ git blame -L '/return/,+1' adc.c
cf5bd05d (Jonathan Haws 2026-10-20 09:21:00 -0600 6) 	return raw * VREF_MV / FULL_SCALE;
```

```console
$ git blame -w -L '/return/,+1' adc.c
^daf20c8 (Jonathan Haws 2026-10-20 09:00:00 -0600 6) 	return raw * VREF_MV / FULL_SCALE;
```

```console
$ git log --format=%H --grep='^Reformat' > .git-blame-ignore-revs
$ git config blame.ignoreRevsFile .git-blame-ignore-revs
$ git blame -L '/return/,+1' adc.c
^daf20c8 (Jonathan Haws 2026-10-20 09:00:00 -0600 6) 	return raw * VREF_MV / FULL_SCALE;
```
