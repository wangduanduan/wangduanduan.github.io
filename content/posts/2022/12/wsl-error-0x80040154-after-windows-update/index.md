---
title: "Windows更新之后 Linux报错 Error 0x80040154"
date: "2022-12-11 14:12:08"
draft: false
type: posts
tags:
- wsl
- linux
- 0x80040154 
categories:
- wsl
---

最近我更新了Windows, 之后我的Windows Linux子系统Ubuntu打开就报错了

报错截图如下：

![](2022-12-11-14-15-00.png)

在网上搜了一边之后，很多教程都是说要打开Windows的子系统的功能。 但是由于我已经使用Linux子系统已经很长时间了，我觉得应该和这个设置无关。

而且我检查了一下，我的这个设置本来就是打开的。

![](2022-12-11-14-18-02.png)

然后我在Powershell里输入 wsl， 这个命令都直接报错了。


```
PS C:\WINDOWS\system32> wsl --install
没有注册类
Error code: Wsl/0x80040154
```

然后我到wsl的github上搜索类似的问题，查到有很多类似的描述，都是升级之后遇到的问题，我试了好几个方式，都没用。

但是最后这个有用了！

https://github.com/microsoft/WSL/issues/9064


![](2022-12-11-14-24-09.png)

解决的方案就是：

1. 卸载已经安装过的**Windows SubSystem For Linux Preview**
2. 然后再Windows应用商店重新安装这个应用

![](2022-12-11-14-27-43.png)

Windows的升级之后，可能Windows Linux子系统组建也更新了某些了内容。

所以需要重装。

这里不得不吐槽一下WSL, 这个工具仅仅是个玩具。随着windows更新，这个工具随时都会崩溃，最好不要太依赖它。
