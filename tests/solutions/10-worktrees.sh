# A reference solution for lessons/10-worktrees: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
cd "$LAB/sensor-fw" && git worktree add -q -b fix/i2c-timeout ../sensor-fw-hotfix main
