---
title: "js中二进制的操作"
date: "2022-10-29 11:41:13"
draft: false
---

js原生支持16进制、10进制、8进制的直接定义

```c
var a = 21 // 十进制
var b = 0xee // 十六进制, 238
var c = 013 // 八进制  11
```

# 十进制转二进制字符串
```c
var a = 21 // 十进制
a.toString(2) // "10101"
```

# 二进制转10进制
```c
var d = "10101"
parseInt('10101',2) // 21
```