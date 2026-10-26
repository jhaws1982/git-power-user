# A reference solution for lessons/12-clean-up-history: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
cd "$LAB/sensor-fw" && GIT_SEQUENCE_EDITOR="sed -i -E 's/^pick ([0-9a-f]+) (# )?wip$/fixup \1 \2wip/'" git rebase -q -i --autosquash main
