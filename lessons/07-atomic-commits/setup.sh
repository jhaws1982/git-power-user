#!/usr/bin/env bash
source "$(dirname "$0")/../../tests/exercise.sh"
# Builds this lesson's practice repository in lab/. Safe to re-run: it starts over.
new_lab
cd "$LAB" && lgit init -q sensor-fw && cd sensor-fw
cat > sensor.c <<'C'
int sensor_read_mv(int raw)
{
    return raw * 3300 / 4096;
}

int sensor_is_valid(int mv)
{
    return mv > 0;
}
C
lgit add sensor.c && lgit commit -q -m "Add sensor driver"
sed -i 's|return raw \* 3300 / 4096;|return (int)(raw * 3300L / 4096);|; s|return mv > 0;|return mv > 0 \&\& mv < 3300;|' sensor.c
ready
