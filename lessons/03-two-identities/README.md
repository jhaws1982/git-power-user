# Lesson 3: One Machine, Two git Identities: Switch Your Email Automatically with includeIf

Read the lesson: <https://consciouslycode.com/?p=579>

## Exercise

```bash
lessons/03-two-identities/setup.sh     # builds lab/03-two-identities/ (run it again to start over)
lessons/03-two-identities/check.sh     # PASS, or a hint about what's missing
```

Make git pick your email by folder.

1. `. lab/03-two-identities/env.sh`.
2. Set your personal address as the global `user.email`.
3. Put your work address in its own file and include it with `includeIf "gitdir:<lab>/git/work/"`. Setup prints the full path; keep the trailing slash. In Git Bash on Windows, write it the way git sees it (`C:/Users/...`), not as `/c/Users/...`: git compares `gitdir:` against its own form of the path.
4. `git config user.email` should now print the work address in `git/work/sensor-fw` and the personal one in `git/personal/blog`, with no local config in either.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
