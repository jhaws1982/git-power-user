#!/usr/bin/env bash
# Bonus lesson 2, .gitattributes and line endings: reproduces every transcript in the post.
# A repository where a Windows editor committed CRLF line endings, fixed with the post's
# .gitattributes (snippet 1) and add --renormalize, then check-attr and a textconv diff
# for a binary file. Runs in a throwaway HOME.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me
git init -q sensor-fw && cd sensor-fw || exit 1
printf 'int main(void)\n{\n    return 0;\n}\n' > main.c
printf '#!/bin/sh\nmake -C fw\n' > build.sh && chmod +x build.sh
printf 'openocd -f board.cfg -c "program fw.elf verify reset exit"\r\n' > flash.bat
printf 'Bring-up notes\r\nUART at 115200\r\n' > notes.txt
printf '\x7fCAL\x01\x02\x03\x04' > cal.bin
git add . && git commit -qm "Initial commit" && tick

show "git ls-files --eol"

snippet 1 > .gitattributes
run "git add --renormalize ."
show "git status --short"
show "git add .gitattributes && git commit -q -m 'Normalize line endings' && git ls-files --eol"

# What a fresh clone checks out
cd .. && git clone -q sensor-fw fresh && cd fresh || exit 1
show "git ls-files --eol"
show "git check-attr -a build.sh flash.bat cal.bin"

# A readable diff for a binary file
printf '\x7fCAL\x01\x02\x09\x04' > cal.bin
show "git diff cal.bin"
run "git config diff.hex.textconv 'od -An -tx1'"
run "echo '*.bin diff=hex' >> .gitattributes"
show "git diff cal.bin"
