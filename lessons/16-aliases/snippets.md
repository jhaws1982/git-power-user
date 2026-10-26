# Code from the post (not transcripts), numbered for demo.sh's `snippet N`

## snippet 1
```bash
git config --global alias.st 'status -sb'
```

## snippet 2
```gitconfig
[alias]
	st = status -sb
	sw = switch
	br = branch -vv
	lg = log --graph --pretty=format:'%C(auto)%h%d %s %C(dim)(%cr, %an)%C(reset)'
	unstage = restore --staged
	amend = commit --amend --no-edit
	pushf = push --force-with-lease
	last = log -1 --stat
	aliases = config --get-regexp ^alias\\.
	gone = !git branch -vv | awk '/: gone]/ {print $1}'
	cleanup = !git branch --merged main | grep -v -e '^\\*' -e ' main$' | xargs -r git branch -d
	fixup = "!f() { git commit --fixup=\"$1\" && GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash \"$1~1\"; }; f"
```
