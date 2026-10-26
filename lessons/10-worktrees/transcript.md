# Transcripts: git worktree: Work on Two Branches at Once Without Stashing

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ git status --short
 M src/adc.c

$ git stash
Saved working directory and index state WIP on feature/adc-filter: c4b085d Add ADC sample rate

$ git switch main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.

$ cmake --build build | tail -1
[11/11] Linking C executable fw

$ git switch feature/adc-filter && git stash pop | tail -1
Switched to branch 'feature/adc-filter'
Dropped refs/stash@{0} (b9c23cfc66573f7d499b070b9e9217e0f1f2b61c)

$ cmake --build build | tail -1
[12/12] Linking C executable fw
```

```console
$ git worktree add ../sensor-fw-hotfix -b fix/i2c-timeout main
Preparing worktree (new branch 'fix/i2c-timeout')
HEAD is now at e83faee Sensor firmware skeleton

$ git worktree list
/home/jon/sensor-fw         c4b085d [feature/adc-filter]
/home/jon/sensor-fw-hotfix  e83faee [fix/i2c-timeout]
```

```console
$ cd ../sensor-fw-hotfix

$ git commit -qam 'Bound the I2C timeout' && git log --oneline -1
bcbffc1 Bound the I2C timeout

$ cmake -S . -B build -G Ninja >/dev/null && cmake --build build | tail -1
[11/11] Linking C executable fw
```

```console
$ cd ../sensor-fw

$ git status --short
 M src/adc.c

$ cmake --build build
ninja: no work to do.

$ git log --oneline -1 fix/i2c-timeout
bcbffc1 Bound the I2C timeout
```

```console
$ cat ../sensor-fw-hotfix/.git
gitdir: /home/jon/sensor-fw/.git/worktrees/sensor-fw-hotfix

$ git -C ../sensor-fw-hotfix rev-parse --git-path HEAD --git-path index --git-path refs/stash --git-path config --git-path hooks
/home/jon/sensor-fw/.git/worktrees/sensor-fw-hotfix/HEAD
/home/jon/sensor-fw/.git/worktrees/sensor-fw-hotfix/index
/home/jon/sensor-fw/.git/refs/stash
/home/jon/sensor-fw/.git/config
/home/jon/sensor-fw/.git/hooks
```

```console
$ git stash push -q -m 'adc filter, half done' && git -C ../sensor-fw-hotfix stash list
stash@{0}: On feature/adc-filter: adc filter, half done
```

```console
$ git switch fix/i2c-timeout
fatal: 'fix/i2c-timeout' is already used by worktree at '/home/jon/sensor-fw-hotfix'

$ git worktree add ../sensor-fw-again fix/i2c-timeout
Preparing worktree (checking out 'fix/i2c-timeout')
fatal: 'fix/i2c-timeout' is already used by worktree at '/home/jon/sensor-fw-hotfix'
```

```console
$ git fetch -q && git worktree add --detach ../sensor-fw-review origin/feature/spi-dma
Preparing worktree (detached HEAD 48b7144)
HEAD is now at 48b7144 Use DMA for SPI
```

```console
$ git worktree add ../sensor-fw-tmp
Preparing worktree (new branch 'sensor-fw-tmp')
HEAD is now at c4b085d Add ADC sample rate

$ git branch --list 'sensor-fw-tmp'
+ sensor-fw-tmp
```

```console
$ git -C ../sensor-fw-hotfix status --short --ignored
?? notes.txt
!! build/

$ git worktree remove ../sensor-fw-hotfix
fatal: '../sensor-fw-hotfix' contains modified or untracked files, use --force to delete it

$ rm ../sensor-fw-hotfix/notes.txt && git worktree remove ../sensor-fw-hotfix && git worktree list
/home/jon/sensor-fw         c4b085d [feature/adc-filter]
/home/jon/sensor-fw-review  48b7144 (detached HEAD)
```

```console
$ rm -rf ../sensor-fw-review && git worktree list
/home/jon/sensor-fw         c4b085d [feature/adc-filter]
/home/jon/sensor-fw-review  48b7144 (detached HEAD) prunable

$ git worktree prune -v && git worktree list
Removing worktrees/sensor-fw-review: gitdir file points to non-existent location
/home/jon/sensor-fw  c4b085d [feature/adc-filter]
```
