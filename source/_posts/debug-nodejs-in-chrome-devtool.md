---
title: 直接在Chrome DevTools调试Node.js
date: 2018-02-07 14:15:43
tags:
- nodejs
---

英文好的，直接看原文
> https://blog.hospodarets.com/nodejs-debugging-in-chrome-devtools

# 1. 要求
- Node.js 6.3+
- Chrome 55+

# 2. 操作步骤
- 1 打开连接 `chrome://flags/#enable-devtools-experiments`
- 2 开启`开发者工具实验性功能` 
- 3 重启浏览器
- 4 打开 DevTools Setting -> Experiments tab
- 5 按6次shift后，隐藏的功能会出现，勾选"Node debugging"

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180207141627_9HT0nS_Screenshot.jpeg)

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180207141636_hIfIyG_Screenshot.jpeg)

# 3. 运行程序
必须要有 `--inspect`
```
> node --inspect www
Debugger listening on port 9229.
Warning: This is an experimental feature and could change at any time.
To start debugging, open the following URL in Chrome:
    chrome-devtools://devtools/remote/serve_file/@60cd6e859b9f557d2312f5bf532f6aec5f284980/inspector.html?experiments=true&v8only=true&ws=localhost:9229/78a884f4-8c2e-459e-93f7-e1cbe87cf5cf
```

将这个地址粘贴到谷歌浏览器：`chrome-devtools://devtools/remote/serve_file/@60cd6e859b9f557d2312f5bf532f6aec5f284980/inspector.html?experiments=true&v8only=true&ws=localhost:9229/78a884f4-8c2e-459e-93f7-e1cbe87cf5cf`

程序后端输出的日志也回输出到谷歌浏览器的console里面，同时也可以在Sources里进行断点调试了。
![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180207141649_ArMyV7_Screenshot.jpeg)