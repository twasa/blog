---
title: "xargs"
date: 2017-09-11T11:32:12+08:00
tags: [ "command" ]
categories: [ "Linux" ]
draft: true
---

# xargs

## description
- build and execute command lines from standard input

## syntax and examples
- Find all .log files in or below the current directory and process them

```
find . -name "*.log" -type f -print | xargs tar -cvf logs.tar

find . -name "*.log" -type f -print | xargs -i -p cp -a {} /some/place

find . -name "*.log" -type f -print | xargs -I [] cp -a [] /some/place

-p Prompt the user about whether to run each command line and read a line from the terminal. Only run the command line if the response starts with 'y' or 'Y'.

-I replace-str
    Replace occurrences of replace-str in the initial-arguments with names read from standard input. Also, unquoted blanks do not terminate input items; instead the separator is the newline character. Implies -x and -L 1.

-i[replace-str]
    This option is a synonym for -Ireplace-str if replace-str is specified, and for -I{} otherwise. This option is deprecated; use -I instead.
```
