# Transcripts: Atomic Commits with git add -p: Stage, Restore, and Undo Without Fear

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ git add -p src/sensor.c
diff --git a/src/sensor.c b/src/sensor.c
index 474b62a..5209e12 100644
--- a/src/sensor.c
+++ b/src/sensor.c
@@ -8,10 +8,10 @@ static int read_raw(void)
 int sensor_read_mv(void)
 {
     int raw = read_raw();
-    return raw * 3300 / 4096;
+    return (int)(raw * 3300L / 4096);
 }
 
 int sensor_is_valid(int mv)
 {
-    return mv > 0;
+    return mv > 0 && mv < 3300;
 }
(1/1) Stage this hunk [y,n,q,a,d,s,e,?]?
```

```console
$ git add -p src/sensor.c
...
@@ -7,7 +7,8 @@ static int read_raw(void)
 
 int sensor_read_mv(void)
 {
-    int raw = read_raw();
+    const int raw = read_raw();
+    hal_gpio_toggle(DEBUG_PIN); /* scope trigger */
     return (int)(raw * 3300L / 4096);
 }
 
(1/1) Stage this hunk [y,n,q,a,d,e,?]? s
Sorry, cannot split this hunk
...
```

```console
$ git status --short
MM src/sensor.c
$ git diff --staged
...
@@ -7,7 +7,7 @@ static int read_raw(void)
 
 int sensor_read_mv(void)
 {
-    int raw = read_raw();
+    const int raw = read_raw();
     return (int)(raw * 3300L / 4096);
 }
 
$ git diff
...
@@ -8,6 +8,7 @@ static int read_raw(void)
 int sensor_read_mv(void)
 {
     const int raw = read_raw();
+    hal_gpio_toggle(DEBUG_PIN); /* scope trigger */
     return (int)(raw * 3300L / 4096);
 }
```

```console
$ git log --oneline main..
9fafbf3 Add sensor_calibrate
35606b5 Calibrate at init
$ make -s && echo OK
OK
```

```console
$ git rebase -x 'make -s' main
Executing: make -s
src/sensor.c: In function 'sensor_init':
src/sensor.c:21:12: error: implicit declaration of function 'sensor_calibrate' [-Werror=implicit-function-declaration]
   21 |     return sensor_calibrate();
      |            ^~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
make: *** [Makefile:5: build/sensor.o] Error 1
warning: execution failed: make -s
You can fix the problem, and then run

  git rebase --continue
```

```console
$ git add .
$ git status --short
A  notes.txt
$ git restore --staged notes.txt
$ git status --short
?? notes.txt
```

```console
$ git log --oneline -1
abac07d Add selftest prototyp
$ git commit --amend -m "Add sensor_selftest prototype"
[main 4cf2459] Add sensor_selftest prototype
 Date: Fri Oct 23 21:17:36 2026 -0600
 1 file changed, 1 insertion(+)
```

```console
$ git revert --no-edit a115346
Auto-merging src/sensor.c
[main 944e60c] Revert "Reject readings above full scale"
 Date: Fri Oct 23 21:17:36 2026 -0600
 1 file changed, 1 insertion(+), 1 deletion(-)
```

```console
$ git reset --hard HEAD~1
HEAD is now at 8696d19 Make raw ADC reading const
$ git reflog -3
8696d19 HEAD@{0}: reset: moving to HEAD~1
4cf2459 HEAD@{1}: commit: Add sensor_selftest prototype
8696d19 HEAD@{2}: reset: moving to HEAD~1
$ git reset --hard HEAD@{1}
HEAD is now at 4cf2459 Add sensor_selftest prototype
```

```console
$ git stash push --staged -m "header only"
Saved working directory and index state On main: header only
$ git status --short
 M src/sensor.c
```
