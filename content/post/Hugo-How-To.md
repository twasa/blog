---
title: "Hugo A Fast and Flexible Website Generator"
date: 2017-09-08T19:12:41+08:00
draft: true
---

## Quick Start Guide
- Hugo download
 - https://github.com/gohugoio/hugo/releases

- Install Hugo
 - https://gohugo.io/getting-started/installing/

- Create a blog folder

```
hugo new site blog
```

- go in to the folder and modify config.toml for your github url

```
baseURL = "http://<your-github-account>.github.io/"
```

- create new page

```
hugo new about.md
```

- create new post

```
hugo new post/first.md
```

- install a theme

```
cd themes
git clone https://github.com/xxx/xxx.git
```

- localhost server preview

```
hugo server --buildDrafts --watch

```

- references
 - https://gohugo.io/overview/introduction/
- themes
 - https://github.com/spf13/hugoThemes

- deploy to github
 - Create a blog git repository on GitHub
 - Create a <your-github-account>.github.io GitHub repository
 - run commands as below, in your blog folder

```
git init
git remote add origin git@github.com:<your-github-account>/blog.git
git rm -r public
git submodule add git@github.com:<your-github-account>/<your-github-account>.github.io.git public
git add .
git commit -m "Hugo content update"
git push -u origin master
hugo --buildDrafts
cd public
git add .
git commit -m "Blog update"
git push origin master
```

- In your blog folder, create a batch file for one click deploy.
 - windows : save below content as .cmd

```
set workdir=%~dp0
set current=%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2%
cd %workdir%
git add -A
git commit -m "Hugo content update %current%"
git push -u origin master
hugo --buildDrafts
cd public
git add -A
git commit -m "Blog update %current%"
git push origin master
```

 - linux : save below content as .sh

```
#!/bin/bash
workdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
git add -A
git commit -m "Hugo content update `date`"
hugo --buildDrafts
cd public
git add -A
current="Blog update `date`"
git commit -m "$current"
git push origin master
```