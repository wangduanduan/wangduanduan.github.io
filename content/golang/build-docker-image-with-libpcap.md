---
title: "Build Docker Image With Libpcap"
date: "2023-05-08 11:45:23"
draft: false
type: posts
tags:
- all
- libpcap
categories:
- all
---

# 常规构建

一般情况下，我们的Dockerfile可能是下面这样的

- 这个Dockerfile使用了多步构建，使用golang:1.19.4作为构建容器，二进制文件构建成功后，单独把文件复制到alpine镜像。
- 这样做的好处是最后产出的镜像非常小，一般只有十几MB的样子，如果直接使用golang的镜像来构建，镜像体积就可能达到1G左右。

```Dockerfile
FROM golang:1.19.4 as builder

ENV GO111MODULE=on GOPROXY=https://goproxy.cn,direct

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o run .

FROM alpine:3.14.2

WORKDIR /app
COPY encdec run.sh /app/

COPY --from=builder /app/run .

EXPOSE 3000

ENTRYPOINT ["/app/run"]
```


# 依赖libpcap的构建

如果使用了程序使用了[libpcap](https://pkg.go.dev/github.com/google/gopacket/pcap) 来抓包，那么除了我们自己代码产生的二进制文件外，可能还会依赖libpcap的文件。常规打包就会报各种错误，例如文件找不到，缺少so文件等等。

libpcap是一个c库，并不是golang的代码，所以处理起来要不一样。

下面直接给出Dockerfile

```Dockerfile
# 构建的基础镜像换成了alpine镜像
FROM golang:alpine as builder

# 将alpine镜像换清华源，这样后续依赖的安装会加快
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
# 安装需要用到的C库，和构建依赖
RUN apk --update add linux-headers musl-dev gcc libpcap-dev
# 使用国内的goproxy
ENV GO111MODULE=on GOPROXY=https://goproxy.cn,direct

# 设置工作目录
WORKDIR /app

# 拷贝go相关的依赖
COPY go.mod go.sum ./
# 下载go相关的依赖
RUN go mod download
# 复制go代码
COPY . .
# 编译go代码
RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -a --ldflags '-linkmode external -extldflags "-static -s -w"' -o run main.go

# 使用最小的scratch镜像
FROM scratch
# 设置工作目录
WORKDIR /app
# 拷贝二进制文件
COPY --from=builder /app/run .

EXPOSE 8086

ENTRYPOINT ["/app/run"]
```


整个Dockerfile比较好理解，重要的部分就是ldflags的参数了，下面着重讲解一下

```
--ldflags '-linkmode external -extldflags "-static -s -w"'
```

这个 `go build` 命令包含以下参数：

- `-a`：强制重新编译所有的包，即使它们已经是最新的。这个选项通常用于强制更新依赖包或者重建整个程序。
- `--ldflags`：设置链接器选项，这个选项后面的参数会被传递给链接器。
- `-linkmode external`：指定链接模式为 external，即使用外部链接器。
- `-extldflags "-static -s -w"`：传递给外部链接器的选项，其中包含了 `-static`（强制使用静态链接）、`-s`（禁止符号表和调试信息生成）和 `-w`（禁止 DWARF 调试信息生成）三个选项。

这个命令的目的是生成一个静态链接的可执行文件，其中所有的依赖包都被链接进了最终的二进制文件中，这样可以保证可执行文件的可移植性和兼容性，同时也可以减小文件大小。这个命令的缺点是编译时间较长，特别是在包数量较多的情况下，因为它需要重新编译所有的包，即使它们已经是最新的。