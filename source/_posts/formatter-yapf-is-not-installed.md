---
title: VScode Formatter yapf is not installed解决方法
date: 2018-02-24 11:56:48
tags:
- python 
- yapf
- vscode 
- Formatter yapf is not installed
---

# 1. 判断你是否安装了yapf

```
yapf -v
```

如果你没有安装过，那么必须要安装。

# 2. 指定pathon路径

有些系统，像macOS，自带python2, 如果你又安装了python3, 并且你使用`pip3`来安装的yapf， 那么你就需要指定pythonPath

```
// user settings
"python.pythonPath": "python3",
```
