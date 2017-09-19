---
title: "Git"
date: 2017-09-11T16:46:58+08:00
tags: [ "Development"]
categories: [ "Version Control" ]
draft: true
---

# Git的基本使用

## Config
- 在每一次的 Git commit (提交，我們稍後會提到) 都會記錄作者的訊息像是 name 及 email，因此我們使用下面的指令來設定：

```
git config --global user.name "你的姓名"
git config --global user.email "你的@email位址"
```

- 加上 --global 表示是全域的設定。你可以使用 git config --list 這個指令來看你的 Git 設定內容
- Git 也有提供 alias 的功能，例如你可以將 git status 縮寫為 git st，git checkout 縮寫為 git co 等，你只要這樣設定，這樣一來只要打 git st 就等同於打 git status
```
git config --global alias.st status
```

- 忽略空白
```
git config --global apply.whitespace nowarn
```

- Git 預設輸出是沒有顏色的，我們可以讓他在輸出時加上顏色讓我們更容易閱讀
```
git config --global color.ui true
```

- 不希望加入版本控制的追蹤設定: 建立```.gitignore```檔案，內容
```
*.swp
log/*.log
```


## github ssh-key config
- create a ssh key

```
ssh-keygen -t rsa -C "your_email@youremail.com"
```

- upload public key to github

```
    login to GitHub
    Account Settings -> SSH Public Keys -> Add another public key
    cat id_rsa_github.pub # past your public key content
```

- vi .ssh/config

```
Identityfile ~/.ssh/your-private-key
```


## 基本指令
- 建立一個新的 Repository

 ```
 git init
 ```

- Clone(複製)別人的 Repository：

 ```
 git clone https://xxx@github.com/xxx/xxx.git
 or
 git glone git://xxx@github.com/xxx/xxx.git
 ```

 - 檢查目前 Git 的狀態

 ```
 git status
```

 - 加檔案

 ```
 git add
```

 - 移檔案:

 ```
 git revert
```

 - 提交檔案:

 ```
 git commit
 or
 git commit -m "說明文字"
 ```

 - 加檔案並提交

 ```
 git commit -am "Add test.py to test git function"
```

 - 查看過去 commit 的紀錄

 ```
 git log
 or
 git log --stat
 or
 git log -p
```

 - 列出既有標籤:

 ```
 git tag -l
 ```

 - 新增標籤 -a 就是標籤名稱，-m 代表該標籤說明

 ```
 git tag -a v1.4 -m 'my version 1.4'
 ```

 - 上傳標籤到遠端, git push並不會把標籤上傳到遠端，所以必須透過底下才行 

```
git push origin v1.5
```

 - 如果在本機端很多標籤，利用 –tags 一次上傳上去

```
git push origin --tags
```
