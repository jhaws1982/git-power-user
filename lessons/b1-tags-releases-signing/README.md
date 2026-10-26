# Bonus 1: Tag Releases and Sign Commits in git: Annotated Tags, describe, and SSH Signing

Read the lesson: <https://consciouslycode.com/?p=885>

## Exercise

```bash
lessons/b1-tags-releases-signing/setup.sh     # builds lab/b1-tags-releases-signing/ (run it again to start over)
lessons/b1-tags-releases-signing/check.sh     # PASS, or a hint about what's missing
```

In `lab/b1-tags-releases-signing/sensor-fw`, release 1.0 is the commit "Prepare release 1.0" (one before the tip). Tag it with an annotated tag `v1.0` and push the tag. `git describe` on `main` should then print `v1.0-1-g<id>`.

Bonus: set up SSH signing as in the post and make it `git tag -s` instead.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
