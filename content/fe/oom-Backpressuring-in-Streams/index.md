---
title: "NodeJS Out of Memory: Backpressuring in Streams"
date: "2022-10-29 11:46:07"
draft: false
---

今天我收集了一份大概有40万行的日志，为了充分利用这份日志，我决定把日志给解析，解析完了之后，再写入mysql数据库。

首先，对于40万行的日志，肯定不能一次性读取到内存。

所以我用了NodeJs内置的readline模块。

```javascript
const readline = require('readline')
let line_no = 0

let rl = readline.createInterface({
    input: fs.createReadStream('./my.log')
})

rl.on('line', function(line) {
    line_no++;
    console.log(line)
})

// end
rl.on('close', function(line) {
    console.log('Total lines : ' + line_no);
})
```


数据解析以及写入到这块我没有贴代码。代码的执行是正常的，但是一段时间之后，程序就报错Out Of Memory。

代码执行是在nodejs 10.16.3上运行的，谷歌搜了一下解决方案，看到有人说nodejs升级到12.x版本就可以解决这个问题。我抱着试试看的想法，升级了nodejs到最新版，果然没有再出现OOM的问题。

后来我想，我终于深刻理解了NodeJS官网上的这篇文章 [Backpressuring in Streams](https://nodejs.org/en/docs/guides/backpressuring-in-streams/)，以前我也度过几遍，但是不太了解，这次接合实际情况。有了深刻理解。

NodeJS在按行读取本地文件时，大概可以达到每秒1000行的速度，然而数据写入到MySql，大概每秒100次插入的样子。

本身网络上存在的延迟就要比读取本地磁盘要慢，读到太多的数据无法处理，只能暂时积压到内存中，然而内存有限，最终OOM的异常就抛出了。

NodeJS 12.x应该解决了这个问题。

# 参考

- [https://nodejs.org/en/docs/guides/backpressuring-in-streams/](https://nodejs.org/en/docs/guides/backpressuring-in-streams/)
