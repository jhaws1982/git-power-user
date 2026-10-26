# Lesson 13: Merge Commit, Rebase, or Squash? Choosing a git Merge Strategy for Your Team

Read the lesson: <https://consciouslycode.com/?p=59>

## Exercise

```bash
lessons/13-merge-strategies/setup.sh     # builds lab/13-merge-strategies/ (run it again to start over)
lessons/13-merge-strategies/check.sh     # PASS, or a hint about what's missing
```

Land `feature/adc-filter` in `lab/13-merge-strategies/sensor-fw` on `main` as a single squashed commit with the message `Add ADC filter (#7)`. Afterward, why does `git branch -d feature/adc-filter` refuse?

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
