# Code from the post (not transcripts), numbered for demo.sh's `snippet N`

## snippet 1
```bash
git config --global user.name "Jonathan Haws"
git config --global user.email "jon@work.example"
```

## snippet 2
```bash
cd ~/git/my-open-source-project
git config user.email "jon@personal.example"
```

## snippet 3
```bash
git config --global init.defaultBranch main
```

## snippet 4
```bash
git config --global pull.ff only
```

## snippet 5
```bash
git config --global fetch.prune true
```

## snippet 6
```bash
git config --global merge.conflictStyle zdiff3
```

## snippet 7
```bash
git config --global rerere.enabled true
```

## snippet 8
```ini
[user]
	name = Jonathan Haws
	email = jon@work.example
[init]
	defaultBranch = main
[core]
	editor = vim
[pull]
	ff = only
[push]
	autoSetupRemote = true
[fetch]
	prune = true
[merge]
	conflictStyle = zdiff3
[rerere]
	enabled = true
[diff]
	colorMoved = default
[rebase]
	autoStash = true
[commit]
	verbose = true
```

## snippet 9
```text
* text=auto
*.sh text eol=lf
*.bat text eol=crlf
```

## snippet 10
```bash
git config --list --show-origin --show-scope
```
