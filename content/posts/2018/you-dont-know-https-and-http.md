---
title: 可能被遗漏的https与http的知识点
date: 2018-02-08 09:10:59
tags:
- https
- http
---

# 1. HTTPS域向HTTP域发送请求会被浏览器直接拒绝，HTTP向HTTPS则不会

例如在github pages页面，这是一个https页面，如果在这个页面向http发送请求，那么会直接被浏览器拒绝，并在控制台输出下面的报错信息。

```
jquery-1.11.3.min.js:5 Mixed Content: The page at 'https://wangduanduan.github.io/ddddddd/' was loaded over HTTPS, but requested an insecure XMLHttpRequest endpoint 'http://cccccc/log/conf?token=welljoint'. This request has been blocked; the content must be served over HTTPS.
```
如果你在做第三方集成的系统，如果他们是在浏览器中直接调用你提供的接口，`那么最好你使用https协议，这样无论对方是https还是http都可以访问`。（相信我，这个很重要，我曾经经历过上线后遇到这个问题，然后连夜申请证书，把http升级到https的痛苦经历）

# 2. HTTPS的默认端口是443，而不是443
如果443端口已经被其他服务占用了，那么使用其他任何没有被占用的端口都可以用作HTTPS服务，只不过在请求的时候需要加上端口号罢了。

# 3. 如何快速隐藏一个DOM元素
选中一个元素，然后按`h`,这时候就会在选中的DOM元素上加上`__web-inspector-hide-shortcut__`类，这个类会让元素隐藏。谷歌和火狐上都可以，IE上没有试过行不行。

![](https://wdd.js.org/img/images/20180208091217_HDF1vL_Screenshot.jpeg)


  [1]: /img/bVUshW