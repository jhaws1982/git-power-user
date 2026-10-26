# A reference solution for lessons/14-hooks: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
cd "$LAB/sensor-fw" && mkdir -p .githooks && cat > .githooks/commit-msg <<'H'
#!/bin/sh
head -1 "$1" | grep -q '^[A-Z]' || { echo "commit-msg: start the subject with a capital letter" >&2; exit 1; }
H
chmod +x .githooks/commit-msg && git config core.hooksPath .githooks && git add .githooks && git commit -q -m "Add commit-msg hook"
