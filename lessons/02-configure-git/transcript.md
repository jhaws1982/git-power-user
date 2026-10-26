# Transcripts: Configuring git: Global vs. Local Settings and the Options Worth Changing

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```shell
$ git config --list --show-origin --show-scope
global	file:/home/jon/.gitconfig	user.name=Jonathan Haws
global	file:/home/jon/.gitconfig	user.email=jon@work.example
global	file:/home/jon/.gitconfig	init.defaultbranch=main
local	file:.git/config	core.repositoryformatversion=0
local	file:.git/config	core.filemode=true
local	file:.git/config	core.bare=false
local	file:.git/config	core.logallrefupdates=true
local	file:.git/config	user.email=jon@personal.example
```

```shell
$ git config --show-origin --show-scope user.email
local	file:.git/config	jon@personal.example
```

```shell
$ git -c user.email=ci-bot@example.com config user.email
ci-bot@example.com
```

```shell
$ git pull
hint: Diverging branches can't be fast-forwarded, you need to either:
hint: 
hint: 	git merge --no-ff
hint: 
hint: or:
hint: 
hint: 	git rebase
hint: 
hint: Disable this message with "git config advice.diverging false"
fatal: Not possible to fast-forward, aborting.
```

```shell
$ git push
fatal: The current branch fix-uart-overrun has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin fix-uart-overrun
```

```shell
$ git config --global push.autoSetupRemote true
$ git push
To /home/jon/server.git
 * [new branch]      fix-uart-overrun -> fix-uart-overrun
branch 'fix-uart-overrun' set up to track 'origin/fix-uart-overrun'.
```
