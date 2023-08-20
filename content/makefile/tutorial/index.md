---
title: "Tutorial"
date: "2023-08-10 09:47:46"
draft: true
type: posts
tags:
- make
- makefile
categories:
- makefile
---

# 语法

```Makefile
targets: prerequisites
	command
	command
	command
```

- targets是文件名，可以用空格分开多个文件名，一般情况下，只有一个
- command是一系列的指令，可以多行分开
- prerequisites是依赖项目，可以用空格分开多个

# 参考
- https://makefiletutorial.com/#makefile-cookbook