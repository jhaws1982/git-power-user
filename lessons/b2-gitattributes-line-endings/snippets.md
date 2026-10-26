# Code from the post (not transcripts), numbered for demo.sh's `snippet N`

## snippet 1
```text
# Let git decide which files are text, and store text with LF endings.
* text=auto
# Line endings these files need in every checkout, on every OS.
*.sh  text eol=lf
*.bat text eol=crlf
# Never convert, diff, or merge these.
*.bin binary
```
