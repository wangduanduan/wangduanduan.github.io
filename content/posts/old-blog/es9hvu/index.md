---
title: "nginx 配置不显示版本号"
date: "2020-05-14 09:44:46"
draft: false
---

# 隐藏版本号
nginx会在响应头上添加如下的头。
```bash
Server: nginx/1.17.9
```

如果不想在Server部分显示出nginx的版本号，需要在nginx.conf的http{}部分设置

```bash
http {
	server_tokens off;
}
```
然后重启nginx, nginx的响应头就会变成。
```bash
Server: nginx
```




