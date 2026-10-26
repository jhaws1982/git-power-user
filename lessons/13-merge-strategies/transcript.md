# Transcripts: Merge Commit, Rebase, or Squash? Choosing a git Merge Strategy for Your Team

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ git log --oneline --graph --all
* 0592059 Test the filter
* dc9525c Implement moving average
* 88b0940 Add filter interface
| * cbaf3b7 Fix UART timeout
| * aac9458 Kick watchdog
|/  
* 264ec05 Add boot sequence
* 24a6664 Initial commit
```

```console
$ git merge --no-ff feature/adc-filter
Merge made by the 'ort' strategy.
 filter.c      | 1 +
 filter.h      | 1 +
 test_filter.c | 1 +
 3 files changed, 3 insertions(+)
...
$ git log --oneline --graph
*   95fa11d Merge branch 'feature/adc-filter'
|\  
| * 0592059 Test the filter
| * dc9525c Implement moving average
| * 88b0940 Add filter interface
* | cbaf3b7 Fix UART timeout
* | aac9458 Kick watchdog
|/  
* 264ec05 Add boot sequence
* 24a6664 Initial commit
```

```console
$ git log --oneline --first-parent
95fa11d Merge branch 'feature/adc-filter'
cbaf3b7 Fix UART timeout
aac9458 Kick watchdog
264ec05 Add boot sequence
24a6664 Initial commit
```

```console
$ git revert -m 1 --no-edit 95fa11d
[main 5acb81f] Revert "Merge branch 'feature/adc-filter'"
 Date: Fri Oct 23 09:00:00 2026 -0600
 3 files changed, 3 deletions(-)
 delete mode 100644 filter.c
 delete mode 100644 filter.h
 delete mode 100644 test_filter.c
```

```console
$ git merge --ff-only feature/adc-filter
hint: Diverging branches can't be fast-forwarded, you need to either:
hint: 
hint: 	git merge --no-ff
hint: 
hint: or:
hint: 
hint: 	git rebase
hint: 
hint: Disable this message with "git config advice.diverging false"
fatal: Not possible to fast-forward, aborting.
```

```console
$ git switch feature/adc-filter
Switched to branch 'feature/adc-filter'
$ git rebase main
Successfully rebased and updated refs/heads/feature/adc-filter.
$ git switch main
Switched to branch 'main'
$ git merge --ff-only feature/adc-filter
Updating cbaf3b7..b748e35
Fast-forward
...
$ git log --oneline --graph
* b748e35 Test the filter
* f50bdcd Implement moving average
* 8ebc87d Add filter interface
* cbaf3b7 Fix UART timeout
* aac9458 Kick watchdog
* 264ec05 Add boot sequence
* 24a6664 Initial commit
```

```console
$ git log --oneline --graph
*   8b6bb9c Merge branch 'feature/adc-filter'
|\  
| * b748e35 Test the filter
| * f50bdcd Implement moving average
| * 8ebc87d Add filter interface
|/  
* cbaf3b7 Fix UART timeout
* aac9458 Kick watchdog
* 264ec05 Add boot sequence
* 24a6664 Initial commit
```

```console
$ git merge --squash feature/adc-filter
Squash commit -- not updating HEAD
Automatic merge went well; stopped before committing as requested
$ git commit -m "Add ADC moving-average filter (#42)"
[main b7adc32] Add ADC moving-average filter (#42)
 3 files changed, 3 insertions(+)
...
$ git log --oneline --graph
* b7adc32 Add ADC moving-average filter (#42)
* cbaf3b7 Fix UART timeout
* aac9458 Kick watchdog
* 264ec05 Add boot sequence
* 24a6664 Initial commit
```

```console
$ git branch -d feature/adc-filter
error: the branch 'feature/adc-filter' is not fully merged.
If you are sure you want to delete it, run 'git branch -D feature/adc-filter'
```
