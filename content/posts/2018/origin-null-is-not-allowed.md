---
title: Chrome本地跨域origin-null-is-not-allowed问题分析与解决方案
date: 2018-03-09 17:58:05
tags: 
- chrome
- 跨域
- origin-null-is-not-allowed
---

# 1. 问题表现
以`file:///xxx.html`打开某个html文件，发送ajax请求时报错：

```
Response to preflight request doesn't pass access control check: The 'Access-Control-Allow-Origin' header has a value 'null' that is not equal to the supplied origin. Origin 'null' is therefore not allowed access.
```

# 2. 问题原因

Origin null是本地文件系统，因此这表明您正在加载通过file：// URL进行加载调用的HTML页面（例如，只需在本地文件浏览器或类似文件中双击它）。不同的浏览器采用不同的方法将相同来源策略应用到本地文件。`Chrome要求比较严格，不允许这种形势的跨域请求。`而最好使用http:// 访问html.

# 3. 解决方案

以下给出三个解决方案，第一个最快，第三个作为彻底。


## 3.1. 方案1 给Chrome快捷方式中增加 --allow-file-access-from-files
打开Chrome快捷方式的属性中设置：右击Chrome浏览器快捷方式，选择“属性”，在“目标”中加"--allow-file-access-from-files"，注意前面有个空格，重启Chrome浏览器便可。

![](https://wdd.js.org/img/images/20180309181105_SUxYRg_Screenshot.jpeg)


## 3.2. 方案2 启动一个简单的静态文件服务器, 以http协议访问html

参见我的这篇文章: [一行命令搭建简易静态文件http服务器](https://wdd.js.org/one-command-create-static-file-server.html)

## 3.3. 方案3 服务端响应修改Access-Control-Allow-Origin : *

```
response.addHeader("Access-Control-Allow-Origin","*")
```


# 4. 参考文章
- [如何解决XMLHttpRequest cannot load file~~~~~~~Origin 'null' is therefore not allowed access](http://blog.csdn.net/dandanzmc/article/details/31344267)
- [让chrome支持本地Ajax请求,Ajax请求status cancel Origin null is not allowed by Access-Control-Allow-Origin](http://blog.csdn.net/kissliux/article/details/16889111)
- [Origin null is not allowed by Access-Control-Allow-Origin
](https://stackoverflow.com/questions/8456538/origin-null-is-not-allowed-by-access-control-allow-origin)