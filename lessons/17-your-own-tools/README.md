# Lesson 17: Use Your Own Tools with git: core.editor, difftool, and mergetool

Read the lesson: <https://consciouslycode.com/?p=67>

## Exercise

```bash
lessons/17-your-own-tools/setup.sh     # builds lab/17-your-own-tools/ (run it again to start over)
lessons/17-your-own-tools/check.sh     # PASS, or a hint about what's missing
```

`. lab/17-your-own-tools/env.sh`, then define a difftool called `plain` that runs `diff -u "$LOCAL" "$REMOTE"`, make it the default `diff.tool`, and turn off the prompt. `git difftool` in `lab/17-your-own-tools/sensor-fw` should print the change. Then swap in the tool you actually use.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
