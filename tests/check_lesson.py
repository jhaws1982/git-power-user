#!/usr/bin/env python3
"""Run one lesson's demo.sh and check that every transcript block in its
transcript.md appears, in order and contiguous, in the demo's output.

Both sides are normalized first (tests/masks.txt plus the lesson's own
masks.txt): commit hashes, the sandbox path, and anything else that changes
from run to run. Exit 0 when every block matches.
"""
import difflib
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def load_masks(*files):
    masks = []
    for f in files:
        if not f.exists():
            continue
        for line in f.read_text().splitlines():
            if not line.strip() or line.startswith("#"):
                continue
            pat, _, rep = line.partition(" => ")
            masks.append((re.compile(pat, re.M), rep))
    return masks


CSI = re.compile(r"\x1b\[([0-9;]*)([A-Za-z])")


def terminal(text):
    """What a terminal would show for this output: a carriage return moves back
    to the start of the line and later text overwrites it, ESC[K clears to the
    end of the line. Progress lines that git redraws in place disappear, just as
    they do on screen."""
    lines, cur, col, i = [], [], 0, 0
    while i < len(text):
        m = CSI.match(text, i)
        if m:
            if m.group(2) == "K":
                del cur[col:]
            i = m.end()
            continue
        ch = text[i]
        if ch == "\r":
            col = 0
        elif ch == "\n":
            lines.append("".join(cur))
            cur, col = [], 0
        else:
            if col < len(cur):
                cur[col] = ch
            else:
                cur.append(ch)
            col += 1
        i += 1
    if cur:
        lines.append("".join(cur))
    return "\n".join(lines) + ("\n" if text.endswith("\n") else "")


def normalize(text, masks):
    for pat, rep in masks:
        text = pat.sub(rep, text)
    return "\n".join(ln.rstrip() for ln in text.splitlines())


def blocks(transcript):
    return [b.rstrip("\n") for b in re.findall(r"```\w*\n(.*?)```", transcript, re.S)]


def pattern(want):
    """A block as a regex over whole lines. A line that is just "..." stands for
    any number of omitted lines, so a post can trim long output honestly."""
    parts = []
    for line in want.split("\n"):
        parts.append(r"(?:[^\n]*\n)*?" if line.strip() == "..." else re.escape(line) + r"\n")
    # The block must end where a command's output ends: at the end of the output,
    # a blank line, or the next "$ " prompt. Otherwise a post that silently drops
    # the last lines of real output would still pass.
    return re.compile(r"^" + "".join(parts) + r"(?=\n|\$ |\Z)", re.M)


def found(want, out):
    return pattern(want).search(out + "\n") is not None


def closest(block, out):
    """The window of output that best matches the block, for the diff."""
    b, o = block.splitlines(), out.splitlines()
    best, at = 0.0, 0
    for i in range(max(1, len(o) - len(b) + 1)):
        r = difflib.SequenceMatcher(None, b, o[i:i + len(b)]).ratio()
        if r > best:
            best, at = r, i
    return o[at:at + len(b)]


def main(lesson):
    lesson = Path(lesson).resolve()
    with tempfile.TemporaryDirectory() as root:
        env = dict(os.environ, DEMO_ROOT=root, LIB=str(ROOT / "tests" / "lib.sh"))
        run = subprocess.run(["bash", str(lesson / "demo.sh")], cwd=lesson, env=env,
                             capture_output=True, check=False, timeout=600)
        raw = (run.stdout + run.stderr).decode(errors="replace")   # bytes: keep the \r's
        raw = terminal(raw).replace(root + "/home/jon", "/home/jon").replace(root, "/tmp/demo")
    (lesson / "out.txt").write_text(raw)
    masks = load_masks(lesson / "masks.txt", ROOT / "tests" / "masks.txt")   # lesson masks first
    out = normalize(raw, masks)
    skips = {}
    if (lesson / "skip.txt").exists():
        for line in (lesson / "skip.txt").read_text().splitlines():
            if line.strip() and not line.startswith("#"):
                num, _, why = line.partition(" ")
                skips[int(num)] = why
    failed = 0
    for n, block in enumerate(blocks((lesson / "transcript.md").read_text()), 1):
        if n in skips:
            print(f"skip {lesson.name} block {n}: {skips[n]}")
            continue
        want = normalize(block, masks)
        if found(want, out):
            continue
        failed += 1
        print(f"FAIL {lesson.name} block {n}")
        near = closest(want, out)
        if want in out and "\n...\n" not in want:
            print("    the block matches, but the demo prints more lines after it than the post shows")
        diff = difflib.unified_diff(want.splitlines(), near, "post", "demo", lineterm="")
        print("\n".join("    " + d for d in diff))
    total = len(blocks((lesson / "transcript.md").read_text()))
    for line in out.splitlines():
        if line.startswith("SNIPPET MISMATCH"):
            failed += 1
            print(f"FAIL {lesson.name}: {line}")
    tested = total - len(skips)
    print(f"{'ok  ' if not failed else 'FAIL'} {lesson.name}: {tested - failed}/{tested} blocks match"
          + (f" ({len(skips)} skipped)" if skips else ""))
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(max(main(a) for a in sys.argv[1:]))
