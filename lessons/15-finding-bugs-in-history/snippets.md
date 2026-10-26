# Code from the post (not transcripts), numbered for demo.sh's `snippet N`

## snippet 1
```bash
#!/bin/sh
# Exit 0 if this commit is good, 1 if it's bad, 125 if it can't be tested.
mkdir -p build
gcc -o build/test_adc adc.c test_adc.c 2>/dev/null || exit 125
./build/test_adc
```
