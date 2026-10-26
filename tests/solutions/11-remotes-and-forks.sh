# A reference solution for lessons/11-remotes-and-forks: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
cd "$LAB/sensor-fw" && git remote add upstream "$LAB/upstream.git" && git fetch -q upstream && git merge -q --ff-only upstream/main && git push -q origin main 2>/dev/null
