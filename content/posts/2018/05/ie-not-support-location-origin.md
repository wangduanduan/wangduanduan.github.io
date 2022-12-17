---
title: IE浏览器不支持location.origin
date: 2018-05-24 14:50:49
tags:
- ie
---

某些IE浏览器location.origin属性是undefined，所以如果你要使用该属性，那么要注意做个能力检测。

```
if (!window.location.origin) {
  window.location.origin = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ':' + window.location.port: '');
}i
```
