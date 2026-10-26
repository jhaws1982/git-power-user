# Lesson 12: Clean Up a Branch Before Review: fixup Commits, autosquash, and range-diff

Read the lesson: <https://consciouslycode.com/?p=881>

## Exercise

```bash
lessons/12-clean-up-history/setup.sh     # builds lab/12-clean-up-history/ (run it again to start over)
lessons/12-clean-up-history/check.sh     # PASS, or a hint about what's missing
```

`feature/adc-filter` in `lab/12-clean-up-history/sensor-fw` has five commits, including a `wip` and a `fixup!`. Rewrite it into three: "Add filter interface", "Implement moving average", "Add filter tests". The code at the tip must not change. `git rebase -i --autosquash main` does most of it.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
