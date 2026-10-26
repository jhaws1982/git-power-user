# Lesson 8: Undo Anything in git: restore, reset, revert, and the reflog

Read the lesson: <https://consciouslycode.com/?p=878>

## Exercise

```bash
lessons/08-undo-anything/setup.sh     # builds lab/08-undo-anything/ (run it again to start over)
lessons/08-undo-anything/check.sh     # PASS, or a hint about what's missing
```

Someone had a bad afternoon in `lab/08-undo-anything/sensor-fw`: they deleted the unmerged branch `experiment/dma` and then ran `git reset --hard HEAD~2` on `main`.

Put `main` back on "Kick watchdog in idle" and recreate `experiment/dma` at "Try DMA for ADC". Everything you need is in `git reflog`.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
