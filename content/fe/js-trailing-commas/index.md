---
title: "Js Trailing Commas"
date: "2021-07-10 14:03:00"
draft: false
---

# 简介

看下面的代码，如果我们要新增加一行"ccc", 实际我们的目的是增加一行，但是对于像git这种版本控制系统来说，我们改动了两行。

- 第三行进行了修改
- 第四行增加了

我们为什么要改动两行呢？因为如果不在第三行上的末尾加上逗号就增加第四行，则会报错语法错误。
```javascript
var names = [
	"aaa",
  "bbb"
]
```
```javascript
var names = [
	"aaa",
  "bbb",
  "ccc"
]
```
尾逗号的提案就是允许再一些场景下，允许再尾部增加逗号。

```javascript
var name = [
	"aaa",
  "bbb",
]
```
那么我们再新增加一行的情况下，则只需要增加一行，而不需要修改之前行的代码。

```javascript
var name = [
	"aaa",
  "bbb",
  "ccc",
]
```
# 兼容性

- 除了IE浏览器没有对尾逗号全面支持以外，其他浏览器以及Node环境都已经全满支持
- JSON是不支持尾逗号的，尾逗号只能在代码里面用

# 注意在包含尾逗号时数组长度的计算

```javascript
[,,,].length // 3
[,,,1].length // 4
[,,,1,].length // 4
[1,,,].lenght // 3
```

# 使用场景
## 数组中使用
```javascript
var abc = [
	1,
  2,
  3,
]
```
## 对象字面量中使用
```javascript
var info = {
	name: "li",
  age: 12,
}
```
# 作为形参使用

```javascript
function say (
	name,
   age,
) {
  
}
```
## 作为实参使用
```javascript
say(
	"li",
  12,
)
```

## 在import中使用
```javascript
  import {
    A,
    B,
    C,
  } from 'D'
```

# 参考

- [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Trailing_commas](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Trailing_commas)
