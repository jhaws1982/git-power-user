# Transcripts: git clone Options Worth Knowing: Branches, Shallow and Blobless Clones, and Submodules

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```shell
$ git clone -b smp --single-branch https://github.com/FreeRTOS/FreeRTOS-Kernel.git smp
Cloning into 'smp'...
$ cd smp
$ git branch -a
* smp
  remotes/origin/smp
```

```shell
$ git switch main
fatal: invalid reference: main
```

```shell
$ git remote set-branches --add origin main
$ git fetch -q origin
$ git switch main
branch 'main' set up to track 'origin/main'.
Switched to a new branch 'main'
```

```shell
$ git describe --tags
fatal: No names found, cannot describe anything.
```

```shell
$ git clone git/firmware fw1
Cloning into 'fw1'...
done.
$ git -C fw1 submodule status
-9cf66d846c96dd08b0f1cdbe4e459c6196d8c808 drivers/hal
```

```shell
$ git clone --recurse-submodules git/firmware fw2
Cloning into 'fw2'...
done.
Submodule 'drivers/hal' (/home/jon/git/hal) registered for path 'drivers/hal'
Cloning into '/home/jon/fw2/drivers/hal'...
done.
Submodule path 'drivers/hal': checked out '9cf66d846c96dd08b0f1cdbe4e459c6196d8c808'
```
