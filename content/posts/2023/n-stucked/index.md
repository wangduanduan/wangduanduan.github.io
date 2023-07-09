---
title: "安装NodeJS, N命令似乎卡住了"
date: "2023-07-09 14:20:45"
draft: false
type: posts
tags:
- node
categories:
- all
---

我一般会紧跟着NodeJS官网的最新版，来更新本地的NodeJS版本。

我的系统是ubuntu 20.4, 我用[tj/n](https://github.com/tj/n)这个工具来更新Node。 

但是这一次，这个命令似乎卡住了。

我排查后发现，是n这个命令在访问https://nodejs.org/dist/index.tab这个地址时，卡住了。

请求超时，因为默认没有设置超时时长，所以等待了很久才显示超时的报错，表现象上看起来就是卡住了。

首先我用dig命令查了nodejs.org的dns解析，我发现是正常解析的。

然后我又用curl对nodejs官网做了一个测试，发现也是请求超时。

```sh
curl -i -m 5 https://nodejs.org
curl: (28) Failed to connect to nodejs.org port 443 after 3854 ms: 连接超时
```

这样问题就清楚了，然后我就想起来npmirrror上应该有nodejs的镜像。 在查看n这个工具的文档时，我也发现，它是支持设置mirror的。

其中给的例子用的就是淘宝NPM

就是设置了一个环境变量。然后执行`source ~/.zshrc`

```
export N_NODE_MIRROR=https://npmmirror.com/mirrors/node
```

但是，我发现在命令行里用echo可以打印N_NODE_MIRROR这个变量的值，但是在安装脚本里，还是无法获取设置的这个mirror。

我想或许和我在执行`sudo n lts`时的sudo有关，这个.zshrc在sudo这种管理员模式下是不生效的。普通用户的环境变量也不会继承到sudo执行的环境变量里

最后，我用`sudo -E n lts`, 成功的从npmmirror上更新了nodejs的版本。

关于curl超时的这个问题，我也给n仓库提出了pull request, https://github.com/tj/n/pull/771


