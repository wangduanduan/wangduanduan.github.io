---
title: "Nodejs Memory Model"
date: "2020-06-10 14:21:00"
draft: false
---

# v8内存模型
- Code Segment: 代码被实际执行
- Stack
   - 本地变量
   - 指向引用的变量
   - 流程控制，例如函数
- Heap V8负责管理
   - HeapTotal 堆的总大小
   - HeapUsed 实际使用的大小
- Shallow size of an object: 对象自身占用的内存
- Retained size of an object: 对象及其依赖对象删除后回释放的内存

![image.png](https://cdn.nlark.com/yuque/0/2020/png/280451/1591769729795-9338d955-8476-4b61-a4aa-b3087bb03c92.png#align=left&display=inline&height=346&margin=%5Bobject%20Object%5D&name=image.png&originHeight=692&originWidth=838&size=33744&status=done&style=none&width=419)