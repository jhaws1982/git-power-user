# Become a Git Power User

A free course that goes from how git stores your work to the commands that make day-to-day work fast and safe. Each lesson is a post on [consciouslycode.com](https://consciouslycode.com/training/); this repository holds the code behind them and the tests that keep them honest.

**Every command in every post is run by CI and compared with what the post shows.** If a new git release changes its output, or someone edits a post without re-running it, the build fails.

## The lessons

Take them in order; each one builds on the ones before it.

| # | Lesson | What you'll be able to do |
|---|--------|---------------------------|
| 1 | [How git Stores Your Work](https://consciouslycode.com/?p=875) | Read blobs, trees, commits, and refs with `cat-file`, and see why most commands just move a pointer |
| 2 | [Configuring git](https://consciouslycode.com/?p=49) | Know which config file wins, and set the options worth changing |
| 3 | [Two git Identities with includeIf](https://consciouslycode.com/?p=579) | Commit with your work email in work repos and your own everywhere else, automatically |
| 4 | [SSH Keys for git](https://consciouslycode.com/?p=53) | Set up keys and an agent on Linux, WSL, Windows, and in dev containers |
| 5 | [Credential Helpers for HTTPS](https://consciouslycode.com/?p=69) | Stop typing passwords, with a helper that fits your OS |
| 6 | [git clone Options](https://consciouslycode.com/?p=51) | Clone one branch, a shallow or blobless copy, and submodules |
| 7 | [Atomic Commits with git add -p](https://consciouslycode.com/?p=55) | Split work into commits that each do one thing |
| 8 | [Undo Anything](https://consciouslycode.com/?p=878) | Pick the right undo, and get back "lost" commits with the reflog |
| 9 | [Branches Day to Day](https://consciouslycode.com/?p=57) | Create, share, update, and clean up branches |
| 10 | [git worktree](https://consciouslycode.com/?p=873) | Work on two branches at once without stashing |
| 11 | [Remotes and Forks](https://consciouslycode.com/?p=63) | Keep a fork in sync and pull in a teammate's branch |
| 12 | [Clean Up a Branch Before Review](https://consciouslycode.com/?p=881) | Fold fixes into the right commits and show reviewers what changed |
| 13 | [Merge, Rebase, or Squash?](https://consciouslycode.com/?p=59) | Choose how your team lands branches, and why |
| 14 | [git Hooks](https://consciouslycode.com/?p=65) | Check formatting on commit and run tests before push, shared with the team |
| 15 | [Find the Commit That Broke It](https://consciouslycode.com/?p=883) | Let `bisect run` find a regression, search diffs, and see past reformats in blame |
| 16 | [git Aliases](https://consciouslycode.com/?p=61) | Build a short list of aliases that save real time |
| 17 | [Use Your Own Tools](https://consciouslycode.com/?p=67) | Wire in your editor, diff tool, and merge tool |
| B1 | [Tags, Releases, and Signed Commits](https://consciouslycode.com/?p=885) | Tag releases properly and sign with your SSH key |
| B2 | [.gitattributes and Line Endings](https://consciouslycode.com/?p=887) | End CRLF trouble for a mixed Windows and Linux team |

Links work as each post is published; they redirect to the post's permanent address.

[`cheatsheet/gitconfig`](cheatsheet/gitconfig) collects every setting and alias the course recommends in one file, each labeled with its lesson.

## What's in this repository

```text
lessons/NN-name/
    demo.sh         builds the lesson's example repository and runs every command in the post
    transcript.md   the post's terminal blocks (the lines that start with "$ "), copied from the post
    snippets.md     the post's other code (config files, scripts), which demo.sh runs as written
    masks.txt       output that changes on every run, such as key fingerprints (optional)
    skip.txt        blocks that can't be checked anywhere but your machine (optional)
tests/
    lib.sh          what every demo runs in: a throwaway HOME, no system config, fixed commit dates
    check_lesson.py runs one demo and compares its output with transcript.md
    run-all.sh      checks every lesson
tools/
    extract-transcripts.py   copies a post's blocks into transcript.md and snippets.md
    regen-blocks.py          rewrites failing blocks from a fresh run, for review
    check-live.py            compares each published post with transcript.md
    lessons.tsv              lesson, post id, and slug
docker/Dockerfile   the environment CI uses; also builds any git release from source
```

## Run the tests

You need bash, git, Python 3, a C compiler, `make`, CMake, Ninja, `clang-format`, and OpenSSH. Or use the container:

```bash
docker build -t git-power-user docker/
docker run --rm -v "$PWD:/course" -w /course git-power-user tests/run-all.sh
```

To test against a newer git, add `--build-arg GIT_REF=v2.51.0` (any tag) to the build.

Without Docker, `tests/run-all.sh` runs everything, and `python3 tests/check_lesson.py lessons/08-undo-anything` runs one lesson. Nothing touches your own git config or repositories: each demo runs in a temporary directory with its own HOME.

### How a block is checked

`check_lesson.py` runs `demo.sh`, renders its output the way a terminal would, and looks for each block of `transcript.md` in it, in order:

- Commit ids, abbreviated or full, match any id, so a block doesn't break when an id changes.
- A line that is just `...` in a post stands for lines the post leaves out.
- A block has to end where the command's output ends, so a post can't quietly drop the last lines.
- When a block doesn't match, it prints the closest part of the real output as a diff.

## CI

`.github/workflows/test.yml` runs every lesson on each push, on pull requests, and every Monday, against two versions of git:

- **Ubuntu 24.04's git (2.43).** The posts show this version's output, so every block must match.
- **The newest git release, built from source.** Newer git words some messages differently (hints now say `git config set`, `bisect` says `first 'bad' commit`, `worktree list` pads columns less, the rebase todo list puts `#` before each subject). Those are recorded in `tests/known-differences/<version>.txt`, and `tests/compare-known.sh` fails only when the differences change. That's the signal that a new git release changed something a post shows; the weekly run opens an issue when it happens.

A second job reads every published post from the site and checks it still matches `transcript.md`.

## When git changes

1. Read the diff the failing run prints.
2. If it's a wording change, record it with `tests/compare-known.sh --update` (run with that git on your PATH, or in the container built with `--build-arg GIT_REF=...`).
3. If it changes what a reader should do, update the post, copy its blocks back with `python3 tools/extract-transcripts.py <post.md> lessons/NN-name`, and fix the prose. `tools/regen-blocks.py` can draft new blocks from a fresh run.

## License

The scripts and tools are MIT licensed (see [LICENSE](LICENSE)). The lesson text is © Jonathan Haws and lives on [consciouslycode.com](https://consciouslycode.com/).

## Keep going

Teams that want this taught live, with their own repositories and workflow, can book the **Git for teams** workshop: [consciouslycode.com/services](https://consciouslycode.com/services/).
