---
title: "Vscode Sync"
date: 2017-11-19T00:16:07+08:00
tags: [ "Development"]
categories: [ "Tools" ]
draft: true
---

# Visual Studio Code
## Visual Studio Code is a code editor redefined and optimized for building and debugging modern web and cloud applications.

## basic Configuration
```
    "editor.wordWrap": "off",
    "[markdown]": {
        "editor.wordWrap": "off",
        "editor.quickSuggestions": false
    },
    "markdown.extension.preview.autoShowPreviewToSide": true,
    "workbench.colorCustomizations": {
        "tab.activeBackground": "#0300aa"
    }
```

## Extensions
- Markdown All in One
- Settings Sync
- Copy Relative Path
- Path Intellisense
- Markdown table prettifier
- Microsoft Python extension

## Settings sync using github
- Settings > Developer settings > Personal access tokens > Generate new token
- Give your token a descriptive name like vscode, check gist and click Generate token.
- Copy and backup your token.
- Type upload in VSCode Command Palette.
- Enter your GitHub Personal Access Token.