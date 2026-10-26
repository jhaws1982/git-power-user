# Transcripts: Setting Up SSH Keys for git on Linux, WSL, and Windows (and in Dev Containers)

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```shell
$ ssh-keygen -t ed25519 -C "jon@work.example"
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/jon/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/jon/.ssh/id_ed25519
Your public key has been saved in /home/jon/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:rFQAC1jugTJNNrvWe0ySVEwRuTY62ZPY56uJV4CJck4 jon@work.example
The key's randomart image is:
+--[ED25519 256]--+
| o* .+*+         |
|.* + oo.         |
|+ =.oo ..        |
|ooE=o.=o         |
| =+ +Bo+S        |
| .. =*=.o        |
|    ..+=         |
|     o...        |
|    ..o...       |
+----[SHA256]-----+
```

```shell
$ eval "$(ssh-agent -s)"
Agent pid 2408
$ ssh-add ~/.ssh/id_ed25519
Identity added: /home/jon/.ssh/id_ed25519 (jon@work.example)
$ ssh-add -l
256 SHA256:rFQAC1jugTJNNrvWe0ySVEwRuTY62ZPY56uJV4CJck4 jon@work.example (ED25519)
```

```shell
$ ssh -G github-personal | grep -E '^(hostname|user|identityfile|identitiesonly) '
user git
hostname github.com
identitiesonly yes
identityfile ~/.ssh/id_ed25519_personal
```

```shell
$ git remote set-url origin git@github-personal:jhaws1982/zRPC.git
$ git remote -v
origin	git@github-personal:jhaws1982/zRPC.git (fetch)
origin	git@github-personal:jhaws1982/zRPC.git (push)
```
