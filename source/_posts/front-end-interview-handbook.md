---
title: 前端面试和笔试题目
date: 2018-02-23 15:18:26
tags:
- 面试
- 笔试
---

# 1. 问答题
## 1.1. HTML相关
### 1.1.1. <!DOCTYPE html>的作用是什么？
### 1.1.2. script, script async和script defer之间有什么区别？
### 1.1.3. cookie, sessionStorage 和 localStorage之间有什么区别？
### 1.1.4. 用过哪些html模板渲染工具？

## 1.2. CSS相关
### 1.2.1. 简述CSS盒子模型
### 1.2.2. CSS有哪些选择器？
### 1.2.3. CSS sprite是什么？
### 1.2.4. 写一下你知道的前端UI框架？

## 1.3. JS相关
### 1.3.1. js有哪些数据类型？
### 1.3.2. js有哪些假值？
### 1.3.3. js数字和字符串之间有什么快速转换的写法？
### 1.3.4. 经常使用哪些ES6的语法？
### 1.3.5. 什么是同源策略？
### 1.3.6. 跨域有哪些解决方法？
### 1.3.7. 网页进度条实现的原理
### 1.3.8. 请问console.log是同步的，还是异步的？
### 1.3.9. 下面console输出的值是什么？
```
var scores = [10,11,12];
var total = 0;

for(var score in scores){
  total += score;
}

var average = total/scores.length;
console.log(average);
```

### 1.3.10. 请问下面的写法问题在哪？

```
console.log(1)

(function(){
    console.log(1)
})()
```

### 1.3.11. 请问s.length是多少，s[2]是多少
```
var s = []
s[3] = 4

s.length ?
s[2] ?
```

### 1.3.12. 说说你对setTimeout的`深入`理解？

```
setTimeout(function(){
  console.log('hi')
}, 1000)
```

### 1.3.13. 解释闭包概念及其作用
### 1.3.14. 如何理解js 函数`first class`的概念？
### 1.3.15. 函数有哪些调用方式？不同this的会指向哪里？
### 1.3.16. applly和call有什么区别？
### 1.3.17. 函数的length属性的代表什么？
### 1.3.18. 有用过哪些js编程风格
### 1.3.19. 如何理解EventLoop?
### 1.3.20. 使用过哪些构建工具？各有什么优缺点？

## 1.4. 其它
### 1.4.1. 平时使用什么搜索引擎查资料？
### 1.4.2. 对翻墙有什么看法？如何翻墙？
### 1.4.3. 个人有没有技术博客，地址是什么？
### 1.4.4. github上有没有项目？

## 1.5. 网络相关
### 1.5.1. 请求状态码 1xx,2xx,3xx,4xx,5xx分别有什么含义？
### 1.5.2. 发送某些post请求时，有时会多一些options请求，请问这是为什么？

### 1.5.3. http报文有哪些组成部分？

### 1.5.4. http端到端首部和逐跳首部有什么区别？

### 1.5.5. http与https在同时使用时，有什么注意点？

### 1.5.6. http, tcp, udp, websocket，分别位于7层网络的那一层？tcp和udp有什么不同？


# 2. 编码题

## 2.1. 写一个函数，返回一个数组中所有元素被第一个元素除后的结果

## 2.2. 写一个函数，来判断变量是否是数组，至少使用两种写法

## 2.3. 写一个函数，将秒转化成时分秒格式，如80转化成：00:01:20

## 写一个函数，将对象中属性值为'', undefined, null的属性删除掉

```
// 处理前
var obj = {
  name: 'wdd',
  address: {
    code: '',
    tt: null,
    age: 1
  },
  ss: [],
  vv: undefined
}

// 处理后
{
  name: 'wdd',
  address: {
    age: 1
  },
  ss: []
}
```

# 3. 翻译题

> Aggregation operations process data records and return computed results. Aggregation operations group values from multiple documents together, and can perform a variety of operations on the grouped data to return a single result. MongoDB provides three ways to perform aggregation: the aggregation pipeline, the map-reduce function, and single purpose aggregation methods.