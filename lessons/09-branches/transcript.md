# Transcripts: git Branches Day to Day: Create, Share, Stay Current, Clean Up

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ git switch -c feature/adc-filter
Switched to a new branch 'feature/adc-filter'
```

```console
$ git log --oneline --graph --all --decorate
* 3a42f8b (HEAD -> feature/adc-filter) Document the filter
* 489eb7f Add ADC filter stub
* 51968a8 (origin/main, main) Initial commit
$ git branch -v
* feature/adc-filter 3a42f8b Document the filter
  main               51968a8 Initial commit
```

```console
$ git switch main
M	main.c
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
```

```console
$ git switch main
error: Your local changes to the following files would be overwritten by checkout:
	README.md
Please commit your changes or stash them before you switch branches.
Aborting
```

```console
$ git push -u origin feature/adc-filter
To example.com:jon/sensor-fw.git
 * [new branch]      feature/adc-filter -> feature/adc-filter
branch 'feature/adc-filter' set up to track 'origin/feature/adc-filter'.
$ git branch -vv
* feature/adc-filter 3a42f8b [origin/feature/adc-filter] Document the filter
  main               51968a8 [origin/main] Initial commit
```

```console
$ git fetch
From example.com:jon/sensor-fw
   51968a8..d7222ae  main       -> origin/main
$ git status
On branch main
Your branch is behind 'origin/main' by 2 commits, and can be fast-forwarded.
  (use "git pull" to update your local branch)

nothing to commit, working tree clean
$ git log --oneline main..origin/main
d7222ae Add watchdog kick
de175b0 Fix startup order
```

```console
$ git pull --ff-only
Updating 51968a8..d7222ae
Fast-forward
 main.c | 2 ++
 1 file changed, 2 insertions(+)
```

```console
$ git rebase main
Successfully rebased and updated refs/heads/feature/adc-filter.
$ git log --oneline --graph --decorate --all
* f74c960 (HEAD -> feature/adc-filter) Document the filter
* 82e50df Add ADC filter stub
* d7222ae (origin/main, main) Add watchdog kick
* de175b0 Fix startup order
| * 3a42f8b (origin/feature/adc-filter) Document the filter
| * 489eb7f Add ADC filter stub
|/  
* 51968a8 Initial commit
```

```console
$ git push
To example.com:jon/sensor-fw.git
 ! [rejected]        feature/adc-filter -> feature/adc-filter (non-fast-forward)
error: failed to push some refs to 'example.com:jon/sensor-fw.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. If you want to integrate the remote changes,
hint: use 'git pull' before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
$ git push --force-with-lease
To example.com:jon/sensor-fw.git
 + 3a42f8b...f74c960 feature/adc-filter -> feature/adc-filter (forced update)
```

```console
$ git merge feature/adc-filter
Updating d7222ae..f74c960
Fast-forward
 README.md | 2 ++
 filter.c  | 1 +
 2 files changed, 3 insertions(+)
 create mode 100644 filter.c
```

```console
$ git branch -d feature/adc-filter
Deleted branch feature/adc-filter (was f74c960).
$ git branch -d experiment/dma
error: the branch 'experiment/dma' is not fully merged.
If you are sure you want to delete it, run 'git branch -D experiment/dma'
```

```console
$ git branch --merged
* main
$ git branch --no-merged
  experiment/dma
```

```console
$ git push origin --delete feature/adc-filter
To example.com:jon/sensor-fw.git
 - [deleted]         feature/adc-filter
$ git fetch --prune
From example.com:jon/sensor-fw
 - [deleted]         (none)     -> origin/feature/adc-filter
```

```console
$ git worktree add ../sensor-fw-main main
Preparing worktree (checking out 'main')
HEAD is now at f74c960 Document the filter
$ git worktree list
/home/jon/sensor-fw       75038ce [fix/uart-timeout]
/home/jon/sensor-fw-main  f74c960 [main]
```
