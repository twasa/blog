---
title: "Python HTML Entity decode and encode"
date: 2017-09-10T16:14:36+08:00
tags: [ "Development" ]
categories: [ "Python" ]
draft: true
---
```
–– coding: utf-8 –
#decode
import HTMLParser
h = HTMLParser.HTMLParser()
print h.unescape('&#35377;&#21151;&#33995;')
許功蓋

#encode
a = u'許功蓋'
a.encode('ascii', 'xmlcharrefreplace')
'&#35377;&#21151;&#33995;'
```