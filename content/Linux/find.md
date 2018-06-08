---
title: "find"
date: 2017-09-11T11:43:41+08:00
tags: [ "command" ]
categories: [ "Linux" ]
draft: true
---

# find

## description
- search for files in a directory hierarchy

## syntax
```
find [options] [path...] [expression]

--newerXY
 Compares the timestamp of the current file with reference. The reference argument is normally the name of a file (and one of its timestamps is used for the comparison) but it may also be a string describing an absolute time. X and Y are placeholders for other letters, and these letters select which time belonging to how reference is used for the comparison

find file modified newer than some daytimes
find /var/log -newermt '2016-06-01T00:00:00'

-name pattern
    Base of file name (the path with the leading directories removed) matches shell pattern pattern.The metacharacters ('*', '?', and '[]') match a '.' at the start of the base name (this is a change in findutils-4.2.2; see section STANDARDS CONFORMANCE below)
```
