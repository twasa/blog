---
title: "Python Package"
date: 2017-09-11T13:21:51+08:00
tags: [ "Development", "Python" ]
draft: true
---

# description
- 套件 (package) 是 Python 用資料夾組織模組 (module) 檔案的方式

例如我們寫了三個模組
module01.py
module02.py
module03.py

三個模組檔案放在 package01資料夾中，package01就是套件名稱
這時package01資料夾需要有額外一個 __init__.py
__init__.py 可以不需要有任何內容
因為需要這個檔案，直譯器才能辨識package01為套件

另外寫一個 main.py 來利用 package01 中 module01.py 所定義的class(類別)或function(函數)
注意main.py 必須放在與 package 相同路徑下檔案結構如下
```
c:\packagedemo\package\module01.py
c:\packagedemo\package\module03.py
c:\packagedemo\package\module04.py
c:\packagedemo\main.py
```

在main.py引入套件的部份，XXX可以是module01裡面的class(類別)或function(函數)
from package.module01 import XXX

那麼 __init.py__ 除了讓直譯器識別資料夾為套件之外有什麼作用呢？這裡，我們可以在 __init.py__ 裡提供一個 all 變數，如下
all = ["module01", "module02", "module03"];

當 all 被定義後，寫
from package import *

才能保證 module01 、 module02 及 module03 三個模組都被引入。