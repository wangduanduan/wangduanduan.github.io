---
title: mac vscode 更新失败 Permission denied解决办法
date: 2018-02-11 14:20:01
tags:
- mac
- vscode
---

# 0. 现象
`Could not create temporary directory: Permission denied`

# 1. 问题起因

在 `/Users/username/Library/Caches/`目录下，有以下两个文件， 可以看到，他们两个的用户是不一样的，一个是`root`一个`username`, 一般来说，我是以`username`来使用我的mac的。就是因为这两个文件的用户不一样，导致了更新失败。


```
drwxr-xr-x   6 username  staff   204B Jan 17 20:33 com.microsoft.VSCode
drwxr--r--   2 root    staff    68B Dec 17 13:51 com.microsoft.VSCode.ShipIt
```

# 2. 解决方法
`注意`： 先把vscode 完全关闭

```
// 1. 这一步是需要输入密码的
sudo chown $USER ~/Library/Caches/com.microsoft.VSCode.ShipIt/

// 2. 这一步是不需要输入密码的, 如果不进行第一步，第二步会报错
sudo chown $USER ~/Library/Caches/com.microsoft.VSCode.ShipIt/*

// 3. 更新xattr
xattr -dr com.apple.quarantine /Applications/Visual\ Studio\ Code.app
```

# 3. 打开vscode
Code > Check for Updates, 点击之后，你会发现`Check for Updates`已经变成灰色了，那么你需要稍等片刻，马上就可以更新，之后会跳出提示，让你重启vscode, 然后重启一下vscode, 就ok了。

# 4. 参考
- [joaomoreno commented on Feb 7, 2017 •  edited](https://github.com/Microsoft/vscode/issues/7426)

