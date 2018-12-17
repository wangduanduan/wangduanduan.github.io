---
title: 深入理解 JavaScript中的变量、值、函数传参
date: 2018-12-17 15:24:15
tags:
---

# 1. demo

如果你对下面的代码没有任何疑问就能自信的回答出输出的内容，那么本篇文章就不值得你浪费时间了。

```js
var var1 = 1
var var2 = true
var var3 = [1,2,3]
var var4 = var3

function test (var1, var3) {
    var1 = 'changed'
    var3[0] = 'changed'
    var3 = 'changed'
}

test(var1, var3)

console.log(var1, var2, var3, var4)
```

# 2. 深入理解原始类型

原始类型有5个 `Undefinded, Null, Boolean, Number, String`

## 2.1. 原始类型变量没有属性和方法

```js
// 抬杠, 下面的length属性，toString方法怎么有属性和方法呢？
var a = 'oooo'
a.length
a.toString
```
原始类型中，有三个特殊的引用类型`Boolean`, `Number`, `String`，在操作原始类型时，原始类型变量会转换成对应的`基本包装类型`变量去操作。参考`JavaScript高级程序设计 5.6 基本包装类型。`

## 2.2. 原始类型值不可变

**原始类型的变量的值是不可变的，只能给变量赋予新的值。**

下面给出例子

```js
// str1 开始的值是aaa
var str1 = 'aaa'
// 首先创建一个能容纳6个字符串的新字符串
// 然后再这个字符串中填充 aaa和bbb
// 最后销毁字符串 aaa和bbb
// 而不能理解成在str1的值aaa后追加bbb
str1 = str1 + 'bbb'
```

**其他原始类型的值也是不可变的**, 例如数值类型的。


## 2.3. 原始类型值是字面量


# 3. 变量和值有什么区别？

- `不是每一个值都有地址，但每一个变量有。`《Go程序设计语言》 
- `变量没有类型，值有。变量可以用来保存任何类型的值。`《You-Dont-Know-JS》

变量都是有内存地址的，变量有用来保存各种类型的值；不同类型的值，占用的空间不同。

```js
var a = 1
typeof a // 检测的不是变量a的类型，而是a的值1的类型
```


# 4. 变量访问有哪些方式？

变量访问的方式有两种：

1. `按值访问`
2. `按引用访问`

在JS中，五种基本类型`Undefinded, Null, Boolean, Number, String`是按照值访问的。基本类型变量的值就是字面上表示的值。而引用类型的值是指向该对象的指针，而指针可以理解为内存地址。

可以理解基本类型的变量的值，就是字面上写的数值。而`引用类型的值则是一个内存地址`。但是这个内存地址，对于程序来说，是透明不可见的。无论是Get还是Set都无法操作这个内存地址。

下面是个示意表格。

语句 | 变量 | 值 | Get | 访问类型
---|---|---|---|---
`var a = 1` | a | `1` | 1 | 按值
`var a = []` | a | `0x00000320` | `[]` | 按引用

> **抬杠** `Undefinded, Null, Boolean, Number`是基本类型可以理解，因为这些类型的变量所占用的内存空间都是大小固定的。但是`string`类型的变量，字符串的长短都是不一样的，也就是说，字符串占用的内存空间大小是不固定的，为什么string被列为按值访问呢？

基本类型和引用类型的本质区别是，当这个变量被`分配`值时，它需要向操作系统申请内存资源，如果你向操作系统申请的内存空间的大小是固定的，那么就是基本类型，反之，则为引用类型。


# 5. 例子的解释

```js
var var1 = 1
var var2 = true
var var3 = [1,2,3]
var var4 = var3

function test (var1, var3) {
    var1 = 'changed' // a
    var3[0] = 'changed' // b
    var3 = 'changed' // c
}

test(var1, var3)

console.log(var1, var2, var3, var4)
```

![](http://assets.processon.com/chart_image/5c151883e4b0ed122da81fd1.png?1=1)

上面的js分为两个调用栈，在

- 图1 外层的调用栈。有四个变量v1、v2、v3、v4
- 图2 调用test是传参，内层的v1、v3会屏蔽外层的v1、v3。内层的v1,v3和外层的v1、v3内存地址是不同的。内层v1和外层v1已经没有任何关系了，但是内层的v3和外层v3仍然指向同一个数组。
- 图3 内层的v1的值被改变成'changed‘, v3[0]的值被改变为'changed'。
- 图4 内层v3的值被重写为字符串`changed`, 彻底断了与外层v3联系。
- 图5 当test执行完毕，内层的v1和v3将不会存在，ox75和ox76位置的内存空间也会被释放

最终的输出：

```
1 true ["changed", 2, 3] ["changed", 2, 3]
```


# 6. 如何深入学习JS、Node.js

看完两个stackoverflow上两个按照投票数量的榜单

- [JavaScript问题榜单](https://stackoverflow.com/questions/tagged/javascript?sort=votes)
- [Node.js问题榜单](https://stackoverflow.com/questions/tagged/node.js?sort=votes)

`如果学习有捷径的话，踩一遍别人踩过的坑，可能就是捷径。`

# 7. 参考

- [is-javascript-a-pass-by-reference-or-pass-by-value-language](https://stackoverflow.com/questions/518000/is-javascript-a-pass-by-reference-or-pass-by-value-language)
- [Is number in JavaScript immutable? duplicate](https://stackoverflow.com/questions/10648367/is-number-in-javascript-immutable)
- [Immutability in JavaScript](https://www.sitepoint.com/immutability-javascript/)
- [the-secret-life-of-javascript-primitives](https://javascriptweblog.wordpress.com/2010/09/27/the-secret-life-of-javascript-primitives/)
- [JavaScript data types and data structuresLanguages   Edit Advanced](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures)
- [Understanding Javascript immutable variable](https://stackoverflow.com/questions/16115512/understanding-javascript-immutable-variable)
- [Explaining Value vs. Reference in Javascript](https://codeburst.io/explaining-value-vs-reference-in-javascript-647a975e12a0)
- [You-Dont-Know-JS](https://github.com/getify/You-Dont-Know-JS/blob/master/types%20%26%20grammar/ch1.md#values-as-types)
- 《JavaScript高级程序设计（第3版）》[美] 尼古拉斯·泽卡斯 


  [1]: /img/bVblcyz