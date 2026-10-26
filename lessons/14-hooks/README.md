# Lesson 14: git Hooks: Check Formatting on Commit, Run Tests Before Push, and Share Them with Your Team

Read the lesson: <https://consciouslycode.com/?p=65>

## Exercise

```bash
lessons/14-hooks/setup.sh     # builds lab/14-hooks/ (run it again to start over)
lessons/14-hooks/check.sh     # PASS, or a hint about what's missing
```

In `lab/14-hooks/sensor-fw`, add a `commit-msg` hook that rejects any commit whose subject doesn't start with a capital letter. Keep it in `.githooks/`, commit it, and point `core.hooksPath` at it so anyone who clones the repo can use it.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
