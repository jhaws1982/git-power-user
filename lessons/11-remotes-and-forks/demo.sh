#!/usr/bin/env bash
# Lesson 11, remotes and forks: reproduces every transcript in the post.
# Runs in a throwaway HOME. Three bare repositories under ~/srv/ stand in for the
# original project (acme), your fork (jhaws1982), and a teammate's fork (alice);
# urls() prints their paths as the GitHub URLs the post uses.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me
git config --global advice.detachedHead false
SRV=$HOME/srv
urls() {
    sed -E -e "s#^To $SRV/jon\.git#To github.com:jhaws1982/sensor-fw.git#" \
        -e "s#$SRV/upstream\.git#https://github.com/acme/sensor-fw.git#g; s#$SRV/upstream#https://github.com/acme/sensor-fw#g" \
        -e "s#$SRV/jon\.git#git@github.com:jhaws1982/sensor-fw.git#g; s#$SRV/jon#git@github.com:jhaws1982/sensor-fw#g" \
        -e "s#$SRV/alice\.git#https://github.com/alice/sensor-fw.git#g; s#$SRV/alice#https://github.com/alice/sensor-fw#g"
}
{
mkdir -p "$SRV"
git init -q --bare "$SRV/upstream.git"
git clone -q "$SRV/upstream.git" seed 2>/dev/null && cd seed || exit 1
echo "int main(void){return 0;}" > main.c && git add . && git commit -qm "Initial commit" && git push -q origin main && tick
cd "$HOME" && rm -rf seed
git clone -q --bare "$SRV/upstream.git" "$SRV/jon.git"
git clone -q --bare "$SRV/upstream.git" "$SRV/alice.git"
git clone -q "$SRV/jon.git" sensor-fw && cd sensor-fw || exit 1

show "git remote -v"
run "git remote add upstream $SRV/upstream.git"
show "git remote -v"

# The original project moves on.
cd "$HOME" && git clone -q "$SRV/upstream.git" maint && cd maint && git config user.name "Maintainer"
echo "/* v1.1 */" >> main.c && git commit -qam "Release v1.1" && tick
echo "/* wdt */" > wdt.c && git add . && git commit -qm "Add watchdog driver" && git push -q && tick
cd "$HOME/sensor-fw" || exit 1

run "git fetch upstream"
show "git log --oneline main..upstream/main"
run "git merge --ff-only upstream/main"
show "git push origin main"
run "git branch -u upstream/main main"
run "git config remote.pushDefault origin"
show "git branch -vv"

git switch -qc fix/i2c-retry && echo "/* retry */" > i2c.c && git add . && git commit -qm "Retry I2C on NACK" && tick
git push -q -u origin fix/i2c-retry 2>/dev/null
git switch -q main

# Alice's fork has a branch to try.
cd "$HOME" && git clone -q "$SRV/alice.git" alice && cd alice || exit 1
git config user.name "Alice" && git config user.email a@example.com
git fetch -q "$SRV/upstream.git" main && git merge -q --ff-only FETCH_HEAD
git switch -qc fix/uart-timeout && echo "/* uart */" > uart.c && git add . && git commit -qm "Fix UART RX timeout" && tick
git push -q -u origin fix/uart-timeout 2>/dev/null
cd "$HOME/sensor-fw" || exit 1

run "git remote add alice $SRV/alice.git"
run "git fetch alice"
show "git branch -r"
show "git switch fix/uart-timeout"

cd "$HOME/alice" && echo "/* fix 2 */" >> uart.c && git commit -qam "Clear overrun flag before retry" && git push -q && tick
cd "$HOME/sensor-fw" || exit 1
show "git pull"
echo "/* my tweak */" >> uart.c && git commit -qam "Tweak timeout constant" && tick
show "git push"
show "git push alice fix/uart-timeout"
run "git fetch $SRV/alice.git fix/uart-timeout"
show "git log --oneline -1 FETCH_HEAD"

git switch -q main
run "git remote remove alice"
show "git branch -vv"

run "git remote set-url --push upstream no_push"
show "git push upstream main"
} 2>&1 | urls
