# Sourced by every lessons/*/demo.sh. Gives each demo a clean, repeatable world:
# a throwaway HOME, no system or user git config, fixed commit dates, and
# show() to print a command the way the post shows it, then run it.
set -uo pipefail
unset GIT_CONFIG_PARAMETERS GIT_CONFIG_COUNT GIT_DIR GIT_WORK_TREE
for v in $(env | grep -o '^GIT_CONFIG_[A-Z]*_[0-9]*'); do unset "$v"; done
DEMO_ROOT=${DEMO_ROOT:-$(mktemp -d)}
LESSON_DIR=$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)   # the demo.sh that sourced this file
export HOME="$DEMO_ROOT/home/jon"
mkdir -p "$HOME"   # DEMO_ROOT is a fresh temporary directory, so HOME starts empty
export GIT_CONFIG_NOSYSTEM=1 GIT_PAGER=cat PAGER=cat LC_ALL=C.UTF-8 TZ=America/Denver
export GIT_AUTHOR_DATE="2026-10-20T09:00:00-06:00" GIT_COMMITTER_DATE="2026-10-20T09:00:00-06:00"
export PYTHONDONTWRITEBYTECODE=1
# Line-buffer every program's stdout, as a terminal does, so stdout and stderr
# lines come out in the order you'd see them on screen (coreutils' stdbuf trick).
for so in /usr/libexec/coreutils/libstdbuf.so /usr/lib/coreutils/libstdbuf.so; do
    [ -f "$so" ] && export LD_PRELOAD=$so _STDBUF_O=L _STDBUF_E=L && break
done
cd "$HOME" || exit 1

# show 'cmd' prints "$ cmd", runs it with stderr folded into stdout, then a blank line.
show() { printf '$ %s\n' "$1"; eval "$1" 2>&1; echo; }
# run 'cmd' is show without the blank line, for commands shown back to back in one block.
run() { printf '$ %s\n' "$1"; eval "$1" 2>&1; }
tick() {  # move the commit clock forward a minute so commits get distinct times
    local s; s=$(date -d "$GIT_AUTHOR_DATE + 1 minute" +%Y-%m-%dT%H:%M:%S%:z)
    export GIT_AUTHOR_DATE=$s GIT_COMMITTER_DATE=$s
}
me() {  # the identity the posts use
    git config --global user.name "Jonathan Haws"
    git config --global user.email "jon@example.com"
    git config --global init.defaultBranch main
    git config --global color.ui false
}
# The demos use a bare repository at ~/server/ in place of a git server. This
# filter prints its URLs the way git prints an SSH remote such as
# git@example.com:jon/sensor-fw.git ("To"/"From" lines drop the user name).
server_urls() {
    sed -e "s#^To $HOME/server/#To example.com:jon/#" \
        -e "s#^From $HOME/server/#From example.com:jon/#" \
        -e "s#to '$HOME/server/#to 'example.com:jon/#" \
        -e "s#$HOME/server/#git@example.com:jon/#g"
}

# snippet N prints code block N from the lesson's snippets.md (copied from the
# post by tools/extract-transcripts.py), so the demo runs the post's own code.
snippet() {
    python3 - "$1" "${LESSON_DIR:?}/snippets.md" <<'PY'
import re, sys
n, path = int(sys.argv[1]), sys.argv[2]
blocks = re.findall(r"^## snippet (\d+)\n```\w*\n(.*?)\n```", open(path).read(), re.S | re.M)
sys.stdout.write(dict((int(k), v) for k, v in blocks)[n] + "\n")
PY
}

# expect_snippet N FILE checks that FILE (something a demo captured, such as the
# todo list git handed to an editor) is exactly snippet N from the post. On a
# mismatch it prints SNIPPET MISMATCH, which fails the lesson's test.
expect_snippet() {
    if ! diff <(snippet "$1") "$2" >/dev/null; then
        echo "SNIPPET MISMATCH: snippet $1 differs from ${2##*/}"
        diff <(snippet "$1") "$2" | sed 's/^/    /'
    fi
}
