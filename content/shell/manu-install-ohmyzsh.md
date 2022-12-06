---
title: "手工安装oh-my-zsh"
date: "2019-12-27 09:29:41"
draft: false
---

```bash
yum install zsh -y

# github上的项目下载太慢，所以我就把项目克隆到gitee上，这样克隆速度就非常快
git clone https://gitee.com/nuannuande/oh-my-zsh.git ~/.oh-my-zsh

# 这一步是可选的
cp ~/.zshrc ~/.zshrc.orig

# 这一步是必须的
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# 改变默认的sh, 如果这一步报错，就再次输入 zsh
chsh -s $(which zsh)
```


