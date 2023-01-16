---
title: Restful API 架构思考
date: 2018-06-07 22:35:08
tags:
- rest
- 未完成
---

<!-- TOC -->

- [1. 什么是REST?](#1-什么是rest)
- [2. REST API最为重要的约束](#2-rest-api最为重要的约束)
- [3. REST API HTTP方法 与 CURD](#3-rest-api-http方法-与-curd)
- [4. 状态码](#4-状态码)
- [5. RESTful架构设计](#5-restful架构设计)
- [6. 文档](#6-文档)
- [7. 版本](#7-版本)
- [8. 深入理解状态与无状态](#8-深入理解状态与无状态)
- [9. 参考](#9-参考)

<!-- /TOC -->


# 1. 什么是REST? 

> 表现层状态转换（REST，英文：Representational State Transfer）是Roy Thomas Fielding博士于2000年在他的博士论文[1] 中提出来的一种万维网软件架构风格，目的是便于不同软件/程序在网络（例如互联网）中互相传递信息。表现层状态转换（REST，英文：Representational State Transfer）是根基于超文本传输协议(HTTP)之上而确定的一组约束和属性，是一种设计提供万维网络服务的软件构建风格。匹配或兼容于这种架构风格(简称为 REST 或 RESTful)的网络服务，允许客户端发出以统一资源标识符访问和操作网络资源的请求，而与预先定义好的无状态操作集一致化。[wikipdeia](https://zh.wikipedia.org/wiki/%E8%A1%A8%E7%8E%B0%E5%B1%82%E7%8A%B6%E6%80%81%E8%BD%AC%E6%8D%A2)

![](https://wdd.js.org/img/images/20180607224524_M1yRtD_content_api_for_restful_web_services.jpeg)


`REST API 不是一个标准或者一个是协议，仅仅是一种风格，一种style。`


RESTful API的简单定义可以轻松解释这个概念。 REST是一种架构风格，RESTful是它的解释。也就是说，如果您的后端服务器具有REST API，并且您（从网站/应用程序）向客户端请求此API，则您的客户端为RESTful。


![](https://wdd.js.org/img/images/20180607225013_Kuay0l_content_rest_api_design.jpeg)


# 2. REST API最为重要的约束

-  `Client-Server` 通信只能由客户端单方面发起，表现为请求-响应的形式
- `Stateless` 通信的会话状态（Session State）应该全部由客户端负责维护
- `Cache` 响应内容可以在通信链的某处被缓存，以改善网络效率
- `Uniform Interface` 通信链的组件之间通过统一的接口相互通信，以提高交互的可见性
- `Layered System` 通过限制组件的行为（即每个组件只能“看到”与其交互的紧邻层），将架构分解为若干等级的层。
- `Code-On-Demand` 支持通过下载并执行一些代码（例如Java Applet、Flash或JavaScript），对客户端的功能进行扩展。


# 3. REST API HTTP方法 与 CURD

REST API 使用POST，GET, PUT, DELETE的HTTP方法来描述对资源的增、查、改、删。
这四个HTTP方法在数据层对应着SQL的插入、查询、更新、删除操作。

![](https://wdd.js.org/img/images/20180612085022_UHL82x_content_request_methods.jpeg)

# 4. 状态码

- `1xx` - informational;
- `2xx` - success;
- `3xx` - redirection;
- `4xx` - client error;
- `5xx` - server error.

# 5. RESTful架构设计

- `GET` /users - get all users;
- `GET` /users/123 - get a particular user with id = 123;
- `GET` /posts - get all posts.
- `POST` /users.
- `PUT` /users/123 - upgrade a user entity with id = 123.
- `DELETE` /users/123 - delete a user with id = 123.

# 6. 文档

![](https://wdd.js.org/img/images/20180612085417_wIj3AP_content_requests_for_the_user_in_swagger.jpeg)

![](https://wdd.js.org/img/images/20180612085434_VuMRnP_content_description_of_each_request_model_in_swagger.jpeg)

# 7. 版本

版本管理一般有两种

- 位于url中的版本标识： http://example.com/api/v1
- 位于请求头中的版本标识：Accept: application/vnd.redkavasyl+json; `version=2.0`
  

# 8. 深入理解状态与无状态

我认为REST架构最难理解的就是状态与无状态。下面我画出两个示意图。

图1是有状态的服务，状态存储于单个服务之中，一旦一个服务挂了，状态就没了，有状态服务很难扩展。无状态的服务，状态存储于客户端，一个请求可以被投递到任何服务端，即使一个服务挂了，也不回影响到同一个客户端发来的下一个请求。

![](https://wdd.js.org/img/images/20180612141107_qhgDxn_Jietu20180612-141048.jpeg)
【图1 有状态的架构】

![](https://wdd.js.org/img/images/20180612141200_2UmvfX_Jietu20180612-141058.jpeg)

【图2 无状态的架构】

>  each request from client to server must contain all of the information necessary to understand the request, and cannot take advantage of any stored context on the server. Session state is therefore kept entirely on the client. [rest_arch_style stateless](https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm#sec_5_1_3)

每一个请求自身必须携带所有的信息，让客户端理解这个请求。举个栗子，常见的翻页操作，应该客户端告诉服务端想要看第几页的数据，而不应该让服务端记住客户端看到了第几页。

# 9. 参考

- [A Beginner’s Tutorial for Understanding RESTful API](https://mlsdev.com/blog/81-a-beginner-s-tutorial-for-understanding-restful-api)
- [Versioning REST Services](http://www.informit.com/articles/article.aspx?p=1566460)