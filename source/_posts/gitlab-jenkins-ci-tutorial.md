---
title: gitlab jenkins 集成教程
date: 2018-07-03 17:56:05
tags:
---

# 1. jenkins项目配置

## 1.1. 构建触发器设置

- 方框位置打钩
- 注意：椭圆圈住的位置的URL在下文中会用到

如果你的项目中看不到这一项，那么你需要安装[Gitlab Plugin](https://wiki.jenkins.io/display/JENKINS/GitLab+Plugin)

![](http://p3alsaatj.bkt.clouddn.com/20180703175934_fhIT2T_Jietu20180703-175910.jpeg)


## 1.2. 构建

注意：`$BUILD_NUMBER`是一个全局的宏，加上这个之后，每次构建产生的tag都不一样。

![](http://p3alsaatj.bkt.clouddn.com/20180703180154_3EBgJo_Jietu20180703-180138.jpeg)

构建生成的项目名称如下图所示。

![](http://p3alsaatj.bkt.clouddn.com/20180703180601_uyMlkh_Jietu20180703-180546.jpeg)

# 2. gitlab配置

## 2.1. 配置WebHooks

找到项目的 `projectX > Settings > Integrations`页面。

- 在椭圆中填入1.1章节中的URL
- 选中Push events
- 点击Add webhook

![](http://p3alsaatj.bkt.clouddn.com/20180703180947_EvLieQ_Jietu20180703-180934.jpeg)

添加成功后，会在Add webhook按钮下出现 Webhooks列表，你可以点击某一个webhook后的Test按钮进行测试。

如果测试成功，jenkins那边会新建构建任务。

如果测试失败，gitlab这边会给出具体的错误信息。

![](http://p3alsaatj.bkt.clouddn.com/20180703181150_q5E49m_Jietu20180703-181139.jpeg)