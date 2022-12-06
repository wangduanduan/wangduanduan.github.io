---
title: 'shell数学运算'
date: '2019-10-26 14:18:08'
draft: false
---

主要的数据运算方式

-   let
-   (())
-   []
-   expr
-   bc

# 使用 let

使用 let 时，等号右边的变量不需要在加上$符号

```
#!/bin/bash

no1=1;
no2=2;
# 注意两个变量的值的类型实际上是字符串
re1=$no1+$no2 # 注意此时re1的值是1+2
let result=no1+no2 # 此时才是想获取的两数字的和，3
```
