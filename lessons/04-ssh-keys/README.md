# Lesson 4: Setting Up SSH Keys for git on Linux, WSL, and Windows (and in Dev Containers)

Read the lesson: <https://consciouslycode.com/?p=53>

## Exercise

```bash
lessons/04-ssh-keys/setup.sh     # builds lab/04-ssh-keys/ (run it again to start over)
lessons/04-ssh-keys/check.sh     # PASS, or a hint about what's missing
```

Write an SSH config with a host alias, without touching your real `~/.ssh/config`.

Create `lab/04-ssh-keys/ssh_config` so that `github-personal` connects to github.com as user `git` with only `~/.ssh/id_ed25519_personal`, while plain `github.com` is left alone. Check it yourself with `ssh -G -F lab/04-ssh-keys/ssh_config github-personal`. Nothing connects anywhere; `ssh -G` only prints the settings.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
