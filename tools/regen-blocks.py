#!/usr/bin/env python3
"""For each transcript block that no longer matches, rebuild it from the
lesson's last demo output (out.txt): keep the block's own "$ " command lines and
take the output that follows each one in the demo.

usage: regen-blocks.py LESSON_DIR [POST.md]
Prints old and new for every failing block. With POST.md, rewrites those blocks
in the post (blocks with "..." elisions are only printed, never rewritten).
"""
import importlib.util
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location("check", ROOT / "tests" / "check_lesson.py")
check = importlib.util.module_from_spec(spec)
spec.loader.exec_module(check)


def output_after(lines, cmd):
    """Output of the first run of `cmd` in the demo (up to a blank line or the next prompt)."""
    for i, line in enumerate(lines):
        if line == cmd:
            out = []
            for nxt in lines[i + 1:]:
                if nxt.startswith("$ ") or nxt == "":
                    break
                out.append(nxt)
            return out
    return None


def regen(block, raw_lines):
    """Rebuild the block command by command, keeping the blank lines the post
    puts between commands."""
    lines = block.split("\n")
    new = []
    for i, line in enumerate(lines):
        if not line.startswith("$ "):
            continue
        out = output_after(raw_lines, line)
        if out is None:
            return None
        new.append(line)
        new += out
        rest = lines[i + 1:]
        nxt = next((j for j, ln in enumerate(rest) if ln.startswith("$ ")), None)
        if nxt is not None and nxt > 0 and rest[nxt - 1] == "":
            new.append("")
    return "\n".join(new)


def main(argv):
    lesson = Path(argv[0])
    post = Path(argv[1]) if len(argv) > 1 else None
    masks = check.load_masks(lesson / "masks.txt", ROOT / "tests" / "masks.txt")
    raw = (lesson / "out.txt").read_text()
    raw_lines = [ln.rstrip() for ln in raw.splitlines()]
    out = check.normalize(raw, masks)
    text = post.read_text() if post else None
    for block in check.blocks((lesson / "transcript.md").read_text()):
        if check.found(check.normalize(block, masks), out):
            continue
        new = regen(block, raw_lines)
        print("--- post\n" + block + "\n+++ demo\n" + (new or "(a command is missing from the demo)") + "\n")
        if post and new and "\n...\n" not in f"\n{block}\n":
            assert text.count(block) == 1, "block not unique in post"
            text = text.replace(block, new)
    if post:
        post.write_text(text)


if __name__ == "__main__":
    main(sys.argv[1:])
