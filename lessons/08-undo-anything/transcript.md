# Transcripts: Undo Anything in git: restore, reset, revert, and the reflog

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ git status --short
M  adc.c
 M uart.c
$ git restore uart.c
$ git restore --staged adc.c
$ git status --short
 M adc.c
$ git restore adc.c && git status --short
```

```console
$ git reset --soft HEAD~1
$ git status --short
A  wdt.c
$ git commit -q -m "Add watchdog kick" && git log --oneline -1
5d04c6b Add watchdog kick
```

```console
$ git reset --hard HEAD~2
HEAD is now at f7881b1 Add UART driver
$ git log --oneline
f7881b1 Add UART driver
4d010c4 Initial commit
```

```console
$ git reflog -4
f7881b1 HEAD@{0}: reset: moving to HEAD~2
5d04c6b HEAD@{1}: commit: Add watchdog kick
918e3a5 HEAD@{2}: reset: moving to HEAD~1
b8216fc HEAD@{3}: commit: Add watchdgo kick
```

```console
$ git reset --hard HEAD@{1}
HEAD is now at 5d04c6b Add watchdog kick
$ git log --oneline -1
5d04c6b Add watchdog kick
```

```console
$ git branch -D experiment/dma
Deleted branch experiment/dma (was 20734bb).
```

```console
$ git reflog | grep 'experiment/dma'
5d04c6b HEAD@{0}: checkout: moving from experiment/dma to main
5d04c6b HEAD@{2}: checkout: moving from main to experiment/dma
```

```console
$ git branch experiment/dma 20734bb
$ git log --oneline -1 experiment/dma
20734bb Try DMA for ADC
```

```console
$ git merge --no-edit feature/adc-filter
Merge made by the 'ort' strategy.
 adc.c | 1 +
 1 file changed, 1 insertion(+)
$ git reset --hard ORIG_HEAD
HEAD is now at 1661034 Fix boot order
$ git log --oneline -1
1661034 Fix boot order
```

```console
$ git rebase main
Successfully rebased and updated refs/heads/feature/adc-filter.
$ git reflog -3 feature/adc-filter
7329e1c feature/adc-filter@{0}: rebase (finish): refs/heads/feature/adc-filter onto 16610343ecc4bfb635bfb6cc7a09fbbcc1190a7f
8c7e455 feature/adc-filter@{1}: commit: Filter ADC samples
5d04c6b feature/adc-filter@{2}: branch: Created from HEAD
```

```console
$ git reset --hard feature/adc-filter@{1}
HEAD is now at 8c7e455 Filter ADC samples
$ git log --oneline --graph --all -4
* 1661034 Fix boot order
| * 8c7e455 Filter ADC samples
|/  
| * 20734bb Try DMA for ADC
|/  
* 5d04c6b Add watchdog kick
```

```console
$ git log --oneline -1 -- uart.c
19da0de Remove old UART driver
$ git restore --source=HEAD~2 uart.c
$ git status --short
?? uart.c
```

```console
$ git stash drop
Dropped refs/stash@{0} (c2c914c5df5c7190952e25f326f1a22619b3d19f)

$ git stash apply -q c2c914c && git status --short
 M adc.c
```
