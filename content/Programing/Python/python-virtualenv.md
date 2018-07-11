---
title: "Python Virtualenv"
date: 2017-09-10T17:00:56+08:00
tags: [ "Development", "Virtualenv" ]
categories: [ "Python" ]
draft: true
---

## Virtualenv的好處
- 可以隔離函數庫需求不同的專案，讓它們不會互相影響。在建立並啟動虛擬環境後，透過 pip 安裝的套件會被放在虛擬環境中，專案就可以擁有一個獨立的環境。
- 在沒有權限的情況下安裝新套件
- 不同專案可以使用不同版本的相同套件
- 套件版本升級時不會影響其他專案

## 安裝
```
pip install virtualenv
```

### 建立專案資料夾
```
mkdir myproject
cd myproject
```

### 初始化
```
virtualenv 虛擬環境名稱
```

### activate the corresponding environment
```
#linux
. 虛擬環境名稱/bin/activate
#windows
虛擬環境名稱\scripts\activate
```

### 這時候再裝要使用的Python Package
```
pip install XXXX
```

### 回到實際環境
```
deactivate
```

### 若因為專案資料夾搬移或更名,請重新locate
```
cd /path/to/your_project_new_dir
virtualenv --relocatable your_virtualenv_name
```