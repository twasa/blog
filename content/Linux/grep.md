---
title: "Grep"
date: 2017-09-11T10:52:53+08:00
tags: [ "command" ]
categories: [ "Linux" ]
draft: true
---

## description

- prints lines that contain a match for a pattern
- reference

<https://www.gnu.org/software/grep/manual/grep.html>

## syntax

```shell
grep [OPTIONS] PATTERN [FILE...]
```

- grep multiple patterns

```shell
#OR
grep 'pattern1\|pattern2\|pattern3'

#AND
grep -E 'pattern1.*pattern2.*pattern3' filename
```

```shell
-v, --invert-match
    Invert the sense of matching, to select non-matching lines. (-v is specified by POSIX .)

grep -v 'unwanted_word'

-i, --ignore-case
Ignore case distinctions in both the PATTERN and the input files. (-i is specified by POSIX .)
```