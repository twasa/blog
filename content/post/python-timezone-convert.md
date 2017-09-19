---
title: "Python Timezone Convert example code"
date: 2017-09-11T17:49:51+08:00
tags: [ "Python", "Development" ]
draft: true
---

## Requirement
- Python
- python-dateutil

## example code
```
from datetime import datetime
from dateutil import tz

# METHOD Auto-detect zones:
#from_zone = tz.tzutc()
#to_zone = tz.tzlocal()

from_zone = raw_input("From Timezone: ")
to_zone = raw_input("To Timezone: ")
from_zone = tz.gettz(from_zone)
to_zone = tz.gettz(to_zone)

def datainput():
    # utc = datetime.utcnow()
    year = raw_input("Year (A.D.): ")
    month = raw_input("Month: ")
    day = raw_input("day: ")
    hour = raw_input("hour: ")
    minute = raw_input("minute: ")
    datetimestring = year + '-' + month + '-'  + day + ' '  + hour + ':'  + minute + ':00'
    return datetimestring

dtstr = datainput()

utc = datetime.strptime(dtstr, '%Y-%m-%d %H:%M:%S')

# Tell the datetime object that it's in UTC time zone since
# datetime objects are 'naive' by default
utc = utc.replace(tzinfo=from_zone)

# Convert time zone
central = utc.astimezone(to_zone)
print central.isoformat()

```