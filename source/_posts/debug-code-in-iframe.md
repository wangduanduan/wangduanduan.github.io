---
title: 如何浏览器里调试iframe里层的代码？
date: 2018-02-08 13:53:48
tags:
- debug
---

之前一直非常痛苦，在iframe外层根本获取不了里面的信息，后来使用了postMessage用传递消息来实现，但是用起来还是非常不方便。

其实浏览器本身是可以选择不同的iframe的执行环境的。例如有个变量是在iframe里面定义的，你只需要切换到这个iframe的执行环境，你就可以随意操作这个环境的任何变量了。

`这个小技巧，对于调试非常有用，但是我直到今天才发现。`

# Chrome

这个小箭头可以让你选择不同的iframe的执行环境，可以切换到你的iframe环境里。

![](http://p3alsaatj.bkt.clouddn.com/20180208135509_koFmKH_Screenshot.jpeg)


# IE 

如图所示是ie11的dev tool点击下来箭头，也可以选择不同的iframe执行环境。

![](http://p3alsaatj.bkt.clouddn.com/20180208135527_niIzO1_Screenshot.jpeg)

# 其他浏览器

其他浏览器可以自行摸索一下。。。（G_H）

  [1]: /img/bVN4Hs
  [2]: /img/bVN4Jb