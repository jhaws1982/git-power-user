# Transcripts: How git Stores Your Work: Blobs, Trees, Commits, and Refs

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ printf '# sensor-fw\n' | git hash-object --stdin
0a6adb79412de422c0608ec9345b7b3c24cd1195

$ printf 'blob 12\0# sensor-fw\n' | sha1sum
0a6adb79412de422c0608ec9345b7b3c24cd1195  -
```

```console
$ find .git/objects -type f

$ git add README.md src/main.c
$ find .git/objects -type f | sort
.git/objects/0a/6adb79412de422c0608ec9345b7b3c24cd1195
.git/objects/78/f2de106c92b0d60772bd5aa6c1e6da7bf71005
```

```console
$ git commit -q -m 'Initial commit'
$ git cat-file -t HEAD
commit

$ git cat-file -p HEAD
tree d6f1bb0901496f828a732c8a6cc7f1465884fbe2
author Jonathan Haws <jon@example.com> 1792508400 -0600
committer Jonathan Haws <jon@example.com> 1792508400 -0600

Initial commit
```

```console
$ git cat-file -p 'HEAD^{tree}'
100644 blob 0a6adb79412de422c0608ec9345b7b3c24cd1195	README.md
040000 tree ed46dd19f6204c92947780231982716d4016b9bb	src

$ git cat-file -p HEAD:src
100644 blob 78f2de106c92b0d60772bd5aa6c1e6da7bf71005	main.c

$ git cat-file -p HEAD:README.md
# sensor-fw
```

```console
$ cat .git/HEAD
ref: refs/heads/main
$ cat .git/refs/heads/main
49146d51c975304e68c36fc357b4773ab392e81c

$ git switch -q -c feature/adc && cat .git/refs/heads/feature/adc
49146d51c975304e68c36fc357b4773ab392e81c
```

```console
$ git add src/adc.c && git commit -q -m 'Add ADC stub'
$ git cat-file -p HEAD
tree 2e910e317988cfd92d1568c8179eaa40245ac790
parent 49146d51c975304e68c36fc357b4773ab392e81c
author Jonathan Haws <jon@example.com> 1792508460 -0600
committer Jonathan Haws <jon@example.com> 1792508460 -0600

Add ADC stub
```

```console
$ git ls-tree HEAD
100644 blob 0a6adb79412de422c0608ec9345b7b3c24cd1195	README.md
040000 tree 859aea09387fc2ce4ce069d98f7f9458abcf8a72	src
$ git ls-tree HEAD~1
100644 blob 0a6adb79412de422c0608ec9345b7b3c24cd1195	README.md
040000 tree ed46dd19f6204c92947780231982716d4016b9bb	src
```

```console
$ cat .git/refs/heads/feature/adc .git/refs/heads/main
eda7403a4a104457cdbd3df273563f66a2838f1b
49146d51c975304e68c36fc357b4773ab392e81c
```

```console
$ git switch -q --detach HEAD~1 && cat .git/HEAD
49146d51c975304e68c36fc357b4773ab392e81c
```

```console
$ git count-objects -v | head -2
count: 9
size: 36

$ git gc -q && git count-objects -v | grep -E '^(count|in-pack|packs)'
count: 0
in-pack: 9
packs: 1
```
