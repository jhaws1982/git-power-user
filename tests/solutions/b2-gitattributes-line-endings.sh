# A reference solution for lessons/b2-gitattributes-line-endings: tests/run-exercises.sh runs it to prove
# the exercise can be passed. Try the exercise yourself first.
cd "$LAB/sensor-fw" && printf '* text=auto\n*.sh text eol=lf\n*.bat text eol=crlf\n*.bin binary\n' > .gitattributes && git add --renormalize . && git add .gitattributes && git commit -q -m "Normalize line endings"
