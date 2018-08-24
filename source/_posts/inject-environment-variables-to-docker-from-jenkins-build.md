---
title: jenkins构建镜像时，如何向镜像中注入动态环境变量？
date: 2018-07-23 19:23:53
tags:
- docker
- jenkins
- environment variable
---

# STEP 1: jenkins Additional Build Arguments

jenkins Docker Build and Publish插件有个高级选项，Additional Build Arguments

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180723192825_l83hdH_Jietu20180723-192716.jpeg)

可以在docker构建时，将额外的参数传递给dockerfile。

`$BUILD_NUMBER`是jenkins自带的一个环境变量，每次构建后都会加1，如：1，2，3，它是一个动态的变量，不同的构建具有不同的构建序号。

```
--build-arg my_build_number="$BUILD_NUMBER"
```

# STEP 2: dockerfile arg

dockerfile 增加如下参数。如果只做了第一步，但是没有在dockerfile中申明运行时会多传入哪些参数，构建就会失败。

`ARG` 参数指定了构建时可以传递哪些参数进来，并且可以设置默认值，但是docker构建时传递的参数会覆盖默认值。

`ENV` 指令将my_build_number设置为一个环境变量，它的值为ARG参数的值。

如果你构建的程序是nodejs项目，你就可以通过`process.env.my_build_number`获取jenkins构建镜像时传入的参数。

```
ARG my_build_number=''

ENV my_build_number ${my_build_number}
```