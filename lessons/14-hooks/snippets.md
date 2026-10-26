# Code from the post (not transcripts), numbered for demo.sh's `snippet N`

## snippet 1
```bash
#!/bin/sh
# Reject the commit if any staged C/C++ file isn't clang-formatted.
# Checks the staged content (what will be committed), not the working tree.
status=0
for f in $(git diff --cached --name-only --diff-filter=ACMR -- '*.c' '*.h' '*.cpp' '*.hpp'); do
    if ! git show ":$f" | clang-format --assume-filename="$f" --dry-run --Werror >/dev/null 2>&1; then
        echo "pre-commit: $f is not clang-formatted (run: clang-format -i $f)"
        status=1
    fi
done
exit $status
```

## snippet 2
```yaml
BasedOnStyle: LLVM
IndentWidth: 4
ColumnLimit: 100
BreakBeforeBraces: Linux
AllowShortFunctionsOnASingleLine: None
```

## snippet 3
```bash
#!/bin/sh
# Run the unit tests before anything leaves this machine.
echo "pre-push: running unit tests"
make -s test || { echo "pre-push: tests failed, push aborted"; exit 1; }
```

## snippet 4
```bash
#!/bin/sh
# Require a short, capitalized subject line with no trailing period.
subject=$(head -n1 "$1")
if [ ${#subject} -gt 72 ]; then
    echo "commit-msg: subject is ${#subject} characters; keep it to 72 or fewer"
    exit 1
fi
case "$subject" in
    [a-z]*) echo "commit-msg: start the subject with a capital letter"; exit 1 ;;
    *.) echo "commit-msg: drop the period at the end of the subject"; exit 1 ;;
esac
```
