---
title: "macbook pro 开机后wifi无响应问题调研"
date: "2019-08-15 08:48:22"
draft: false
---

# 解决方案

## 方案1：

```javascript
sudo kill -9 `ps aux | grep -v grep | grep /usr/libexec/airportd | awk '{print $2}'`
```

或者任务管理器搜索并且杀掉<br />airportd这个进程

# 参考

- [https://discussionschinese.apple.com/thread/140138832?answerId=140339277322#140339277322](https://discussionschinese.apple.com/thread/140138832?answerId=140339277322#140339277322)
- [https://www.v2ex.com/t/505737](https://www.v2ex.com/t/505737)
- [https://blog.csdn.net/Goals1989/article/details/88578012](https://blog.csdn.net/Goals1989/article/details/88578012)

