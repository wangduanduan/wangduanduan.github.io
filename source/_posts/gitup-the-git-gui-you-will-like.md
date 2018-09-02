---
title: GitUp, 你不可错过的秀外慧中的git工具
date: 2018-04-24 18:03:44
tags:
---

大部分时间，我都是使用git命令行来完成各种git操作。

然而有时候，想可视化的查看各个分支之间的关系时，还是觉得有个GUI工具比较完美。

众里寻他千百度，默然回首，她在github上。

`GitUp, The Git interface you've been missing all your life has finally arrived` http://gitup.co/

![](https://wdd.js.org/img/images/20180424180658_8xeyJO_Screenshot.jpeg)


# 1. 功能介绍

## 1.1. 可视化、实时绘图、快速查看

![](..https://wdd.js.org/img/images/map.gif)

- `仓库可视化`: GitUp让你清晰明了的看到你的整个分支的迷宫
- `实时绘图`: 你做的任何改变，都会立刻反应到GitUp的图形上，不用刷新，不用等待
- `快速查看`: 高亮选中的commit，并且按空格键会查看到commit的详情

## 1.2. 远离脏乱、快速撤销、时光穿梭

![](..https://wdd.js.org/img/images/snapshots.gif)

- `远离脏乱`: GitUp给你完整的，透明的控制本地仓库的能力，非常方便去取消你不想要的改变
- `快速撤销`: 你只需要按 command + z就可以快速取消
- `快照穿梭`: GitUp的快照功能提供一种时光穿梭的功能，你可以访问任何时间点的文件


## 1.3. 全功能、快捷键、改变！

![](..https://wdd.js.org/img/images/editing.gif)

- `全功能`: Rewrite, split, delete, and re-order commits, fixup and squash, cherry-pick, merge, rebase全都有, 而且非常快
- `快捷键`: GitUp提供很多的快捷键
- `放弃原来的方法吧`: 你只需要专心写代码，剩下的事情都交给GitUp来处理吧

## 1.4. 速度非常快

![](https://wdd.js.org/img/images/20180424203917_Wl9aRw_Screenshot.jpeg)

- `速度非常快`: GitUp 加载和渲染超40000个commit的git仓库，只需要1秒之内。GitUp之所以这么快的原因是，GitUp绕过git的接口，直接与git本地数据库交互。所以，有些时候，GitUp要比git的原生命令要快的多。

## 1.5. 实时搜索

![](https://wdd.js.org/img/images/20180424204319_6aEPUe_Screenshot.jpeg)

- `实时搜索`: 你可以按照分支，tag, commmit消息，作者，甚至diff的内容进行搜索，GitUp会马上把结果提供给你。


## 1.6. 命令行工具

GitUp也提供命令行工具，可以在命令行中打开GitUp图形界面。

```
➜  gitup help
Usage: gitup [command]

Commands:

help
  Show this help.

open (default)
  Open the current Git repository in GitUp.

map
  Open the current Git repository in GitUp in Map view.

commit
  Open the current Git repository in GitUp in Commit view.

stash
  Open the current Git repository in GitUp in Stashes view.
```



# 2. 好消息与坏消息

- 好消息: GitUp免费开源
- 坏消息: GitUp仅支持macOS平台

# 3. 别被GitUp忽悠了

事实上，无论Git相关的gui工具牛吹得有多大，git的常用命令，也是非常建议你学会使用的。

作为一个程序员，一个讲究效率的程序员，命令行才是最好的工具。不要因为一点点难学，就放弃学习。

就像玛丽莲梦露所说的：`你无法接受我差的一面，就不配拥有我最好的一面`