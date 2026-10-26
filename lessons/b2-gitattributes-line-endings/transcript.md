# Transcripts: .gitattributes and Line Endings: Stop CRLF Diffs for Good

Every block below is copied from the post. tests/check_lesson.py runs
demo.sh and fails if any block stops matching its output.

```console
$ git ls-files --eol
i/lf    w/lf    attr/                 	build.sh
i/-text w/-text attr/                 	cal.bin
i/crlf  w/crlf  attr/                 	flash.bat
i/lf    w/lf    attr/                 	main.c
i/crlf  w/crlf  attr/                 	notes.txt
```

```console
$ git add --renormalize .
$ git status --short
M  flash.bat
M  notes.txt
?? .gitattributes
```

```console
$ git add .gitattributes && git commit -q -m 'Normalize line endings' && git ls-files --eol
i/lf    w/lf    attr/text=auto        	.gitattributes
i/lf    w/lf    attr/text eol=lf      	build.sh
i/-text w/-text attr/-text            	cal.bin
i/lf    w/crlf  attr/text eol=crlf    	flash.bat
i/lf    w/lf    attr/text=auto        	main.c
i/lf    w/crlf  attr/text=auto        	notes.txt
```

```console
$ git ls-files --eol
i/lf    w/lf    attr/text=auto        	.gitattributes
i/lf    w/lf    attr/text eol=lf      	build.sh
i/-text w/-text attr/-text            	cal.bin
i/lf    w/crlf  attr/text eol=crlf    	flash.bat
i/lf    w/lf    attr/text=auto        	main.c
i/lf    w/lf    attr/text=auto        	notes.txt
```

```console
$ git check-attr -a build.sh flash.bat cal.bin
build.sh: text: set
build.sh: eol: lf
flash.bat: text: set
flash.bat: eol: crlf
cal.bin: binary: set
cal.bin: diff: unset
cal.bin: merge: unset
cal.bin: text: unset
```

```console
$ git diff cal.bin
diff --git a/cal.bin b/cal.bin
index 0104d7a..ac8ba98 100644
Binary files a/cal.bin and b/cal.bin differ
```

```console
$ git config diff.hex.textconv 'od -An -tx1'
$ echo '*.bin diff=hex' >> .gitattributes
$ git diff cal.bin
diff --git a/cal.bin b/cal.bin
index 0104d7a..ac8ba98 100644
--- a/cal.bin
+++ b/cal.bin
@@ -1 +1 @@
- 7f 43 41 4c 01 02 03 04
+ 7f 43 41 4c 01 02 09 04
```
