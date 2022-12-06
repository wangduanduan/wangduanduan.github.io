---
title: "Golang初学者的问题"
date: 2020-09-18T21:22:25+08:00
---

# 1. 如何安装go

本次安装环境是win10子系统 ubuntu 20.04

打开网站 https://golang.google.cn/dl/

选择合适的最新版的连接

```
cd
mkdir download
cd download
wget https://golang.google.cn/dl/go1.16.3.linux-amd64.tar.gz
tar -C /usr/local -xvf go1.16.3.linux-amd64.tar.gz

因为我用的是zsh
所以我在~/.zshrc中，将go的bin目录加入到PATH中
export PATH=$PATH:/usr/local/go/bin

保存.zshrc之后
source ~/.zshrc


➜  download go version
go version go1.16.3 linux/amd64
```

# 2. go proxy设置

Go 1.13 及以上（推荐）

打开你的终端并执行

```
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
```

# 3. go get 下载的文件在哪？
检查 go env 

```
GOPATH="/Users/wangdd/go”
/Users/wangdd/go/pkg/mod
total 0
drwxr-xr-x  4 wangdd  staff   128B Sep 14 09:17 cache
drwxr-xr-x  8 wangdd  staff   256B Sep 14 09:17 github.com
drwxr-xr-x  3 wangdd  staff    96B Sep 14 09:17 golang.org
```

路径在GOPATH/pkg/mod 目录下

# 4. cannot find module providing package github.com

在项目根目录执行

```
go mod init module_name
```

# 5. 选择什么Web框架 fiber

如果你要写一个web服务器，最快速的方式是挑选一个熟悉的框架。
如果你熟悉Node.js中的express框架，那你会非常快速的上手fiber，因为fiber就是参考express做的。

https://github.com/gofiber/fiber

# 6. 自动构建 air

npm中有个包，叫做nodemon，它会在代码变更之后，重启服务器。

如果你需要在golang中类似的功能，可以使用https://github.com/cosmtrek/air

# 7. 如何查看官方库文档

```
go doc fmt | less
```




