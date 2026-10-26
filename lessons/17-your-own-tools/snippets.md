# Code from the post (not transcripts), numbered for demo.sh's `snippet N`

## snippet 1
```bash
git config --global core.editor "code --wait"
```

## snippet 2
```bash
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff "$LOCAL" "$REMOTE"'
git config --global difftool.prompt false
```

## snippet 3
```bash
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait --merge "$REMOTE" "$LOCAL" "$BASE" "$MERGED"'
```

## snippet 4
```bash
#!/bin/sh
# Show the four files git hands a merge tool, then keep the LOCAL version.
echo "BASE   = $1"
echo "LOCAL  = $2"
echo "REMOTE = $3"
echo "MERGED = $4"
echo "LOCAL has:  $(grep return "$2")"
echo "REMOTE has: $(grep return "$3")"
cp "$2" "$4"
```

## snippet 5
```bash
git config --global mergetool.keepBackup false
```
