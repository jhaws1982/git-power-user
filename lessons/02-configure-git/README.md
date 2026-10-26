# Lesson 2: Configuring git: Global vs. Local Settings and the Options Worth Changing

Read the lesson: <https://consciouslycode.com/?p=49>

## Exercise

```bash
lessons/02-configure-git/setup.sh     # builds lab/02-configure-git/ (run it again to start over)
lessons/02-configure-git/check.sh     # PASS, or a hint about what's missing
```

Practice global vs. local settings without touching your own `~/.gitconfig`.

1. `. lab/02-configure-git/env.sh` so `git config --global` writes to a lab file.
2. Set a global `user.name` and `user.email`, `init.defaultBranch main`, `pull.ff only`, and `fetch.prune true`.
3. In `lab/02-configure-git/oss-project`, set a different `user.email` for that repository only.
4. Check your work: `git config --list --show-origin --show-scope` inside `oss-project`.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
