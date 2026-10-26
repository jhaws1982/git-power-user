# Code from the post (not transcripts), numbered for demo.sh's `snippet N`

## snippet 1
```gitconfig
[user]
	name = Jonathan Haws
	email = jon@personal.example
[includeIf "gitdir:~/git/work/"]
	path = ~/.gitconfig-work
```

## snippet 2
```gitconfig
[user]
	email = jon@work.example
```

## snippet 3
```gitconfig
[includeIf "hasconfig:remote.*.url:git@github.com:acme/**"]
	path = ~/.gitconfig-work
```
