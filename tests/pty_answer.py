#!/usr/bin/env python3
"""Run a command on a pseudo-terminal and answer its prompts, so programs that
read from the terminal (ssh-keygen's passphrase prompts, for example) can run
unattended in a demo or in CI.

usage: pty_answer.py 'PROMPT[=ANSWER]' ... -- command args...
Prompts are matched in order. Each answer (empty if no =ANSWER) is typed and
followed by Enter. Output is printed with the terminal's CR-LF line endings turned into LF.
"""
import os
import pty
import select
import sys


def main(argv):
    sep = argv.index("--")
    pairs = [(a.split("=", 1) + [""])[:2] for a in argv[:sep]]
    cmd = argv[sep + 1:]
    pid, fd = pty.fork()
    if pid == 0:
        os.execvp(cmd[0], cmd)
    seen, out = b"", bytearray()
    while True:
        ready, _, _ = select.select([fd], [], [], 30)
        if not ready:
            break
        try:
            chunk = os.read(fd, 4096)
        except OSError:  # the child closed the terminal
            break
        if not chunk:
            break
        out += chunk
        seen += chunk
        if pairs and pairs[0][0].encode() in seen:
            os.write(fd, pairs.pop(0)[1].encode() + b"\n")
            seen = b""
    _, status = os.waitpid(pid, 0)
    sys.stdout.write(out.decode(errors="replace").replace("\r\n", "\n"))
    return os.waitstatus_to_exitcode(status)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
