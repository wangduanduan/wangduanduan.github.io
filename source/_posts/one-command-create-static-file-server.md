---
title: 一行命令搭建简易静态文件http服务器
date: 2018-02-09 13:01:14
tags:
- 静态文件服务器
---

简易服务器：在命令执行的所在路径启动一个http服务器，然后你可以通过浏览器访问该路径下的所有文件。

在局域网内传文件，或者自己测试使用都是非常方便的。

# 1. 基于python
![](/images/20180209130207_yzmvQO_Screenshot.jpeg)

## 1.1. 基于Python2
`python -m SimpleHTTPServer port`

```
> python -m SimpleHTTPServer 8099
Serving HTTP on 0.0.0.0 port 8099 ...
127.0.0.1 - - [24/Oct/2017 11:07:56] "GET / HTTP/1.1" 200 -
```

## 1.2. 基于python3
`python3 -m http.server port`

```
> python3 -m http.server 8099
Serving HTTP on 0.0.0.0 port 8099 (http://0.0.0.0:8099/) ...
127.0.0.1 - - [24/Oct/2017 11:05:06] "GET / HTTP/1.1" 200 -
127.0.0.1 - - [24/Oct/2017 11:05:06] code 404, message File not found
127.0.0.1 - - [24/Oct/2017 11:05:06] "GET /favicon.ico HTTP/1.1" 404 -
```

# 2. 基于nodejs
首先你要安装nodejs
![](/images/20180209130231_76jUWj_Screenshot.jpeg)


## 2.1. [http-server](https://github.com/indexzero/http-server)
```
// 安装
npm install http-server -g

// 用法
http-server [path] [options]
```

## 2.2. [serve](https://github.com/zeit/serve)
```
// 安装
npm install -g serve

// 用法
serve [options] <path>
```

## 2.3. [webpack-dev-server](https://github.com/webpack/webpack-dev-server)
```
// 安装
npm install webpack-dev-server -g

// 用法
webpack-dev-server
```

## 2.4. [anywhere](https://github.com/JacksonTian/anywhere)
```
// 安装
npm install -g anywhere

// 用法
anywhere
anywhere -p port
```

## 2.5. [puer](https://github.com/leeluolee/puer)

![](/images/20180209130246_GqSjH6_Screenshot.jpeg)

```
// 安装
npm -g install puer

// 使用
puer

- 提供一个当前或指定路径的静态服务器
- 所有浏览器的实时刷新：编辑css实时更新(update)页面样式，其它文件则重载(reload)页面
- 提供简单熟悉的mock请求的配置功能，并且配置也是自动更新。
- 可用作代理服务器，调试开发既有服务器的页面，可与mock功能配合使用
- 集成了weinre，并提供二维码地址，方便移动端的调试
- 可以作为connect中间件使用(前提是后端为nodejs，否则请使用代理模式)
```


  [1]: /img/bVXkqP