---
title: shields小徽章是如何生成的？以及搭建自己的shield服务器
date: 2018-10-29 09:14:43
tags:
- shields
---


# shields小徽章介绍

一般开源项目都会有一些小徽章来标识项目的状态信息，并且这些信息是会自动更新的。在shields的官网https://shields.io/#/, 上面有各种各样的小图标，并且有很多自定义的方案。


# 起因：如何给私有部署的jenkins制作shields服务？

私有部署的jenkins是用来打包docker镜像的，而我想获取最新的项目打包的jenkins镜像信息。但是私有的jenkins项目信息，公网的shields服务是无法获取其信息的。那么如果搭建一个私有的shields服务呢？

# 第一步：如何根据一些信息，制作svg图标

查看shields图标的源码，可以看到这些图标都是svg格式的图标。然后的思路就是，`将文字信息转成svg图标`。最后我发现这个思路是个死胡同，

有个npm包叫做，[text-to-svg](https://github.com/shrhdk/text-to-svg), 似乎可以将文本转成svg, 但是看了文本转svg的效果，果断就放弃了。


最后回到起点，看了shields官方仓库，发现一个templates目录，豁然开朗。`原来svg图标是由svg的模板生成的`，每次生成图标只需要将信息添加到模板中，然后就可以渲染出svg字符串了。


顺着这个思路，发现一个包[shields-lightweight](https://github.com/albanm/shields-lightweight)

```
var shields = require('shields-lightweight');
var svgBadge = shields.svg('subject', 'status', 'red', 'flat');
```

这个包的确可以生成和shields一样的小徽章，但是如果徽章中有中文，那么中文就会溢出。`因为一个中文字符的宽度要比一个英文字符宽很多。` 

所以我就fork了这个项目，重写了图标宽度计算的方式。[shields-less](https://github.com/wangduanduan/shields-less)

```
npm install shields-less

var shieldsLess = require('shields-less')
var svgBadge = shieldsLess.svg({
    leftText: 'npm 黄河远上白云间',
    rightText: 'hello 世界'
})

var svgBadge2 = shieldsLess.svg({
    leftText: 'npm 黄河远上白云间',
    rightText: 'hello 世界',
    style: 'square'
})

var svgBadge2 = shieldsLess.svg({
    leftText: 'npm 黄河远上白云间',
    rightText: 'hello 世界',
    leftColor: '#e64a19',
    rightColor: '#448aff',
    style: 'square' // just two style: square and plat(default)
})
```

渲染后的效果，查看在线demo: https://wdd.js.org/shields-less/example/


# shields服务开发

shields服务其实很简单。架构如下，客户端浏览器发送一个请求，向shields服务，shield服务解析请求，并向jenkins服务发送请求，jenkins服务每个项目都有json的http接口，可以获取项目信息的。shields将从jenkins获取的信息封装到svg小图标中，然后将svg小图标发送到客户端。

# 最终效果