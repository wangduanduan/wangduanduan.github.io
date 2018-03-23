---
title: 需求文档写作规范
date: 2018-03-22 14:31:49
tags:
---

# 1. 项目创建

一般情况，一个服务要有一个需求文档的git项目。即需要在[gitlab docs 组织下建立与之对应的项目仓库](http://192.168.60.11:30000/groups/docs)

![](http://p3alsaatj.bkt.clouddn.com/20180323090328_PZuu7W_Jietu20180323-090307.jpeg)

例如创建一个需求文档的项目。

![](http://p3alsaatj.bkt.clouddn.com/20180323092522_uW8yBy_Jietu20180323-092513.jpeg)


# 文件结构


# 2. 版本管理

`需求文档基于git分支进行版本管理。`

默认情况下，创建一个git项目都会有一个master分支。我们并不在master分支上写任何需求。

我们根据项目的版本来创建分支。例如我们先创建一个v1.0.0的分支，我们在该分支上写需求文档。当v1.0.0版本发布后，我们基于v1.0.1分支。 而且我们能够自由的切换分支。

![](http://p3alsaatj.bkt.clouddn.com/20180323092753_al0zTZ_Jietu20180323-092744.jpeg)

# 3. 需求状态

需求有以下几种状态，

- 开始(draft), 草稿阶段
- 需求稳定(stable), 需求标记为stable, 开发才着手开始开发
- 需求修改(modified), 需求处于修改状态，则开发暂停
- 开发(dev), 开始开发
- 测试(test), 开始测试
- 发布(released), 测试通过，开始发布

![](http://p3alsaatj.bkt.clouddn.com/20180323094409_akabhc_Jietu20180323-094357.jpeg)

# 4. 格式要求
