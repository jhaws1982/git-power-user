# Transcripts: One Machine, Two git Identities: Switch Your Email Automatically with includeIf

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ cd ~/git/personal/blog && git config user.email
jon@personal.example
$ cd ~/git/work/sensor-fw && git config user.email
jon@work.example
$ cd ~/git/work/sensor-fw/src && git config user.email
jon@work.example
$ cd ~/git/work && git config user.email
jon@personal.example
```

```console
$ cd ~/git/work/sensor-fw
$ git config --show-origin user.email
file:/home/jon/.gitconfig-work	jon@work.example
$ git config -l --show-origin | grep -E 'email|includeif'
file:/home/jon/.gitconfig	user.email=jon@personal.example
file:/home/jon/.gitconfig	includeif.gitdir:~/git/work/.path=~/.gitconfig-work
file:/home/jon/.gitconfig-work	user.email=jon@work.example
```

```console
$ git commit -q --allow-empty -m "Initial commit"
$ git log -1 --format='%an <%ae>'
Jonathan Haws <jon@work.example>
```

```console
$ grep includeIf ~/.gitconfig
[includeIf "gitdir:~/git/work"]
$ cd ~/git/work/sensor-fw && git config user.email
jon@personal.example
```

```console
$ git init -q ~/elsewhere/acme-tool && cd ~/elsewhere/acme-tool
$ git config user.email
jon@personal.example
$ git remote add origin git@github.com:acme/acme-tool.git
$ git config user.email
jon@work.example
```
