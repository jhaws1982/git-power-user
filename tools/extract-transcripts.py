#!/usr/bin/env python3
"""Copy the transcript blocks (code blocks whose first line starts with "$ ")
out of a post's markdown into a lesson's transcript.md.

Also writes snippets.md: every other code block in the post (hook scripts,
config files), numbered, so a demo can run the post's own code with
`snippet N` instead of a copy that could drift.

usage: extract-transcripts.py POST.md LESSON_DIR          write transcript.md + snippets.md
       extract-transcripts.py --check POST.md LESSON_DIR  fail if either is out of date
"""
import re
import sys
from pathlib import Path


def render(post):
    text = post.read_text()
    title = re.search(r'^title: "?(.*?)"?$', text, re.M).group(1)
    body = text.split("\n---\n", 1)[1] if text.startswith("---") else text
    out = [f"# Transcripts: {title}", "",
           "Every block below is copied from the post. tests/check_lesson.py runs",
           "demo.sh and fails if any block stops matching its output.", ""]
    for lang, block in re.findall(r"```(\w*)\n(.*?)```", body, re.S):
        if block.startswith("$ "):
            out += [f"```{lang or 'console'}", block.rstrip("\n"), "```", ""]
    return "\n".join(out)


def render_snippets(post):
    text = post.read_text()
    body = text.split("\n---\n", 1)[1] if text.startswith("---") else text
    out = ["# Code from the post (not transcripts), numbered for demo.sh's `snippet N`", ""]
    n = 0
    for lang, block in re.findall(r"```(\w*)\n(.*?)```", body, re.S):
        if block.startswith("$ "):
            continue
        n += 1
        out += [f"## snippet {n}", f"```{lang}", block.rstrip("\n"), "```", ""]
    return "\n".join(out)


def main(argv):
    check = argv[:1] == ["--check"]
    post, lesson = (Path(a) for a in argv[check:check + 2])
    files = {lesson / "transcript.md": render(post), lesson / "snippets.md": render_snippets(post)}
    stale = [t for t, new in files.items() if not t.exists() or t.read_text() != new]
    if check:
        for t in stale:
            print(f"{t} is out of date with {post}")
        return 1 if stale else 0
    for t, new in files.items():
        t.write_text(new)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
