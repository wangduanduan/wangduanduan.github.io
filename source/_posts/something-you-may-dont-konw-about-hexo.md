---
title: 一些关于Hexo的疑问
date: 2018-02-08 21:29:18
tags:
- hexo
---

![](/images/20180208213207_ah8hTV_Jietu20180208-213152.jpeg)

<!-- more -->

# 1. 文件名重复了怎么办？

使用`hexo new filename`命令用来新建一个文章，但是如果你创建文章时，已经存在了同样的一个文件名，那么Hexo会怎样处理？

1. 报错
2. 覆盖之前的文章
3. 在文件名后面加个序号

实际上Hexo使用第三个方式来处理，例如

```
// 执行下面命令两次，会产生两个文件 filename.md, filename-1.md
hexo new filename
hexo new filename
```

所以，在创建文章时，你根本不需要考虑文章重名的事情，Hexo会自动帮你加上序号后处理。