---
title: "exec user process caused no such file or diectory"
date: 2020-07-08
draft: false
---

```
exec user process caused "no such file or diectory"
```

解决方案：
将镜像构建的 Dockerfile ENTRYPOINT ["/run.sh"] 改为下面的

```
ENTRYPOINT ["sh","/run.sh"]
```

其实就是加了个sh



