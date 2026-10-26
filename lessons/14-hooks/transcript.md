# Transcripts: git Hooks: Check Formatting on Commit, Run Tests Before Push, and Share Them with Your Team

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ ls .git/hooks
applypatch-msg.sample
commit-msg.sample
fsmonitor-watchman.sample
post-update.sample
pre-applypatch.sample
pre-commit.sample
pre-merge-commit.sample
pre-push.sample
pre-rebase.sample
pre-receive.sample
prepare-commit-msg.sample
push-to-checkout.sample
sendemail-validate.sample
update.sample
```

```console
$ git add src/adc.c
$ git commit -m "Add ADC clamp helper"
pre-commit: src/adc.c is not clang-formatted (run: clang-format -i src/adc.c)
```

```console
$ clang-format -i src/adc.c
$ git add src/adc.c
$ git diff --cached
...
+int adc_clamp_mv(int mv)
+{
+    if (mv < 0)
+        return 0;
+    if (mv > 3300)
+        return 3300;
+    return mv;
+}
$ git commit -m "Add ADC clamp helper"
[main bf6e019] Add ADC clamp helper
 1 file changed, 9 insertions(+)
```

```console
$ git push
pre-push: running unit tests
FAIL: full scale
tests failed
make: *** [Makefile:3: test] Error 1
pre-push: tests failed, push aborted
error: failed to push some refs to 'example.com:jon/sensor-fw.git'
```

```console
$ git commit -m "fixed stuff."
commit-msg: start the subject with a capital letter
$ git commit -m "Document ADC header"
[main f969133] Document ADC header
 1 file changed, 1 insertion(+)
```

```console
$ ls .githooks
commit-msg
pre-commit
pre-push
$ git config core.hooksPath .githooks
```

```console
$ git config core.hooksPath || echo "(core.hooksPath not set)"
(core.hooksPath not set)
```

```console
$ git commit -m "lowercase subject."
hint: The '.githooks/commit-msg' hook was ignored because it's not set as executable.
hint: You can disable this warning with `git config advice.ignoredHook false`.
[main 6cf6f24] lowercase subject.
 1 file changed, 1 insertion(+)
```

```console
$ git commit --no-verify -m "Sloppy commit"
[main 89dd0e5] Sloppy commit
 1 file changed, 1 insertion(+)
```
