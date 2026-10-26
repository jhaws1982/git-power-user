# A reference solution for lessons/13-merge-strategies: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
cd "$LAB/sensor-fw" && git merge -q --squash feature/adc-filter >/dev/null && git commit -q -m "Add ADC filter (#7)"
