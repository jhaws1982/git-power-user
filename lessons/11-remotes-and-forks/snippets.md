# Code from the post (not transcripts), numbered for demo.sh's `snippet N`

## snippet 1
```bash
git clone git@github.com:jhaws1982/sensor-fw.git
cd sensor-fw
```

## snippet 2
```bash
# GitHub: pull request #42 into a local branch called pr-42
git fetch upstream pull/42/head:pr-42
git switch pr-42

# GitLab: merge request !42
git fetch upstream merge-requests/42/head:mr-42
```
