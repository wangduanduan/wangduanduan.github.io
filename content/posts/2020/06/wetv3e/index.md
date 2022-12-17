---
title: "xcrun: error: invalid active developer path"
date: "2020-06-27 11:20:08"
draft: false
---
macos 升级后，发现git等命令都不可用了。

第一次使用xcode-select --install, 有报错。于是就用brew 安装了git。

```
xcode-select --install
```

后续使用其他命令是，发现gcc命令也不可用。于是第二天又用 `xcode-select --install` 执行了一遍，忽然又可以正常安装开发软件了。

所以又把brew 安装的git给卸载了。

