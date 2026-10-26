# Lesson 10: git worktree: Work on Two Branches at Once Without Stashing

Read the lesson: <https://consciouslycode.com/?p=873>

## Exercise

```bash
lessons/10-worktrees/setup.sh     # builds lab/10-worktrees/ (run it again to start over)
lessons/10-worktrees/check.sh     # PASS, or a hint about what's missing
```

You're halfway through a change on `feature/adc-filter` in `lab/10-worktrees/sensor-fw` when an urgent fix comes in. Without committing or stashing, check out a new branch `fix/i2c-timeout`, started from `main`, in a second folder `lab/10-worktrees/sensor-fw-hotfix`.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
