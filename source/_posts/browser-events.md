---
title: 不常用却很有妙用的事件及方法
date: 2018-01-29 14:15:25
tags:
---

# [visibilitychange事件](https://developer.mozilla.org/zh-CN/docs/Web/Events/visibilitychange)

触发条件：`浏览器标签页被隐藏或显示的时候会触发visibilitychange事件.`

使用场景：`当标签页显示或者隐藏时，触发一些业务逻辑`

```
document.addEventListener("visibilitychange", function() {
  console.log( document.visibilityState );
});
```

# [storage事件](https://developer.mozilla.org/en-US/docs/Web/Events/storage)

触发条件：`使用localStorage or sessionStorage存储或者修改某个本地存储时`

使用场景：`标签页间通信`

```
// AB页面同源
// 在A 页面
window.addEventListener('storage', (e) => {console.log(e)})

// 在B 页面，向120打个电话
localStorage.setItem('makeCall','120')

// 然后可以在A页面间有输出, 可以看出A页面 收到了B页面的通知
...key: "makeCall", oldValue: "119", newValue: "120", ...
```

# [beforeunload事件](https://developer.mozilla.org/en-US/docs/Web/Events/beforeunload)

触发条件：`当页面的资源将要卸载(及刷新或者关闭标签页前). 当页面依然可见，并且该事件可以被取消只时`

使用场景：`关闭或者刷新页面时弹窗确认`，`关闭页面时向后端发送报告等`

```
window.addEventListener("beforeunload", function (e) {
  var confirmationMessage = "\o/";

  e.returnValue = confirmationMessage;     // Gecko, Trident, Chrome 34+
  return confirmationMessage;              // Gecko, WebKit, Chrome <34
});


```

# [navigator.sendBeacon](https://developer.mozilla.org/zh-CN/docs/Web/API/Navigator/sendBeacon)

这个方法主要用于满足 统计和诊断代码 的需要，这些代码通常尝试在卸载（unload）文档之前向web服务器发送数据。过早的发送数据可能导致错过收集数据的机会。然而， 对于开发者来说保证在文档卸载期间发送数据一直是一个困难。因为用户代理通常会忽略在卸载事件处理器中产生的异步 XMLHttpRequest 。

使用 sendBeacon() 方法，将会使用户代理在有机会时异步地向服务器发送数据，同时不会延迟页面的卸载或影响下一导航的载入性能。这就解决了提交分析数据时的所有的问题：使它可靠，异步并且不会影响下一页面的加载。此外，代码实际上还要比其他技术简单！

`注意：该方法在IE和safari没有实现`


使用场景：`发送崩溃报告`

```
window.addEventListener('unload', logData, false);

function logData() {
    navigator.sendBeacon("/log", analyticsData);
}
```