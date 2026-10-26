# Transcripts: Stop Typing Your git Password: Credential Helpers for HTTPS, Explained

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```shell
$ git config --global credential.helper store
$ printf 'protocol=https\nhost=github.com\nusername=myGitHubUsername\npassword=ghp_EXAMPLEtoken1234567890\n\n' | git credential approve
$ printf 'protocol=https\nhost=github.com\n\n' | git credential fill
protocol=https
host=github.com
username=myGitHubUsername
password=ghp_EXAMPLEtoken1234567890
```

```shell
$ cat ~/.git-credentials
https://myGitHubUsername:ghp_EXAMPLEtoken1234567890@github.com
```

```shell
$ git config --global credential.https://github.com.helper store
$ git config --global credential.https://bitbucket.org.helper 'cache --timeout=3600'
$ git config --global --get-regexp '^credential\.'
credential.helper store
credential.https://github.com.helper store
credential.https://bitbucket.org.helper cache --timeout=3600
```

```shell
$ printf 'protocol=https\nhost=github.com\nusername=myGitHubUsername\n\n' | git credential reject
$ cat ~/.git-credentials
$
```
