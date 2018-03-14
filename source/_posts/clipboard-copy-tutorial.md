---
title: 前端剪贴板复制功能实现原理
date: 2018-03-14 14:19:12
tags:
- copy
- clipboard
---

# 1. 兼容情况

如果想浏览器支持粘贴功能，那么浏览器必须支持，[document.execCommand('copy')](https://developer.mozilla.org/en-US/docs/Web/API/Document/execCommand)方法，也可以根据[document.queryCommandEnabled('copy')](https://developer.mozilla.org/en-US/docs/Web/API/Document/queryCommandSupported)，返回的true或者false判断浏览器是否支持copy命令。

从下表可以看出，主流的浏览器都支持execCommand命令

![](http://p3alsaatj.bkt.clouddn.com/20180314142213_IhrFsz_Jietu20180314-141253.jpeg)

# 2. 复制的原理

1. 查询元素
2. 选中元素
3. 执行复制命令

# 3. 代码展示

```
// html
<input id="username" value="123456">

// 查询元素
var username = document.getElementById(‘username’)

// 选中元素
username.select()

// 执行复制
document.execCommand('copy')
```

> 注意: 以上代码只是简单示意，在实践过程中还有几个要判断的情况

1. 首要要去检测浏览器execCommand能力检测
2. 选取元素时，有可能选取元素为空，要考虑这种情况的处理

# 4. 第三方方案

[clipboard.js](https://clipboardjs.com/)是一个比较方便的剪贴板库，功能蛮多的。


```
<!-- Target -->
<textarea id="bar">Mussum ipsum cacilds...</textarea>

<!-- Trigger -->
<button class="btn" data-clipboard-action="cut" data-clipboard-target="#bar">
    Cut to clipboard
</button>
```

官方给的代码里有上面的一个示例，如果你用了这个示例，但是不起作用，那你估计是没有初始化ClipboardJS示例的。

注意：下面的函数必须要主动调用，这样才能给响应的DOM元素注册事件。 ClipboardJS源代码压缩后大约有3kb，虽然很小了，但是如果你不需要它的这么多功能的话，其实你自己写几行代码就可以搞定复制功能。


```
new ClipboardJS('.btn');
```