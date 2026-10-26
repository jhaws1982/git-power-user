# Lesson 16: git Aliases That Earn Their Keep: Less Typing, Better Logs, Safer Defaults

Read the lesson: <https://consciouslycode.com/?p=61>

## Exercise

```bash
lessons/16-aliases/setup.sh     # builds lab/16-aliases/ (run it again to start over)
lessons/16-aliases/check.sh     # PASS, or a hint about what's missing
```

`. lab/16-aliases/env.sh`, then create three global aliases: `st` for `status -sb`, `unstage` for `restore --staged`, and `last` to show the latest commit (try `log -1 --stat`). Try each in `lab/16-aliases/sensor-fw`.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
