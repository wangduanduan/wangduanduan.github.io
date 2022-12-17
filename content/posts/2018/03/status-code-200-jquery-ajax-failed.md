---
title: 状态码为200时 jQuery ajax报错
date: 2018-03-15 14:17:59
tags:
- ajax
---

# 1. 问题现象

HTTP 状态码为 200 OK 时， jquery ajax报错

# 2. 问题原因

jquery ajax的dataType字段包含：json, 但是服务端返回的数据不是规范的json格式，导致jquery解析json字符串报错，最终导致ajax报错。

jQuery ajax 官方文档上说明：

> "json": Evaluates the response as JSON and returns a JavaScript object. Cross-domain "json" requests are converted to "jsonp" unless the request includes jsonp: false in its request options. The JSON data is parsed in a strict manner; any malformed JSON is rejected and a parse error is thrown. As of jQuery 1.9, an empty response is also rejected; the server should return a response of null or {} instead. (See json.org for more information on proper JSON formatting.)

设置dataType为json时，jquery就会去解析响应体为JavaScript对象。跨域的json请求会被转化成jsonp, 除非设置了`jsonp: false`。JSON数据会以严格模式去解析，任何不规范的JSON字符串都会解析异常并抛出错误。从jQuery 1.9起，一个空的响应也会被抛出异常。服务端应该返回一个`null`或者`{}`去代替空响应。参考[json.org](http://json.org/), 查看更多内容

# 3. 解决方案

这个问题的原因是后端返回的数据格式不规范，所以后端在返回结果是，不要使用空的响应，也不应该去手动拼接JSON字符串，而应该交给响应的库来实现JSON序列化字符串工作。

- 方案1： 如果后端确定响应体中不返回数据，那么就`把状态码设置为204`，而不是200。我一直逼着后端同事这么做。
- 方案2：如果后端接口想返回200，那么请返回一个`null`或者`{}`去代替空响应
- 方案3：别用jQuery的ajax，换个其他的库试试

# 4. 参考
- [Ajax request returns 200 OK, but an error event is fired instead of success](https://stackoverflow.com/questions/6186770/ajax-request-returns-200-ok-but-an-error-event-is-fired-instead-of-success)
- [jQuery.ajax](http://api.jquery.com/jQuery.ajax/)