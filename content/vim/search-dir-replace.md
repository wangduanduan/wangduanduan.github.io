---
title: "搜索工作目录下的文件并替换"
date: 2022-05-28T10:35:58+08:00
draft: false
tags:
- vim
---

在vscode中，可以选中一个目录，然后在目录中搜索对应的关键词，再查找到对应文件中，然后做替换。

在vim也可以这样做。

但是这件事要分成两步。

1. 根据关键词，查找文件
2. 对多个文件进行替换

# 搜索关键词

搜索关键词可以用grep, 或者vim自带的vimgrep。

但是我更喜欢用ripgrep，因为速度很快。

ripgrep也有对应的vim插件 https://github.com/jremmen/vim-ripgrep

例如要搜索关键词 key1, 那么符合关键词的文件将会被放到quickfix列表中。

```
:Rg key1
```

可以用 `:copen` 来打开quickfix列表。

# 替换 cdo

```
:cdo %s/key1/key2/gc
```

c表示在替换的时候，需要手工确认每一项。

在替换的时候，可以输入

- y (yes)执行替换
- n (no)忽略此处替换
- a (all)替换此处和之后的所有项目
- q (quit) 退出替换过程
- l (last) 替换此处后退出
- ^E 向上滚动屏幕
- ^Y 向下滚动屏幕



