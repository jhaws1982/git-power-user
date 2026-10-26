# Transcripts: git Aliases That Earn Their Keep: Less Typing, Better Logs, Safer Defaults

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ git st
## main...origin/main [ahead 4]
 M src/main.c
?? notes.txt
```

```console
$ git lg
* d9a9a94 (HEAD -> main) Add watchdog kick (35 hours ago, Jonathan Haws)
*   584c076 Merge branch 'fix/uart-timeout' (3 days ago, Jonathan Haws)
|\  
| * 5a9fdee (fix/uart-timeout) Fix RX timeout (3 days ago, Jonathan Haws)
| * 704ccb3 Add UART driver (3 days ago, Jonathan Haws)
|/  
* cd30ed0 (origin/main) Initial commit (4 days ago, Jonathan Haws)
```

```console
$ git add notes.txt
$ git st
## main...origin/main [ahead 4]
A  notes.txt
 M src/main.c
$ git unstage notes.txt
$ git st
## main...origin/main [ahead 4]
 M src/main.c
?? notes.txt
```

```console
$ git cleanup
Deleted branch fix/uart-timeout (was 5a9fdee).
```

```console
$ git br
  feature/old c372faa [origin/feature/old: gone] Add watchdog kick
* main        c372faa [origin/main: ahead 4] Add watchdog kick
$ git gone
feature/old
```

```console
$ git fixup f823e4f
...
Successfully rebased and updated refs/heads/main.
$ git log --oneline -3
05fd916 Add b
f393fd4 Add a
c372faa Add watchdog kick
```

```console
$ cd src
$ git config --global alias.here '!echo "you ran this from: ${GIT_PREFIX:-./}"'
$ git here
you ran this from: src/
```

```console
$ git aliases
alias.st status -sb
alias.sw switch
alias.br branch -vv
...
```
