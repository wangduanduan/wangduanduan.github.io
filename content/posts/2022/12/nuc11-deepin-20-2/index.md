---
title: "NUC11 安装 Deepin 20.2.4"
date: "2022-12-17 13:28:40"
draft: false
type: posts
tags:
- deepin
categories:
- deepin
---


# 硬件
内存：金士顿 16*2；869元
固态硬盘： 三星980 1TB; 799元
主机：NUC11 PAHI7; 4核心八线程；3399元
累计5000多一点, 是最新版Macbook pro M1prod的三分之一

# 启动盘制作
ventoy：试了几次，无法开机，遂放弃
rufus：能够正常使用；注意分区类型要选择GPT。最新款的一些电脑都是支持uefi的，所以选择GPT分区，一定没问题。

# U盘启动

开机后按F2, 里面有一个是设置BIOS优先级，可以设置优先U盘启动

# 磁盘分区

因为之前设置了默认的整个磁盘分区，根目录只有15G, 太小了，所以我选择手动分区
先设置一个efi分区，就用默认的300M就可以，默认弹窗出来，是不需要设置挂在目录的
设置根分区 /, 我分了300G
设置/home分区，剩下的磁盘都分给他
我没有设置swap分区，因为我觉得32G内存够大，不需要swap

# 其他
后续的配置非常简单，基本点点按钮就能搞定

# 体验
总体来说，安装软件是最舒服的一件事。不需要像安装manjaro那样，到处找安装常用应用的教程。只需要打开应用商店，点击下载就可以了。
整个安装过程，我觉得磁盘分区是最难的部分。其他都是非常方便的。
感觉深度的界面很漂亮，值得体验

# 问题

- NUC自带的麦克风无法外放声音，插有线耳机也不行，只有蓝牙耳机能用
