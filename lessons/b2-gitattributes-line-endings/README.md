# Bonus 2: .gitattributes and Line Endings: Stop CRLF Diffs for Good

Read the lesson: <https://consciouslycode.com/?p=887>

## Exercise

```bash
lessons/b2-gitattributes-line-endings/setup.sh     # builds lab/b2-gitattributes-line-endings/ (run it again to start over)
lessons/b2-gitattributes-line-endings/check.sh     # PASS, or a hint about what's missing
```

Everything in `lab/b2-gitattributes-line-endings/sensor-fw` was committed from a Windows editor, CRLF and all. Add a `.gitattributes` so shell scripts are always LF, batch files always CRLF, `*.bin` is binary, and everything else is normalized; then fix what's already committed. `git ls-files --eol` shows where you stand.

Nothing here touches your own git config or repositories: setup and check run git without your global settings, and lessons about `--global` settings give you a lab config file through `env.sh`.

## What else is in this folder

- `demo.sh` builds the post's example repository and runs every command the post shows.
- `transcript.md` is the post's terminal output; `tests/check_lesson.py` checks it against a fresh run of `demo.sh`.
