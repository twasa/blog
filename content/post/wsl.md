---
title: "WSL + zsh + oh-my-zsh + powerlevel9k + cmder"
date: 2018-07-08T23:00:24+08:00
draft: true
---

# Introduction install Windows Subsystem for Linux and Beautiful shell

## Required

- Windows 10 Anniversary Update build 14316 or later!
- Administrator permission
- cmder(Optional, for good color schema and powerline fonts support)

## Install Subsystem Linux using powershell

- Install Subsystem

```powershell
powershell -command Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

- Install Ubuntu from Microsoft Store

## install fontconfg on Ubuntu

```shell
apt-get install fontconfig
```

## install PowerlineSymbols

```shell
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p  ~/.local/share/fonts/
mkdir -p ~/.config/fontconfig/conf.d/
mv PowerlineSymbols.otf ~/.local/share/fonts/
fc-cache -vf ~/.local/share/fonts/
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
```

## Subsystem Linux install zsh, oh-my-zsh, theme and configurations

- install zsh

```shell
apt install zsh
```

- install oh-my-zsh

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

- install oh-my-zsh theme: Powerlevel9k

```shell
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
```

- oh-my-zsh configurations in ~/.zshrc

```txt
export ZSH="/home/william/.oh-my-zsh"

ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir dir_writable vcs vi_mode)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true


plugins=(
  git
)

source $ZSH/oh-my-zsh.sh
```

## cmder configurations

- Install font on windows

https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf

- config cmder
  - Main console font: DejaVuSansMono Nerd Font

  - Alternative font: DejaVuSansMono Nerd Font

  - Add a Tsks WSL in Startup > Tasks

  - WSL task parameters

  ```txt
  -icon "%USERPROFILE%\AppData\Local\lxss\bash.ico"
  ```

  - WSL task commands

  ```txt
  set "PATH=%ConEmuBaseDirShort%\wsl;%PATH%" &   %ConEmuBaseDirShort%\conemu-cyg-64.exe --wsl -cur_console:pm   -t zsh -l
  ```

  - Startup Specified named task: {WSL}

- close and re-open cmder

- Result

![Example image](/img/oh-my-zsh.png)