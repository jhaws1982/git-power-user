# A reference solution for lessons/07-atomic-commits: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
cd "$LAB/sensor-fw" && printf 's\ny\nn\n' | git add -p sensor.c >/dev/null && git commit -q -m "Fix overflow in sensor scaling" && git commit -qam "Reject readings above full scale"
