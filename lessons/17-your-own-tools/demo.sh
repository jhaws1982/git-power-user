#!/usr/bin/env bash
# Lesson 17, your own editor, difftool, and mergetool: reproduces every transcript
# in the post, running the post's own config commands and peek.sh (snippets 2-5).
# Runs in a throwaway HOME; safe to run on your own machine.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me
unset VISUAL EDITOR GIT_EDITOR
export GIT_AUTHOR_DATE="2026-10-23T09:00:00-0600" GIT_COMMITTER_DATE="2026-10-23T09:00:00-0600"
git init -q sensor-fw && cd sensor-fw || exit 1

run "EDITOR=nano git var GIT_EDITOR"
run 'git config --global core.editor "code --wait"'
run "EDITOR=nano git var GIT_EDITOR"
show "GIT_EDITOR=vim git var GIT_EDITOR"

show "git difftool --tool-help"   # skipped in the test: depends on what's installed

mkdir src && cat > src/adc.c <<'C'
int adc_read_mv(int raw)
{
    return (int)(raw * 3300L / 4096);
}
C
git add . && git commit -qm "Add ADC driver"
sed -i 's/3300L/3000L/' src/adc.c
show 'git difftool -y -x "diff -u"'
git restore src/adc.c

snippet 2 | bash && snippet 3 | bash   # the post's vscode difftool/mergetool settings

git switch -qc fix/full-scale && sed -i 's/4096/4095/' src/adc.c && git commit -qam "Use 4095 counts for full scale"
git switch -q main
sed -i 's/3300L/3000L/;s/4096/4096 \/* 12-bit *\//' src/adc.c && git commit -qam "Scale to 3.0 V reference"
run "git merge fix/full-scale"
show "cat src/adc.c"

snippet 4 > ~/peek.sh && chmod +x ~/peek.sh
run "git config --global mergetool.peek.cmd '~/peek.sh \"\$BASE\" \"\$LOCAL\" \"\$REMOTE\" \"\$MERGED\"'"
run "git config --global mergetool.peek.trustExitCode true"
show "git mergetool --tool=peek"
show "git status --short"

git merge --abort 2>/dev/null; rm -f src/adc.c.orig; git reset -q --hard
snippet 5 | bash   # mergetool.keepBackup false

run "git switch fix/full-scale"
run "git rebase main"
show "git mergetool --tool=peek"
git rebase --abort
