---
title: "Royal TSX git status 输出乱码"
date: "2019-09-17 16:36:38"
draft: false
---

# 问题描述

连接服务器时的报警

```bash
-bash: 警告:setlocale: LC_CTYPE: 无法改变区域选项 (UTF-8): 没有那个文件或目录
```


git status 发现本来应该显示 'on brance master' 之类的地方，居然英文也乱码了，都是问号。



# 解决方案

vim /etc/environment , 然后加入如下代码，然后重新打开ssh窗口

```bash
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
```


