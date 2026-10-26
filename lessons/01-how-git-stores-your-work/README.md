# Lesson 1: How git Stores Your Work: Blobs, Trees, Commits, and Refs

Read the lesson: <https://consciouslycode.com/?p=875>

## Exercise

```bash
lessons/01-how-git-stores-your-work/setup.sh     # builds lab/01-how-git-stores-your-work/ (run it again to start over)
lessons/01-how-git-stores-your-work/check.sh     # PASS, or a hint about what's missing
```

In `lab/01-how-git-stores-your-work/sensor-fw` there's a repository with three commits.

Using only `git cat-file` (and `git log` to find your way), find the id of the **tree** that the second commit ("Add main") stores for the `src` folder, and write it to `lab/01-how-git-stores-your-work/answer.txt`. A 7-character prefix is enough.

Bonus: is the `README.md` blob the same object in all three commits? Why?

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
