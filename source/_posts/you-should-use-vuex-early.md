---
title: 你应该尽早使用Vuex
date: 2018-05-30 21:13:46
tags:
- Vue
---

之前做的一个项目，使用了Vuex。最近又做了一个项目，也打算用Vuex。只是某些Vuex的概念比较模糊了。所以打算写篇文章记录一下。

我记得以前看过一篇文章，核心思想就是`你应该尽早使用Vuex`，但是在网上也搜不到了。

无论谁来讲Vuex, 其实都没有官网讲的好，参见官网[Vuex 是什么？](https://vuex.vuejs.org/zh/), 如果你对Vuex有任何概念不清晰，官网都是最好的老师。

官网最后说：

> 如果您不打算开发大型单页应用，使用 Vuex 可能是繁琐冗余的。确实是如此——如果您的应用够简单，您最好不要使用 Vuex。一个简单的 global event bus 就足够您所需了。参考[Creating a Global Event Bus with Vue.js](https://alligator.io/vuejs/global-event-bus/)

但是，杀鸡用牛刀也未尝不可。

程序员往往喜欢：Talk is cheap, show me the code。废话少说，放码过来。我也是，有时候想弄清楚一个问题，往往喜欢去直接看代码。但是对整体的设计原理概念不甚了解。

但是，当我看到官网这张图，我盯着看了几分钟后，理解了这张图，也完全理解了Vuex。

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180530213345_GW7iQ8_Jietu20180530-213253.jpeg)

那么为什么要尽早使用Vuex呢？

1. Vuex其实很简单，没你想象的那么复杂
2. 越早Vuex使用越熟练，也能提高自己的知识储备
3. 你迟早需要状态管理的，与其将来痛苦重构，不如尽早享受Vuex带来的畅爽感觉

至于怎么使用Vuex，我就不多说了。网上优秀的教程蛮多的。