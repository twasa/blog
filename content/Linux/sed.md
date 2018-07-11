---
title: "sed"
date: 2017-09-11T12:54:56+08:00
tags: [ "command" ]
categories: [ "Linux" ]
draft: true
---


# reference
- https://www.gnu.org/software/sed/manual/sed.html
- http://www.gnu.org/software/sed/manual/sed.html#Examples

# syntax
```
sed OPTIONS... [SCRIPT] [INPUTFILE...]
STDOUT | sed OPTIONS... [SCRIPT]
```

# OPTIONS
```
-i    edited in-place
```

# SCRIPT format
```
'起始行數,結束行數 指令/要被取代的字串/新字串/旗標'
```

## 指令：
s 搜尋並取代

## 旗標
g 取代全部
c 取代前詢問是否confirm
I 忽略 pattern 大小寫

# example
## modify CentOS linux hostname
```
sed -i 's/HOSTNAME\=.*/HOSTNAME\=NEWHOSTNAME/g' /etc/sysconfig/network
```

## change default delimiter
### 改用 ":"
```
sed 's:orig:NEW:'
```

### 改用 "#" 當delimiter
```
sed -e 's#/#\\#g'
```