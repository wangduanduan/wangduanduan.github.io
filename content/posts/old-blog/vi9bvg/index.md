---
title: "使用brew作为deepin的包管理工具"
date: "2021-11-18 08:42:53"
draft: false
---
11月2号，我的主力开发工具macbook开始退役。

我换了nuc11 i7,  安装了国产的deepin(深度)操作系统。总体体验蛮好的，只是apt-get的软件包里，太多都是很老的包。所以我想到以前用mac的包管理工具homebrew, 据说它不仅仅可以在mac上工作，主流的linux也是能够使用的。

homebrew的介绍是：The Missing Package Manager for macOS (or Linux)。也就是说brew完全可以在linux上运行。

安装方式也很简单：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
上面的shell执行之后，brew就安装成功了。

和mac不同的是，linux homebrew的安装包的可执行命令的目录是：/home/linuxbrew/.linuxbrew/bin, 所以需要把它加入到PATH中，安装的软件才能正确执行。



# 参考

- [https://brew.sh/](https://brew.sh/)



