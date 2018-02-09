---
title: 笔记 node最佳实践1 项目工程最佳实践
date: 2018-02-09 11:56:11
tags:
---

![](http://p3alsaatj.bkt.clouddn.com/20180209115715_YvgYOb_Screenshot.jpeg)

原文阅读: [nodebestpractices](https://github.com/i0natan/nodebestpractices)

# 工程结构最佳实践
## 组件化

![](http://p3alsaatj.bkt.clouddn.com/20180209115729_iJfUGU_Screenshot.jpeg)

`bad: 按照功能划分` 

- controllers
    - api.js
    - home.js
    - order.js
    - product.js
    - user.js
- models
    - order.js
    - product.js
    - user.js
- test
    - testOrder.js
    - testProduct.js
    - testUser.js

`good：按照组件划分`

- order
- product
- user
    - index.js
    - user.js
    - userApi.js
    - userError.js
    - userTesting.js
    - userAction.js

## 层次化
![](http://p3alsaatj.bkt.clouddn.com/20180209115743_ugkfVb_Screenshot.jpeg)

- 不要在express中写太多业务逻辑，express专注web层
- 业务层要单独抽出
- 数据库层单独抽出

## NPM化

![](http://p3alsaatj.bkt.clouddn.com/20180209115755_WLygCk_Screenshot.jpeg)

`把常用组件做成NPM包`

## 分离`Express`的 `app` 和 `server`
![](http://p3alsaatj.bkt.clouddn.com/20180209115806_dtcV4n_Screenshot.jpeg)

## 配置化

![](http://p3alsaatj.bkt.clouddn.com/20180209115815_7O9oS6_Screenshot.jpeg)
- `环境感知： 根据不同环境使用不同配置`
