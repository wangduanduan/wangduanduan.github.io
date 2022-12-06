---
title: "核心变量说明"
date: "2021-03-23 14:47:07"
draft: false
---

# $ru $rU
可读可写<br />以下面的sip URL举例
```html
sip:8001@test.cc;a=1;b=2
```

- $ru 代表整个sip url就是 **sip:8001@test.cc;a=1;b=2**
- $rU代表用户部分，就是**8001**

**

# $du
可读可写
```html
$du = "sip:192.468.2.40";
```
$du可以理解为外呼代理，我们想让这个请求发到下一个sip服务器，就把$du设置为下一跳的地址。

