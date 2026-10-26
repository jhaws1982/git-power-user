# Lesson 9: git Branches Day to Day: Create, Share, Stay Current, Clean Up

Read the lesson: <https://consciouslycode.com/?p=57>

## Exercise

```bash
lessons/09-branches/setup.sh     # builds lab/09-branches/ (run it again to start over)
lessons/09-branches/check.sh     # PASS, or a hint about what's missing
```

In `lab/09-branches/sensor-fw` (its remote is a bare repo standing in for the server):

1. Create `feature/led`, commit something on it, and push it so it tracks `origin/feature/led`.
2. `old/done` is already merged into `main`. Delete it the safe way.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
