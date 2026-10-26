# Transcripts: Clean Up a Branch Before Review: fixup Commits, autosquash, and range-diff

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ git log --oneline main..
320939a Add filter tests
f510b10 wip
ea3de5d Implement moving average
d0cfb01 Add filter interface
```

```console
$ git add filter.h
$ git commit --fixup=ea3de5d
[feature/adc-filter 778df20] fixup! Implement moving average
 1 file changed, 1 insertion(+)
```

```console
$ git rebase -i --autosquash main
Successfully rebased and updated refs/heads/feature/adc-filter.

$ git log --oneline main..
f8f4434 Add filter tests
9f4cdff Implement moving average
d0cfb01 Add filter interface
```

```console
$ git diff --stat feature/adc-filter@{1} feature/adc-filter
```

```console
$ git range-diff main feature/adc-filter@{1} feature/adc-filter
1:  d0cfb01 = 1:  d0cfb01 Add filter interface
2:  ea3de5d < -:  ------- Implement moving average
3:  f510b10 < -:  ------- wip
-:  ------- > 2:  9f4cdff Implement moving average
4:  320939a = 3:  f8f4434 Add filter tests
5:  778df20 < -:  ------- fixup! Implement moving average
```

```console
$ git config --global rebase.autoSquash
true
```

```console
$ git rebase --update-refs main
Successfully rebased and updated refs/heads/part2-tests.
Updated the following refs with --update-refs:
	refs/heads/part1-driver
$ git log --oneline --decorate main..
dd9435b (HEAD -> part2-tests) Add filter tests
95f39ae (part1-driver) Implement moving average
dbbfc38 Add filter interface
```
