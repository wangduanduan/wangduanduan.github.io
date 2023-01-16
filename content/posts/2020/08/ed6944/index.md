---
title: "vim ctags安装及使用"
date: "2020-08-10 09:29:24"
draft: false
---

# 安装
```bash
# ubuntu or debian
apt-get install ctags

# centos
yum install ctags # centos

# macOSX
brew install ctags



注意，如果在macOS 上输入ctags -R, 可能会有报错
/Library/Developer/CommandLineTools/usr/bin/ctags: illegal option -- R
usage: ctags [-BFadtuwvx] [-f tagsfile] file ...

那么你可以输入which ctags: 
/usr/bin/ctags # 如果输出是这个，那么路径就是错的。正确的目录应该是/usr/local/bin/ctags

那么你可以在你的.zshrc或者其他配置文件中，增加一个alias
alias ctags="/usr/local/bin/ctags"
```


# 使用
进入到项目跟目录
```bash
ctags -R # 当前目录及其子目录生成ctags文件
```


# 进入vim
```bash
vim main.c #
:set tags=$PWD/tags #让vim读区当前文件下的ctags文件
# 在多个文件的场景下，最好用绝对路径设置tags文件的位置 
# 否则有可能会报错neovim E433: No tags file
```



# 快捷键

- Ctrl+] 跳转到标签定义的地方
- Ctrl+o 跳到之前的地方
- ctrl+t 回到跳转之前的标签处
- :ptag some_key 打开新的面板预览some_key的定义
- * 下一个定义处
- # 上一个定义处
- gd 当前函数内查找当前标识符的定义处
- gD 当前文件查找标识符的第一次定义处

