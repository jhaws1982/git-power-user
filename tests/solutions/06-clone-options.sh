# A reference solution for lessons/06-clone-options: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
git clone -q --depth 1 -b smp "file://$LAB/server/kernel.git" "$LAB/clone"
