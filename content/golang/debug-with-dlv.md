---
title: "Debug With Dlv"
date: 2021-08-07T21:50:05+08:00
---

本来打算用gdb调试的，看了官方的文档https://golang.org/doc/gdb， 官方更推荐使用delve这个工具调试。

我的电脑是linux, 所以就用如下的命令安装。

`go install github.com/go-delve/delve/cmd/dlv@latest`

我要调试的并不是一个代码而是一个测试的代码。

当执行测试的时候报错的位置是xxx/demo/demo_test.go, 200行

```
dlv test moduleName/demo
> b demo_test.go:200 # 在文件的对应行设置端点
> bp # print all breakpoint
> c # continue to exe
> p variableName
```

