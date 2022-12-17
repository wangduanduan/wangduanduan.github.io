---
title: "虚拟化浪潮"
date: "2019-10-10 21:27:47"
draft: false
---


# 刀耕火种：没有docker的时代

想想哪些没有docker时光, 我们是怎么玩linux的。

首先你要先装一个vmware或者virtualbox, 然后再下载一个几个GB的ISO文件，然后一步两步三步的经过十几个步骤，终于装好了一个虚拟机。这其中的步骤，每一步都可能有几个坑在等你踩。

六年前，也就是在2013的时候，docker出现了，这个新奇的东西，可以让你用一行命令运行一个各种linux的发行版。

```bash
docker run -it centos
docker run -it debian
```


# 黑色裂变：docker时代
docker 官网上，有个对docker非常准确的定位：
> Docker: The Modern Platform for High-Velocity Innovation

我觉得行英文很好理解，但是不好翻译，从中抽取三个一个最终要的关键词。"High-Velocty"，可以理解为加速，提速。

那么docker让devops提速了多少呢？

没有docker的时代，如果可以称为冷兵器时代的话，docker的出现，将devops带入了热兵器时代。

我们不用再准备石头，木棍，不需要打磨兵器，我们唯一要做的事情，瞄准目标，扣动扳机。


# 运筹帷幄：k8s时代
说实在的，我还没仔细去体味docker的时代时，就已经进入了k8s时代。k8s的出现，让我们可以不用管docker, 可以直接跳过docker, 直接学习k8s的概念与命令。

k8s的好处就不再多少了，只说说它的缺点。

- 资源消耗大：k8s单机版没什么意义，一般都是集群，你需要多台虚拟机
- 部署耗费精力：想要部署k8s，要部署几个配套的基础服务
- k8s对于tcp服务支持很好，对于udp服务，

所以如果我们仅仅是需要一个环境，跑跑自己的代码，相比于k8s，docker无疑是最方便且便宜的选择。

说实在的，我之前一直对docker没有全面的掌握，系统的学习，我将会在这个知识库里，系统的梳理docker相关的知识和实战经验。


# 帝国烽烟：云原生时代

- 微服务
- 应用编排调度
- 容器化
- 面向API


# 参考

- [https://en.wikipedia.org/wiki/Docker,_Inc.](https://en.wikipedia.org/wiki/Docker,_Inc.)
- [https://thenewstack.io/10-key-attributes-of-cloud-native-applications/](https://thenewstack.io/10-key-attributes-of-cloud-native-applications/)
- [https://jimmysong.io/kubernetes-handbook/cloud-native/cloud-native-definition.html](https://jimmysong.io/kubernetes-handbook/cloud-native/cloud-native-definition.html)
- [https://www.redhat.com/en/topics/cloud-native-apps](https://www.redhat.com/en/topics/cloud-native-apps)
- <br />


