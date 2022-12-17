---
title: "我走过的nginx反向代理的坑"
date: "2020-02-13 21:21:13"
draft: false
---
下文的论述都以下面的配置为例子

```bash
location ^~ /p/security {
  rewrite /p/security/(.*) /security/$1  break;
  proxy_pass         http://security:8080;
  proxy_redirect     off;
  proxy_set_header   Host $host;
  add_header 'Access-Control-Allow-Origin' '*' always;
  add_header 'Access-Control-Allow-Credentials' 'true' always;
}
```

- **如果dns无法解析，nginx则无法启动**
   - security如果无法解析，那么nginx则无法启动
- **DNS缓存问题：**
   - nginx启动时，如果将security dns解析为1.2.3.4。如果security的ip地址变了。nginx不会自动解析新的ip地址，导致反向代理报错504。
   - 反向代理的DNS缓存问题务必重视
- **跨域头配置的always**
   - 反向代理一般都是希望允许跨域的。如果不加always，那么只会对成功的请求加跨域头，失败的请求则不会。

关于**'Access-Control-Allow-Origin' '*'，如果后端服务本身就带有这个头，那么如果你在nginx中再添加这个头，就会在浏览器中遇到下面的报错。而解决办法就是不要在nginx中设置这个头。**

```bash
Access to fetch at 'http://192.168.40.107:31088/p/security/v2/login' 
from origin 'http://localhost:5000' has been blocked by CORS policy:
Response to preflight request doesn't pass access control check: 
The 'Access-Control-Allow-Origin' header contains multiple values '*, *', 
but only one is allowed. Have the server send the header with a valid value, 
or, if an opaque response serves your needs, set the request's mode to 
'no-cors' to fetch the resource with CORS disabled.
```


# 参考链接

- [http://nginx.org/en/docs/http/ngx_http_headers_module.html](http://nginx.org/en/docs/http/ngx_http_headers_module.html)
- [http://www.hxs.biz/html/20180425122255.html](http://www.hxs.biz/html/20180425122255.html)
- [https://blog.csdn.net/xiojing825/article/details/83383524](https://blog.csdn.net/xiojing825/article/details/83383524)
- [https://cloud.tencent.com/developer/article/1470375](https://cloud.tencent.com/developer/article/1470375)
- [https://blog.csdn.net/bbg221/article/details/79886979](https://blog.csdn.net/bbg221/article/details/79886979)


