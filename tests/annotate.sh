#!/usr/bin/env bash
# Turns each FAIL line of a test log, plus the indented detail lines under it,
# into one GitHub Actions error annotation, so failures show on the run's page.
# usage: tests/annotate.sh LOG [TITLE]
log=$1; title=${2:-test}
awk -v title="$title" '
    function esc(s) { gsub(/%/, "%25", s); gsub(/\r/, "", s); return s }
    function flush() { if (msg != "") { print "::error title=" title "::" msg; msg = "" } }
    /^FAIL / { flush(); msg = esc($0); next }
    /^    / && msg != "" { if (length(msg) < 3000) msg = msg "%0A" esc($0); next }
    { flush() }
    END { flush() }
' "$log"
