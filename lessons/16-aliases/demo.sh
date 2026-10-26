#!/usr/bin/env bash
# Lesson 16, aliases: reproduces every transcript in the post, using the post's
# own [alias] block (snippet 2). Runs in a throwaway HOME; ~/server/ is the remote.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me
snippet 2 >> ~/.gitconfig
{
git init -q --bare server/sensor-fw.git
git clone -q server/sensor-fw.git sensor-fw 2>/dev/null; cd sensor-fw || exit 1
mkdir -p src && echo "int main(void){return 0;}" > src/main.c && git add . && git commit -qm "Initial commit"
git push -q -u origin main
export GIT_COMMITTER_DATE="2026-10-21T10:00:00-0600" GIT_AUTHOR_DATE="2026-10-21T10:00:00-0600"
git switch -qc fix/uart-timeout && echo "int uart;" > src/uart.c && git add . && git commit -qm "Add UART driver"
echo "int timeout;" >> src/uart.c && git commit -qam "Fix RX timeout"
git switch -q main && git merge -q --no-ff -m "Merge branch 'fix/uart-timeout'" fix/uart-timeout
export GIT_COMMITTER_DATE="2026-10-22T11:00:00-0600" GIT_AUTHOR_DATE="2026-10-22T11:00:00-0600"
echo "int wdt;" > src/wdt.c && git add . && git commit -qm "Add watchdog kick"

echo "/* wip */" >> src/main.c && echo "notes" > notes.txt
show "git st"
show "git lg"
run "git add notes.txt"
run "git st"
run "git unstage notes.txt"
show "git st"
rm notes.txt && git restore src/main.c
echo "int wdt_kick(void);" >> src/wdt.c && git add src/wdt.c && git amend -q

show "git cleanup"
git switch -qc feature/old && git push -q -u origin feature/old 2>/dev/null && git switch -q main
git push -q origin --delete feature/old 2>/dev/null && git fetch -q --prune
run "git br"
show "git gone"

echo "int a;" > src/a.c && git add . && git commit -qm "Add a"
echo "int b;" > src/b.c && git add . && git commit -qm "Add b"
echo "int a2;" >> src/a.c && git add src/a.c
run "git fixup $(git log --format=%h --grep='^Add a$')"
show "git log --oneline -3"

run "cd src"
run "git config --global alias.here '!echo \"you ran this from: \${GIT_PREFIX:-./}\"'"
show "git here"
show "git aliases"
} 2>&1 | server_urls
