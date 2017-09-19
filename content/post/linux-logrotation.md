---
title: "Linux Logrotation"
date: 2017-09-11T17:08:34+08:00
tags: [ "Logrotation" ]
categories: [ "Linux" ]
draft: true
---

# config options

## rotate count
- rotate n

## permission
- create 0664 USER GROUP

## by interval
- daily
- weekly
- monthly
- yearly

## by size
- size 100k
- size 100M
- size 100G

## archive
- compress
- nocompress

## Postrotate
postrotate
    /usr/sbin/apachectl restart > /dev/null
endscript

## script
- prerotate：executed before the log file is rotated
- postrotate：在做完 logrotate 之後啟動的指令，例如重新啟動 (kill -1 或 kill -HUP) 某個服務;
```
postrotate
        /bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
endscript
}
```

## others
- missingok：If the log file is missing, go on to the next one without issu-ing an error message
