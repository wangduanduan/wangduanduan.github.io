---
title: 发起Ajax请求当页面onunload
date: 2018-02-07 09:18:54
tags:
- ajax
- onunload
---

## 0.1. 同步Ajax
 
> 这种需求主要用于当浏览器关闭，或者刷新时，向后端发起Ajax请求。

```
window.onunload = function(){
    $.ajax({url:"http://localhost:8888/test.php?", async:false});
};
```
使用`async：false`参数使请求同步（默认是异步的）。

同步请求锁定浏览器，直到完成。 如果请求是异步的，页面只是继续卸载。 它足够快，以至于该请求甚至没有时间触发。服务端很可能收不到请求。

## 0.2. navigator.sendBeacon

`优点`：简洁、异步、非阻塞
`缺点`：这是实验性的技术，并非所有浏览器都支持。其中IE和safari不支持该技术。

示例：
```
window.addEventListener('unload', logData, false);

function logData() {
  navigator.sendBeacon("/log", analyticsData);
}
```

> 参考：http://stackoverflow.com/questions/1821625/ajax-request-with-jquery-on-page-unload
> 参考：https://developer.mozilla.org/en-US/docs/Web/API/Navigator/sendBeacon