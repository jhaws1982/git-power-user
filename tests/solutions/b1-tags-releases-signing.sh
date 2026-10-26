# A reference solution for lessons/b1-tags-releases-signing: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
cd "$LAB/sensor-fw" && git tag -a v1.0 -m "Sensor firmware 1.0" HEAD~1 && git push -q origin v1.0 2>/dev/null
