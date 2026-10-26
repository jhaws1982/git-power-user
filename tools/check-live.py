#!/usr/bin/env python3
"""Compare each published lesson's live post with the lesson's transcript.md.

Reads the post through the WordPress REST API by slug (tools/lessons.tsv). A
lesson whose post isn't published yet is skipped. Fails if a published post's
transcript blocks differ from transcript.md, which means someone edited one and
not the other.
"""
import html
import json
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SITE = "https://consciouslycode.com/wp-json/wp/v2/posts?slug={}&_fields=content"


def live_blocks(slug):
    # Some security plugins turn away Python's default User-Agent, so send our own.
    req = urllib.request.Request(SITE.format(slug), headers={
        "User-Agent": "git-power-user-ci (+https://github.com/jhaws1982/git-power-user)",
        "Accept": "application/json"})
    with urllib.request.urlopen(req, timeout=30) as r:
        posts = json.load(r)
    if not posts:
        return None
    body = posts[0]["content"]["rendered"]
    blocks = re.findall(r"<pre[^>]*><code[^>]*>(.*?)</code></pre>", body, re.S)
    out = []
    for b in blocks:
        text = html.unescape(re.sub(r"<[^>]+>", "", b)).replace("…", "...")
        if text.startswith("$ "):
            out.append(text.rstrip("\n"))
    return out


def main():
    failed = 0
    for line in (ROOT / "tools" / "lessons.tsv").read_text().splitlines():
        if not line or line.startswith("#"):
            continue
        lesson, _, _, slug = line.split("\t")
        transcript = ROOT / "lessons" / lesson / "transcript.md"
        if not transcript.exists():
            continue
        try:
            live = live_blocks(slug)
        except (urllib.error.URLError, json.JSONDecodeError) as e:
            failed += 1
            print(f"::error::{lesson}: couldn't read the post from the site: {e}")
            continue
        if live is None:
            print(f"skip {lesson}: not published yet")
            continue
        mine = [b.rstrip("\n") for b in re.findall(r"```\w*\n(.*?)```", transcript.read_text(), re.S)]
        if live != mine:
            failed += 1
            print(f"::error::{lesson}: the live post's transcripts differ from transcript.md")
        else:
            print(f"ok   {lesson}: {len(mine)} blocks match the live post")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
