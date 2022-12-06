---
title: "github clone加速"
date: "2022-03-29 09:17:23"
draft: false
---
我有一个github仓库，[https://github.com/wangduanduan/opensips](https://github.com/wangduanduan/opensips)， 这个源码比较大，git clone 比较慢。

我们使用[https://www.gitclone.com/](https://www.gitclone.com/)提供的加速服务。

```bash
# 从github上clone
git clone https://github.com/wangduanduan/opensips.git

# 从gitclone上clone
# 只需要在github前面加上gitclone.com/
# 速度就非常快，达到1mb/s
git clone https://gitclone.com/github.com/wangduanduan/opensips.git
```

但是这时候git repo的仓库地址是 [https://gitclone.com/github.com/wangduanduan/opensips.git](https://gitclone.com/github.com/wangduanduan/opensips.git)，并不是真正的仓库地址，而且我更喜欢用的是ssh方式的远程地址，所以我们就需要修改一下

```bash
git remote set-url origin git@github.com:wangduanduan/opensips.git
```

