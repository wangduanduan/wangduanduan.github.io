---
title: "kaldi安装"
date: "2020-05-12 15:40:02"
draft: false
---
为了省去安装的麻烦，我直接使用的是容器版本的kaldi

[https://hub.docker.com/r/kaldiasr/kaldi](https://hub.docker.com/r/kaldiasr/kaldi)

```
docker pull kaldiasr/kaldi
```


```
This is the official Docker Hub of the Kaldi project: http://kaldi-asr.org

Kaldi offers two sets of images: CPU-based images and GPU-based images. Daily builds of the latest version of the master branch (both CPU and GPU images) are pushed to DockerHub.

Sample usage of the CPU based images:

docker run -it kaldiasr/kaldi:latest

Sample usage of the GPU based images:

Note: use nvidia-docker to run the GPU images.

docker run -it --runtime=nvidia kaldiasr/kaldi:gpu-latest

Please refer to Kaldi's GitHub repository for more details.
```

kaldiasr/kaldi这个镜像是基于linuxkit构建的，如果缺少什么包，可以使用apt命令在容器中安装


# 安装oymyzsh

因为我比较喜欢用ohmyzsh, 所以即使在容器里，我也想安装这个工具

```
apt install zsh curl
```


