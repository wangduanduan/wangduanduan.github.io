---
title: 终于找到你！如何将前端console.log的日志保存成文件?
date: 2018-02-08 13:56:40
tags:
- console
---

> 本篇文章来自一个需求，前端websocket会收到各种消息，但是调试的时候，我希望把websoekt推送过来的消息都保存到一个文件里，如果出问题的时候，我可以把这些消息的日志文件提交给后端开发区分析错误。但是在浏览器里，js一般是不能写文件的。鼠标另存为的方法也是不太好，因为会保存所有的console.log的输出。于是，终于找到这个debugout.js。

`debugout.js的原理是将所有日志序列化后，保存到一个变量里。当然这个变量不会无限大，因为默认的最大日志限制是2500行，这个是可配置的。另外，debugout.js也支持在localStorage里存储日志的。`

![](https://wdd.js.org/img/images/20180208135709_Z3SQQV_Screenshot.jpeg)


# 1. [debugout.js](https://github.com/inorganik/debugout.js)
> 一般来说，可以使用打开console面板，然后右键save，是可以将console.log输出的信息另存为log文件的。但是这就把所有的日志都包含进来了，如何只保存我想要的日志呢？

（调试输出）从您的日志中生成可以搜索，时间戳，下载等的文本文件。 参见下面的一些例子。

Debugout的log（）接受任何类型的对象，包括函数。 Debugout不是一个猴子补丁，而是一个单独的记录类，你使用而不是控制台。

调试的一些亮点：

- 在运行时或任何时间获取整个日志或尾部
- 搜索并切片日志
- 更好地了解可选时间戳的使用模式
- 在一个地方切换实时日志记录（console.log）
- 可选地将输出存储在window.localStorage中，并在每个会话中持续添加到同一个日志
- 可选地，将日志上限为X个最新行以限制内存消耗

下图是使用downloadLog方法下载的日志文件。

![](https://wdd.js.org/img/images/20180208135722_EwunDY_Screenshot.jpeg)

官方提供的demo示例，欢迎试玩。http://inorganik.github.io/debugout.js/

![](https://wdd.js.org/img/images/20180208135732_Ltowzp_Screenshot.jpeg)




# 2. 使用

在脚本顶部的全局命名空间中创建一个新的调试对象，并使用debugout的日志方法替换所有控制台日志方法：

```
var bugout = new debugout();

// instead of console.log('some object or string')
bugout.log('some object or string');
```

# 3. API

- log() -像console.log(), 但是会自动存储
- getLog() - 返回所有日志
- tail(numLines) - 返回尾部执行行日志，默认100行
- search(string) - 搜索日志
- getSlice(start, numLines) - 日志切割
- downloadLog() - 下载日志
- clear() - 清空日志
- determineType() - 一个更细粒度的typeof为您提供方便

# 4. 可选配置
···
// log in real time (forwards to console.log)
self.realTimeLoggingOn = true; 
// insert a timestamp in front of each log
self.useTimestamps = false; 
// store the output using window.localStorage() and continuously add to the same log each session
self.useLocalStorage = false; 
// set to false after you're done debugging to avoid the log eating up memory
self.recordLogs = true; 
// to avoid the log eating up potentially endless memory
self.autoTrim = true; 
// if autoTrim is true, this many most recent lines are saved
self.maxLines = 2500; 
// how many lines tail() will retrieve
self.tailNumLines = 100; 
// filename of log downloaded with downloadLog()
self.logFilename = 'log.txt';
// max recursion depth for logged objects
self.maxDepth = 25;
···

# 5. 项目地址
https://github.com/inorganik/debugout.js

# 6. 另外
我自己也模仿debugout.js写了一个日志保存的项目，该项目可以在ie10及以上下载日志。
debugout.js在ie浏览器上下载日志的方式是有问题的。
项目地址：https://github.com/wangduanduan/log4b.git

  [1]: /img/bVH5Z9
  [2]: /img/bVNIvY
  [3]: /img/bVNJMX