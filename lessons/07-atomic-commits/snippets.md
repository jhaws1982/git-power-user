# Code from the post (not transcripts), numbered for demo.sh's `snippet N`

## snippet 1
```console
(1/1) Stage this hunk [y,n,q,a,d,s,e,?]? s
Split into 2 hunks.
@@ -8,8 +8,8 @@ static int read_raw(void)
 int sensor_read_mv(void)
 {
     int raw = read_raw();
-    return raw * 3300 / 4096;
+    return (int)(raw * 3300L / 4096);
 }
 
 int sensor_is_valid(int mv)
 {
(1/2) Stage this hunk [y,n,q,a,d,j,J,g,/,e,?]? y
@@ -12,6 +12,6 @@
 }
 
 int sensor_is_valid(int mv)
 {
-    return mv > 0;
+    return mv > 0 && mv < 3300;
 }
(2/2) Stage this hunk [y,n,q,a,d,K,g,/,e,?]? n
```

## snippet 2
```diff
# Manual hunk edit mode -- see bottom for a quick guide.
@@ -7,7 +7,8 @@ static int read_raw(void)
 
 int sensor_read_mv(void)
 {
-    int raw = read_raw();
+    const int raw = read_raw();
+    hal_gpio_toggle(DEBUG_PIN); /* scope trigger */
     return (int)(raw * 3300L / 4096);
 }
 
# ---
# To remove '-' lines, make them ' ' lines (context).
# To remove '+' lines, delete them.
# Lines starting with # will be removed.
```

## snippet 3
```bash
git stash push --keep-index   # set aside everything that isn't staged
make                          # build and test what will be committed
git stash pop                 # bring the rest back
```
