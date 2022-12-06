---
title: "前端必会的nginx知识点"
date: "2022-10-29 11:36:19"
draft: false
---

# 1. 启动？停止？reload配置

```bash
nginx -s reload  # 热重启
nginx -s reopen  # 重启Nginx
nginx -s stop    # 快速关闭
nginx -s quit    # 等待工作进程处理完成后关闭
nginx -T         # 查看配置文件的实际内容
```
# 2. nginx如何做反向http代理
```bash
location ^~ /api {
	proxy_pass http://192.168.40.174:32020;
}
```

# 3. nginx要如何配置才能处理跨域问题
```bash
location ^~ /p/asm {
  proxy_pass http://192.168.40.174:32020;
  add_header 'Access-Control-Allow-Origin' '*' always;
  add_header 'Access-Control-Allow-Credentials' 'true' always;
  add_header 'Access-Control-Allow-Methods' 'GET,POST,PUT,DELETE,PATCH,OPTIONS';
  add_header 'Access-Control-Allow-Headers' 'Content-Type,ssid';
  if ($request_method = 'OPTIONS') {return 204;}
  proxy_redirect     off;
  proxy_set_header   Host $host;
}
```

# 4. 如何拦截某个请求，直接返回某个状态码？
```bash
location ^~ /p/asm {
  return 204 "OK";
}
```
# 5. 如何给某个路径的请求设置独立的日志文件？
```bash
location ^~ /p/asm {
	access_log /var/log/nginx/a.log;
	error_log /var/log/nginx/a.err.log;
}
```
# 6. 如何设置nginx的静态文件服务器
```bash
location / {
	add_header Cache-Control max-age=360000;
	root /usr/share/nginx/html/webrtc-sdk/dist/;
}

# 如果目标地址中没有video, video只是用来识别路径的，则需要使用
# rewrite指令去去除video路径
# 否则访问/video 就会转到 /home/resources/video 路径
location /video {
  rewrite /video/(.*) /$1 break;
  add_header Cache-Control max-age=360000;
  autoindex on;
  root /home/resources/;
}
```
# 7. 反向代理时，如何做路径重写？
```bash
使用 rewrite 指令，例如
rewrite /p/(.*) /$1 break;
```
# 8. Nginx如何配置才能做websocket代理？
```bash
location ^~ /websocket {
  proxy_pass         http://192.168.40.174:31089;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection "Upgrade";
}
```

# 9. 如何调整nginx的最大打开文件限制
设置worker_rlimit_nofile
```bash
user root root;
worker_processes 4;
worker_rlimit_nofile 65535;
```
# 10. 如何判断worker_rlimit_nofile是否生效？

# 11. 直接返回文本
```
location / {
  default_type    text/plain;
  return 502 "服务正在升级，请稍后再试……";
}

location / {
  default_type    text/html;
  return 502 "服务正在升级，请稍后再试……";
}

location / {
  default_type    application/json;
  return 502 '{"status":502,"msg":"服务正在升级，请稍后再试……"}';
}
```

# 13. 多种日志格式
例如，不通的反向代理，使用不同的日志格式。

例如下面，定义了三种日志格式main, mian1, main2。

在access_log 指令的路径之后，指定日志格式就可以了。

```bash
http {
    log_format  main  '$time_iso8601 $remote_addr $status $request';
    log_format  main2  '$remote_addr $status $request';
    log_format  main3  '$status $request';

    access_log  /var/log/nginx/access.log  main;
```

# 14. 权限问题
例如某些端口无法监听，则需要检查是否被selinux给拦截了。
或者nginx的启动用户不是root用户导致无法访问某些root用户的目录。

# 参考

- [https://mp.weixin.qq.com/s/JUOyAe1oEs-WwmEmsHRn8w](https://mp.weixin.qq.com/s/JUOyAe1oEs-WwmEmsHRn8w)
- [https://www.nginx.com/blog/tcp-load-balancing-udp-load-balancing-nginx-tips-tricks/](https://www.nginx.com/blog/tcp-load-balancing-udp-load-balancing-nginx-tips-tricks/)
- [https://www.cnblogs.com/freeweb/p/5944894.html](https://www.cnblogs.com/freeweb/p/5944894.html)
