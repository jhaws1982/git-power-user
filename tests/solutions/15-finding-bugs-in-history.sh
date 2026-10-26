# A reference solution for lessons/15-finding-bugs-in-history: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
cd "$LAB/sensor-fw" && git bisect start HEAD v1.0 >/dev/null && git bisect run ./test.sh >/dev/null && git rev-parse refs/bisect/bad > ../answer.txt && git bisect reset >/dev/null 2>&1
