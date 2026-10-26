#!/usr/bin/env bash
# Lesson 6, clone options: reproduces every transcript in the post.
# Runs in a throwaway HOME; safe to run on your own machine.
#
# By default the FreeRTOS-Kernel clones go to a small local stand-in with the same
# branches (main, smp) and tags, so the demo runs offline in seconds. Set
# ONLINE=1 to clone the real repository from GitHub instead.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me
URL=https://github.com/FreeRTOS/FreeRTOS-Kernel.git

if [ "${ONLINE:-0}" != 1 ]; then
    git init -q mirror-src && cd mirror-src || exit 1
    for v in 10.4.3 10.5.0 11.0.0; do
        echo "kernel $v" > tasks.c && git add tasks.c && git commit -qm "Release V$v" && git tag "V$v"; tick
    done
    echo "work after the release" >> tasks.c && git commit -qam "Fix a typo"   # main is past its last tag
    git switch -qc smp && echo smp >> tasks.c && git commit -qam "SMP support" && git switch -q main
    cd "$HOME" && git clone -q --bare mirror-src mirror.git && rm -rf mirror-src
    git config --global url."file://$HOME/mirror.git".insteadOf "$URL"
fi

run "git clone -b smp --single-branch $URL smp"
run "cd smp"
show "git branch -a"
show "git switch main"
run "git remote set-branches --add origin main"
run "git fetch -q origin"
show "git switch main"

cd "$HOME" && git clone -q --depth 1 "$URL" shallow 2>/dev/null && cd shallow || exit 1
show "git describe --tags"

# Submodules: a firmware repo that uses a HAL repo, both on local disk.
cd "$HOME" && mkdir -p git && cd git || exit 1
git config --global protocol.file.allow always   # git 2.38.1+ blocks local-path submodules by default
git init -q hal && (cd hal && echo hal > hal.c && git add . && git commit -qm "HAL")
git init -q firmware && cd firmware && git submodule -q add "$HOME/git/hal" drivers/hal 2>/dev/null && git commit -qm "Add HAL"
cd "$HOME" || exit 1
run "git clone git/firmware fw1"
show "git -C fw1 submodule status"
show "git clone --recurse-submodules git/firmware fw2"
