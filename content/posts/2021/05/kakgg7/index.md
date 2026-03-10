---
title: "openvpn 报错"
date: "2021-05-01 13:58:18"
draft: false
---
```
2021-01-19 12:01:58 OPTIONS ERROR: failed to negotiate cipher with server.  Add the server's cipher ('BF-CBC') to --data-ciphers (currently 'AES-256-GCM:AES-128-GCM') if you want to connect to this server.
2021-01-19 12:01:58 ERROR: Failed to apply push options
2021-01-19 12:01:58 Failed to open tun/tap interface
```
解决办法：<br />在配置文件中增加一行
```
ncp-ciphers "BF-CBC"
```

> PS： 今天是我的生日，QQ邮箱又是第一个发来祝福的 苦笑.jpg


