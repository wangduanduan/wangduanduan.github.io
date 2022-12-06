---
title: "Shell 教程技巧"
date: 2022-05-28T12:39:50+08:00
draft: false
tags:
- shell
- git
---

# 复制文本到剪贴板

```
sudo apt install xclip
```

vim ~/.zshrc

```
alias copy='xclip -selection clipboard'
```

这样我们就可以用copy命令来考本文件内容到系统剪贴板了。

```
copy aaa.txt
```

# 判断工作区是否clean

```shell
if [ -z "$(git status --porcelain)" ]; then 
  # Working directory clean
else 
  # Uncommitted changes
fi
```
