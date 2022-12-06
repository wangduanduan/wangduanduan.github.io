---
title: "在二进制文件中注入版本信息"
date: 2022-05-28T21:47:41+08:00
---

暴露的变量必须用var定义，不能用const定义

```golang
// main.go

var VERSION = "unknow"
var SHA = "unknow"
var BUILD_TIME = "unknow"


...

func main () {
	 app := &cli.App{
		Version: VERSION + "\r\nsha: " + SHA + "\r\nbuild time: " + BUILD_TIME,
     ...
}
```

Makefile

```
tag?=v0.0.5
DATE?=$(shell date +%FT%T%z)
VERSION_HASH =  $(shell git rev-parse HEAD)
LDFLAGS='-X "main.VERSION=$(tag)" -X "main.SHA=$(VERSION_HASH)" -X "main.BUILD_TIME=$(DATE)"'

build:
   CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags $(LDFLAGS) -o wellcli main.go
```

执行make build, 产生的二进制文件，就含有注入的信息了。

```
-ldflags '[pattern=]arg list' 	arguments to pass on each go tool link invocation.
https://golang.google.cn/cmd/go/#hdr-Build_modes
```

- https://www.digitalocean.com/community/tutorials/using-ldflags-to-set-version-information-for-go-applications
