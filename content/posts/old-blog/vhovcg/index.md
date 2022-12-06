---
title: "ssh 私钥使用失败"
date: "2019-08-17 18:53:37"
draft: false
---
报错信息如下

```bash
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions 0644 for 'mmmmm' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
```

解决方案：将你的私钥的权限改为600, 也就是说只有你自己可读可写，其他人都不能用

```bash
chmod 600 你的私钥
```


