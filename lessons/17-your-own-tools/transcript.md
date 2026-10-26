# Transcripts: Use Your Own Tools with git: core.editor, difftool, and mergetool

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ EDITOR=nano git var GIT_EDITOR
nano
$ git config --global core.editor "code --wait"
$ EDITOR=nano git var GIT_EDITOR
code --wait
$ GIT_EDITOR=vim git var GIT_EDITOR
vim
```

```console
$ git difftool --tool-help
'git difftool --tool=<tool>' may be set to one of the following:
		araxis           Use Araxis Merge (requires a graphical session)
		vimdiff          Use Vim

The following tools are valid, but not currently available:
		bc               Use Beyond Compare (requires a graphical session)
		bc3              Use Beyond Compare (requires a graphical session)
		bc4              Use Beyond Compare (requires a graphical session)
		...
		kdiff3           Use KDiff3 (requires a graphical session)
		meld             Use Meld (requires a graphical session)
		...
		winmerge         Use WinMerge (requires a graphical session)
```

```console
$ git difftool -y -x "diff -u"
--- /tmp/git-blob-i6rfo4/adc.c	2026-10-23 21:53:39.816754929 -0600
+++ src/adc.c	2026-10-23 21:53:39.816475791 -0600
@@ -1,4 +1,4 @@
 int adc_read_mv(int raw)
 {
-    return (int)(raw * 3300L / 4096);
+    return (int)(raw * 3000L / 4096);
 }
```

```console
$ git merge fix/full-scale
Auto-merging src/adc.c
CONFLICT (content): Merge conflict in src/adc.c
Automatic merge failed; fix conflicts and then commit the result.
$ cat src/adc.c
int adc_read_mv(int raw)
{
<<<<<<< HEAD
    return (int)(raw * 3000L / 4096 /* 12-bit */);
=======
    return (int)(raw * 3300L / 4095);
>>>>>>> fix/full-scale
}
```

```console
$ git config --global mergetool.peek.cmd '~/peek.sh "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
$ git config --global mergetool.peek.trustExitCode true
$ git mergetool --tool=peek
Merging:
src/adc.c

Normal merge conflict for 'src/adc.c':
  {local}: modified file
  {remote}: modified file
BASE   = ./src/adc_BASE_11584.c
LOCAL  = ./src/adc_LOCAL_11584.c
REMOTE = ./src/adc_REMOTE_11584.c
MERGED = src/adc.c
LOCAL has:      return (int)(raw * 3000L / 4096 /* 12-bit */);
REMOTE has:     return (int)(raw * 3300L / 4095);
```

```console
$ git status --short
?? src/adc.c.orig
```

```console
$ git switch fix/full-scale
Switched to branch 'fix/full-scale'
$ git rebase main
...
CONFLICT (content): Merge conflict in src/adc.c
error: could not apply 3ba4351... Use 4095 counts for full scale
...
$ git mergetool --tool=peek
...
LOCAL has:      return (int)(raw * 3000L / 4096 /* 12-bit */);
REMOTE has:     return (int)(raw * 3300L / 4095);
```
