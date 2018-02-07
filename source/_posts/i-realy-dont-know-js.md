---
title: 突然觉得自己好像没学过JS
date: 2018-02-07 10:09:42
tags:
- js
---

## 先看题：mean的值是什么？
```
var scores = [10,11,12];
var total = 0;

for(var score in scores){
  total += score;
}

var mean = total/scores.length;
console.log(mean);
```

## 是11？
恭喜你：答错了！

## 是1？
恭喜你：答错了！

## 正确答案： 4
解释： `for in 循环循环的值永远是key, key是一个字符串`。所以total的值是：'0012'。它是一个字符串，字符串'0012'/3,0012会被转换成12，然后除以3，结果是4。

## 后记

这个示例是来自《编写高质量JavaScript的68个方法》的第49条：`数组迭代要优先使用for循环而不是for in循环`。
既然已经发布，就可能有好事者拿出去当面试题。这个题目很有可能坑一堆人。其中包括我。

这里涉及到许多js的基础知识.

1. `for in 循环是循环对象的索引属性，key是一个字符串。`
2. `数值类型和字符串相加，会自动转换为字符串`
3. `字符串除以数值类型，会先把字符串转为数值，最终结果为数值`

正确方法
```
var scores = [10,11,12];
var total = 0;

for(var i=0, n=scores.length; i < n; i++){
  total += scores[i];
}

var mean = total/scores.length;
console.log(mean);
```
这样写有几个好处。
- 循环的终止条件简单且明确
- 即使在循环体内修改了数组，也能有效的终止循环。否则就可能变成死循环。
- 编译器很难保证重启计算scores.length是安全的。
- 提前确定了循环终止条件，避免多次计算数组长度。这个可能会被一些浏览器优化。
