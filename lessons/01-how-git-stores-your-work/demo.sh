#!/usr/bin/env bash
# Lesson 1, how git stores your work: reproduces every transcript in the post.
# Runs in a throwaway HOME; safe to run on your own machine.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me
git init -q sensor-fw && cd sensor-fw || exit 1
mkdir src
printf 'int main(void) { return 0; }\n' > src/main.c
printf '# sensor-fw\n' > README.md

# Content in, id out: the same bytes always get the same name.
show "printf '# sensor-fw\n' | git hash-object --stdin"
show "printf 'blob 12\0# sensor-fw\n' | sha1sum"
show "find .git/objects -type f"
run "git add README.md src/main.c"
show "find .git/objects -type f | sort"
run "git commit -q -m 'Initial commit'"
show "git cat-file -t HEAD"
show "git cat-file -p HEAD"
show "git cat-file -p 'HEAD^{tree}'"
show "git cat-file -p HEAD:src"
show "git cat-file -p HEAD:README.md"

# A branch is a file holding one commit id; HEAD says which branch you're on.
run "cat .git/HEAD"
show "cat .git/refs/heads/main"
show "git switch -q -c feature/adc && cat .git/refs/heads/feature/adc"

# A second commit: only what changed gets a new object.
tick
printf 'int adc_read(void) { return 0; }\n' > src/adc.c
run "git add src/adc.c && git commit -q -m 'Add ADC stub'"
show "git cat-file -p HEAD"
run "git ls-tree HEAD"
show "git ls-tree HEAD~1"
show "cat .git/refs/heads/feature/adc .git/refs/heads/main"

# Detached HEAD: HEAD holds a commit id instead of a branch name.
show "git switch -q --detach HEAD~1 && cat .git/HEAD"
git switch -q feature/adc
show "git count-objects -v | head -2"
show "git gc -q && git count-objects -v | grep -E '^(count|in-pack|packs)'"
