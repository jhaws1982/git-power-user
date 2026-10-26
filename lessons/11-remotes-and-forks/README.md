# Lesson 11: Working with git Remotes: Sync a Fork and Pull In a Teammate's Branch

Read the lesson: <https://consciouslycode.com/?p=63>

## Exercise

```bash
lessons/11-remotes-and-forks/setup.sh     # builds lab/11-remotes-and-forks/ (run it again to start over)
lessons/11-remotes-and-forks/check.sh     # PASS, or a hint about what's missing
```

`lab/11-remotes-and-forks/sensor-fw` is a clone of your fork. The original project has moved on by two commits.

Add the original as a remote named `upstream`, fast-forward your `main` to it, and push that to your fork.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
