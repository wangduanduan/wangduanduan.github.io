---
title: "{} Object.create({}) Object.create{null}的区别？"
date: "2022-10-29 11:20:09"
draft: false
---

```js
let a = {}
let b = Object.create({})
let c = Object.create(null)

console.log(a,b,c)
```

上面三个对象的区别是什么？

![](2022-10-29-11-21-09.png)

![](2022-10-29-11-21-17.png)

![](2022-10-29-11-22-11.png)