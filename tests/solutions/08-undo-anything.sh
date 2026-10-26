# A reference solution for lessons/08-undo-anything: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
cd "$LAB/sensor-fw" && git reset -q --hard HEAD@{1} && git branch experiment/dma "$(git log -g --format=%H --grep='^Try DMA' HEAD | head -1)"
