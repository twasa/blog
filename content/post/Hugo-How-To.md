---
title: "Hugo How To"
date: 2017-09-08T19:12:41+08:00
draft: true
---

## Hugo-Blog-How-To
- Create a blog folder

```
hugo new site blog
```

- go in to the folder and modify config.toml for your github url

```
vi config.toml
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
 - Create a <username>.github.io GitHub repository
 - run commands as below

```
git init
git remote add origin git@github.com:<username>/blog.git
git rm -r public
git submodule add git@github.com:<username>/<username>.github.io.git public
git add .
git commit "first commit"
git push -u origin master
hugo --buildDrafts
cd public
git add .
git commit -m "Generate site"
git push origin master
```