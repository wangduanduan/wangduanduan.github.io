---
title: "第一节 如何熟悉Kamailio文档的文档结构"
date: "2024-12-02 22:43:24"
draft: false
type: posts
tags:
- kamailio
categories:
- all
---

对于熟悉OpenSIPS的文档结构来说的人，看了Kamailio的文档，往往觉得无从下手。

当我们打开Km的官网(kamailio.org)后， 会重定向到https://www.kamailio.org/w/,  在页面的右侧，

![](atta/2024-12-02-22-57-06.png)

接着，我们会导航到 https://www.kamailio.org/w/documentation/

这个页面的结构需要烂熟于心

# 1. 模块文档

如果你知道km的版本号和对应的模块，可以点击这里进入对应版本，然后再选择对应模块

![](atta/2024-12-02-23-03-53.png)


# 2. wiki部分

## 2.1 必学部分
wiki部分主要是一些教程，非常值得看。

![](atta/2024-12-02-23-05-57.png)

其中有三个重点部分
1. **core cookbook**： 主要讲解km的脚本的结构、全局参数、模块参数、路由类型、预处理、脚本操作等等，是编写km脚本的必学之处，各种参数都可以看看
2. **Pseudo-Variables CookBook**：主要讲解各种伪变量，用来读写SIP消息
3. **Transformations CookBook**： 主要讲解各种操作变换，例如把字符串型转为int型数据

![](atta/2024-12-02-23-07-06.png)

## 全部函数索引

在km的wiki官网，即https://www.kamailio.org/wikidocs/， 其中Alphabetic Indexes就是所有的参数或者函数的索引。 

在你学些km的脚本时，有时候想知道某个函数在哪个模块中，就可以用这个全部函数索引中查找。

![](atta/2024-12-07-11-37-37.png)


## 源码安装

这部分讲解如何通过GIT进行源码安装。

![](atta/2024-12-02-23-12-53.png)

## FAQ
https://www.kamailio.org/wikidocs/tutorials/faq/main/

## 外部资源

这里涉及了如何用km和常见的媒体服务器如何集成

![](atta/2024-12-02-23-16-07.png)

![](atta/2024-12-02-23-31-00.png)

![](atta/2024-12-02-23-33-15.png)

# 总结

总体来说，km的文档算是非常完整了，但是和OpenSIPS相比，还有待加强。