# Transcripts: Tag Releases and Sign Commits in git: Annotated Tags, describe, and SSH Signing

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ git tag v1.0-rc1
$ git tag -a v1.0 -m 'Sensor firmware 1.0'

$ git cat-file -t v1.0-rc1
commit
$ git cat-file -t v1.0
tag

$ git cat-file -p v1.0
object 4c8599430b3874ea6101d92bd45d358be12b50c0
type commit
tag v1.0
tagger Jonathan Haws <jon@example.com> 1792508520 -0600

Sensor firmware 1.0
```

```console
$ git describe
v1.0-2-g0c27521
$ git describe --dirty
v1.0-2-g0c27521-dirty
```

```console
$ git tag -l 'v1.*'
v1.0
v1.0-rc1
v1.10
v1.2
v1.9

$ git config --global tag.sort version:refname
$ git tag -l 'v1.*'
v1.0
v1.0-rc1
v1.2
v1.9
v1.10

$ git config --global versionsort.suffix -rc
$ git tag -l 'v1.*'
v1.0-rc1
v1.0
v1.2
v1.9
v1.10
```

```console
$ git push origin main
To example.com:jon/sensor-fw.git
   4c85994..0c27521  main -> main

$ git ls-remote --tags origin

$ git push --follow-tags origin
To example.com:jon/sensor-fw.git
 * [new tag]         v1.0 -> v1.0

$ git ls-remote --tags origin
a73588a5524636654a56573d900a3bfd6b42631d	refs/tags/v1.0
4c8599430b3874ea6101d92bd45d358be12b50c0	refs/tags/v1.0^{}
```

```console
$ git archive --prefix=sensor-fw-1.0/ -o sensor-fw-1.0.tar.gz v1.0
$ tar tzf sensor-fw-1.0.tar.gz
sensor-fw-1.0/
sensor-fw-1.0/notes.txt
```

```console
$ git config --global gpg.format ssh
$ git config --global user.signingKey ~/.ssh/id_ed25519.pub
$ git commit -S -q -m 'Add sleep current limit' && git log --show-signature -1 --oneline
error: gpg.ssh.allowedSignersFile needs to be configured and exist for ssh signature verification
8106be4 No signature
Add sleep current limit
```

```console
$ echo "jon@example.com $(cat ~/.ssh/id_ed25519.pub)" > ~/.ssh/allowed_signers
$ git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
$ git log --show-signature -1 --oneline
8106be4 Good "git" signature for jon@example.com with ED25519 key SHA256:dSG+BsgT7SxdDiHt51h/lCPoFw3SLURbSRLPXz2ZzjI
Add sleep current limit
```

```console
$ git tag -s v1.1 -m 'Sensor firmware 1.1'

$ git verify-tag v1.1
Good "git" signature for jon@example.com with ED25519 key SHA256:dSG+BsgT7SxdDiHt51h/lCPoFw3SLURbSRLPXz2ZzjI
```

```console
$ git log --format='%h %G? %s' -3
8106be4 G Add sleep current limit
95a3a36 N Add sleep mode
0c27521 N Add watchdog
```
