# Transcripts: Working with git Remotes: Sync a Fork and Pull In a Teammate's Branch

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ git remote -v
origin	git@github.com:jhaws1982/sensor-fw.git (fetch)
origin	git@github.com:jhaws1982/sensor-fw.git (push)
```

```console
$ git remote add upstream https://github.com/acme/sensor-fw.git
$ git remote -v
origin	git@github.com:jhaws1982/sensor-fw.git (fetch)
origin	git@github.com:jhaws1982/sensor-fw.git (push)
upstream	https://github.com/acme/sensor-fw.git (fetch)
upstream	https://github.com/acme/sensor-fw.git (push)
```

```console
$ git remote set-url --push upstream no_push
$ git push upstream main
fatal: 'no_push' does not appear to be a git repository
fatal: Could not read from remote repository.
```

```console
$ git fetch upstream
From https://github.com/acme/sensor-fw
 * [new branch]      main       -> upstream/main
$ git log --oneline main..upstream/main
92ed894 Add watchdog driver
739d7a8 Release v1.1
```

```console
$ git merge --ff-only upstream/main
Updating a344b40..92ed894
Fast-forward
 main.c | 1 +
 wdt.c  | 1 +
 2 files changed, 2 insertions(+)
 create mode 100644 wdt.c
$ git push origin main
To github.com:jhaws1982/sensor-fw.git
   a344b40..92ed894  main -> main
```

```console
$ git branch -u upstream/main main
branch 'main' set up to track 'upstream/main'.
$ git config remote.pushDefault origin
$ git branch -vv
* main 92ed894 [upstream/main] Add watchdog driver
```

```console
$ git remote add alice https://github.com/alice/sensor-fw.git
$ git fetch alice
From https://github.com/alice/sensor-fw
 * [new branch]      fix/uart-timeout -> alice/fix/uart-timeout
 * [new branch]      main             -> alice/main
$ git branch -r
  alice/fix/uart-timeout
  alice/main
  origin/HEAD -> origin/main
  origin/fix/i2c-retry
  origin/main
  upstream/main
```

```console
$ git switch fix/uart-timeout
branch 'fix/uart-timeout' set up to track 'alice/fix/uart-timeout'.
Switched to a new branch 'fix/uart-timeout'
```

```console
$ git pull
From https://github.com/alice/sensor-fw
   34df145..b186e4e  fix/uart-timeout -> alice/fix/uart-timeout
Updating 34df145..b186e4e
Fast-forward
 uart.c | 1 +
 1 file changed, 1 insertion(+)
```

```console
$ git push
To github.com:jhaws1982/sensor-fw.git
 * [new branch]      fix/uart-timeout -> fix/uart-timeout
```

```console
$ git push alice fix/uart-timeout
To https://github.com/alice/sensor-fw.git
   b186e4e..8101b74  fix/uart-timeout -> fix/uart-timeout
```

```console
$ git fetch https://github.com/alice/sensor-fw.git fix/uart-timeout
From https://github.com/alice/sensor-fw
 * branch            fix/uart-timeout -> FETCH_HEAD
$ git log --oneline -1 FETCH_HEAD
8101b74 Tweak timeout constant
```

```console
$ git remote remove alice
$ git branch -vv
  fix/i2c-retry    3278301 [origin/fix/i2c-retry] Retry I2C on NACK
  fix/uart-timeout 8101b74 Tweak timeout constant
* main             92ed894 [upstream/main] Add watchdog driver
```
