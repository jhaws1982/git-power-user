# Lesson 7: Atomic Commits with git add -p: Stage, Restore, and Undo Without Fear

Read the lesson: <https://consciouslycode.com/?p=55>

## Exercise

```bash
lessons/07-atomic-commits/setup.sh     # builds lab/07-atomic-commits/ (run it again to start over)
lessons/07-atomic-commits/check.sh     # PASS, or a hint about what's missing
```

`lab/07-atomic-commits/sensor-fw/sensor.c` has two unrelated changes: an overflow fix in the scaling and a new upper limit in the range check. Commit them as two commits, one change each, with messages that say what each one does. `git add -p` lets you stage one hunk and not the other.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
