#!/usr/bin/env bash
# Lesson 5, credential helpers: reproduces every transcript in the post.
# Runs in a throwaway HOME with an example token; safe to run on your own machine.
source "${LIB:-$(dirname "$0")/../../tests/lib.sh}"
me

run "git config --global credential.helper store"
run "printf 'protocol=https\nhost=github.com\nusername=myGitHubUsername\npassword=ghp_EXAMPLEtoken1234567890\n\n' | git credential approve"
show "printf 'protocol=https\nhost=github.com\n\n' | git credential fill"

show "cat ~/.git-credentials"

run "git config --global credential.https://github.com.helper store"
run "git config --global credential.https://bitbucket.org.helper 'cache --timeout=3600'"
show "git config --global --get-regexp '^credential\.'"

run "printf 'protocol=https\nhost=github.com\nusername=myGitHubUsername\n\n' | git credential reject"
run "cat ~/.git-credentials"
printf '$\n'   # the post shows an empty prompt: the file is now empty
