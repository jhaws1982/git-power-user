# Lesson 15: Find the Commit That Broke It: git bisect run, log -S, and blame

Read the lesson: <https://consciouslycode.com/?p=883>

## Exercise

```bash
lessons/15-finding-bugs-in-history/setup.sh     # builds lab/15-finding-bugs-in-history/ (run it again to start over)
lessons/15-finding-bugs-in-history/check.sh     # PASS, or a hint about what's missing
```

`lab/15-finding-bugs-in-history/sensor-fw` has 31 commits. `./test.sh` passed at tag `v1.0` and fails now. Find the first bad commit with `git bisect run`, write its id to `lab/15-finding-bugs-in-history/answer.txt`, and end the bisect session. (The bad commit is in a different place every time you run setup.)

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
