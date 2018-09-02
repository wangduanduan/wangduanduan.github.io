---
title: 搭建一个舒心高效的windows + shell 工作环境
date: 2018-02-11 14:16:54
tags:
- windows
- shell
---

## 1 ConEmu命令行： 漂亮的不像实力派
我曾这篇文章中[《自从装了windows神器，再也不用羡慕mac了》](https://wdd.js.org/windows-powerful-tools.html)，介绍过好几个命令行神器。

里面几个命令行我都有用过，但是最让我喜欢的是[ConEmu](https://github.com/Maximus5/ConEmu)，先说说它的特点。

- 平滑的窗口大小调整
- 标签和分裂（窗格）
- 窗口字体消除锯齿：标准，清除类型，禁用
- 快速的复制粘贴
- 可切换使用shell或者dos, 过着git bash等

`你可以看看它完美的侧颜。`

![](https://github.com/Maximus5/ConEmu/wiki/ConEmuSplits.png)


## 2 gow shell工具箱: 身材苗条却又肌肉发达
我曾经想过，如果能在直接windows上用linux的`grep`,  `curl`等命令，那该多好啊！
我也曾试过[Cygwin](https://zh.wikipedia.org/zh-cn/Cygwin), 但是那`哥斯拉`般大小的体积让我只能望洋兴叹。

曾几何时，我遇到了Gow，她10MB版苗条的身材，却又能满足你80%的日常工作的需要。

当别人还有notepad++，慢慢吞吞加载一个30MB的日志的时候，你用`grep`命令，已经搜索到了想要的结果。所谓：`天下武功，无坚不摧，唯快不破`， 就是这个感觉。

[Gow（Gnu On Windows）](https://github.com/bmatzelle/gow)是Cygwin的轻量级替代品。 它使用了一个方便的Windows安装程序，安装了大约130个非常有用的开源UNIX应用程序，编译为本机win32二进制文件。 它被设计成尽可能小，大约10 MB，而Cygwin可以运行在100 MB以上，具体取决于选项。

这里有一些来自Gow用户的引用：

> “Gow是使Windows可以使用/可用的少数几件事之一”

> “我不断地使用Gow，太棒了。”

> “我只是想让你知道，GOW Suite非常棒 - 它比Cygwin工具轻得多，而且非常有用。

## 3 f.lux：我轻轻看一眼，这暖暖的感觉，她都有

作为一个程序员，免不了长时间的面对电脑屏幕。结果经常会眼睛难受。然后我尝试了一下[f.lux](https://justgetflux.com/),  装上之后，配置了一下时区， 电脑屏幕马上变成屎黄色。抱着试试看的心态，我用了几天，几天过后，我实在受不了这颜色了。 然后就卸载了，没过多上时间，我觉得有点不对劲，不舒服。总是感觉缺点什么。 

就放佛 张韶涵的歌《遗失的美好》：`有些人说不清哪里好 但就是谁都替代不了`,  然后我就又装上了f.lux。在我的影响下，我附近的几个小伙伴，也都装上了`f.lux`。 后来我换了mac, 但是我也装了f.lux。

![](https://justgetflux.comhttps://wdd.js.org/img/images/flux-windows.jpg)

> f.lux让你的电脑屏幕看起来就像你所在的房间一样。 当日落时，它使您的电脑看起来像你的室内灯。 在早上，它使事情看起来像阳光。

> 告诉f.lux你有什么样的照明，以及你住的地方。 然后忘了它。 f.lux会自动完成剩下的工作。

## 4 visual studio code: 最好用的轻量编辑器
- 颜值很高
- 微软开源的产品，质量保证
- 集成git
- 插件很多，下载很快
- 免费
- 体积很小，占用内存很小，启动很快

![](https://wdd.js.org/img/images/20180201172157_gz0qsT_Jietu20180201-172150.jpeg)

