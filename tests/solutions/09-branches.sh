# A reference solution for lessons/09-branches: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
cd "$LAB/sensor-fw" && git switch -q -c feature/led && echo led > led.c && git add led.c && git commit -q -m "Add LED driver" && git push -q -u origin feature/led 2>/dev/null && git branch -q -d old/done
