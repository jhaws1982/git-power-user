# A reference solution for lessons/01-how-git-stores-your-work: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
cd "$LAB/sensor-fw" && git rev-parse 'HEAD~1:src' > ../answer.txt
