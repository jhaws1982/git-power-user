# Lesson 6: git clone Options Worth Knowing: Branches, Shallow and Blobless Clones, and Submodules

Read the lesson: <https://consciouslycode.com/?p=51>

## Exercise

```bash
lessons/06-clone-options/setup.sh     # builds lab/06-clone-options/ (run it again to start over)
lessons/06-clone-options/check.sh     # PASS, or a hint about what's missing
```

Make the smallest useful clone.

Clone `lab/06-clone-options/server/kernel.git` to `lab/06-clone-options/clone` with only the `smp` branch and only its latest commit. Hint: a local path ignores `--depth`; use a `file://` URL.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
