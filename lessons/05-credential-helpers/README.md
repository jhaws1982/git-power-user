# Lesson 5: Stop Typing Your git Password: Credential Helpers for HTTPS, Explained

Read the lesson: <https://consciouslycode.com/?p=69>

## Exercise

```bash
lessons/05-credential-helpers/setup.sh     # builds lab/05-credential-helpers/ (run it again to start over)
lessons/05-credential-helpers/check.sh     # PASS, or a hint about what's missing
```

Configure credential helpers per URL.

1. `. lab/05-credential-helpers/env.sh`.
2. Make `cache --timeout=3600` the default helper.
3. For `https://git.internal.example` only, use `store`.
4. Check with `git config --get-urlmatch credential.helper https://git.internal.example/team/repo.git`.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
