#!/usr/bin/env bash
# Lesson 12, clean up a branch before review: reproduces every transcript in the post.
# The interactive rebase runs with a scripted editor that saves the todo list git
# offers (checked against the post's snippets 1 and 2) and makes the post's edit.
# Runs in a throwaway HOME; safe to run on your own machine.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me
git init -q sensor-fw && cd sensor-fw || exit 1
printf 'int main(void) { return 0; }\n' > main.c && git add . && git commit -qm "Initial commit" && tick

git switch -q -c feature/adc-filter
printf 'int adc_filter(int x);\n' > filter.h && git add . && git commit -qm "Add filter interface" && tick
printf '#include "filter.h"\nint adc_filter(int x) { return x; }\n' > filter.c && git add . && git commit -qm "Implement moving average" && tick
printf '/* window of 8 */\n' >> filter.c && git commit -qam "wip" && tick
printf 'int test_filter(void) { return adc_filter(0); }\n' > test_filter.c && git add . && git commit -qm "Add filter tests" && tick
show "git log --oneline main.."

# Review feedback on "Implement moving average": fix it with a fixup commit.
printf '#define FILTER_WINDOW 8\n' >> filter.h
avg=$(git log --format=%h --grep='^Implement moving average$')
run "git add filter.h"
show "git commit --fixup=$avg"

# The scripted editor: save the todo list, fold "wip" into the commit before it, save again.
cat > "$HOME/edit-todo.sh" <<'S'
#!/bin/sh
grep -v '^#' "$1" | grep -v '^$' > "$HOME/todo-before.txt"
sed -i 's/^pick \([0-9a-f]*\) \(# \)\{0,1\}wip$/fixup \1 \2wip/' "$1"   # newer git writes "pick <id> # wip"
grep -v '^#' "$1" | grep -v '^$' > "$HOME/todo-after.txt"
S
chmod +x "$HOME/edit-todo.sh"
export GIT_SEQUENCE_EDITOR="$HOME/edit-todo.sh"
show "git rebase -i --autosquash main"
expect_snippet 1 "$HOME/todo-before.txt"
expect_snippet 2 "$HOME/todo-after.txt"
unset GIT_SEQUENCE_EDITOR
show "git log --oneline main.."
show "git diff --stat feature/adc-filter@{1} feature/adc-filter"
show "git range-diff main feature/adc-filter@{1} feature/adc-filter"

snippet 3 | bash   # the post's config line: rebase.autoSquash for every interactive rebase
show "git config --global rebase.autoSquash"

# Stacked branches: --update-refs moves the branch underneath too.
git switch -q main && printf '/* boot */\n' >> main.c && git commit -qam "Fix boot order" && tick
git switch -q -c part1-driver feature/adc-filter~1
git switch -q -c part2-tests feature/adc-filter && git branch -q -D feature/adc-filter
run "git rebase --update-refs main"
show "git log --oneline --decorate main.."
