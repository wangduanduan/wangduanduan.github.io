---
title: Docker镜像批量清理脚本
date: 2018-12-04 15:05:31
tags:
- docker
---

使用jenkins作为打包的工具，主机上的磁盘空间总是被慢慢被占满，直到jenkins无法运行。本文从几个方面来清理docker垃圾。

# 批量删除已经退出的容器

```
docker ps -a | grep "Exited" | awk '{print $1 }' | xargs docker rm
```

# 批量删除带有none字段的镜像

$3一般就是取出每一行的镜像id字段

```
# 方案1： 根据镜像id删除镜像
docker images| grep none |awk '{print $3 }'|xargs docker rmi

# 方案2: 根据镜像名删除镜像
docker images | grep wecloud | awk '{print $1":"$2}' | xargs docker rmi
```

方案1，根据镜像ID删除镜像时，有写镜像虽然镜像名不同，但是镜像ID都是相同的，这是后往往会删除失败。所以根据镜像名删除镜像的效果会更好。


# 删除镜像定时任务脚本

```sh
#!/bin/bash
# create by wangduanduan
# when current free disk less then max free disk, you can remove docker images
#

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

max_free_disk=5 # 5G. when current free disk less then max free disk, remove docker images
current_free_disk=`df -lh | grep centos-root | awk '{print strtonum($4)}'`

df -lh

echo "max_free_disk: $max_free_disk G"
echo -e "current_free_disk: ${GREEN} $current_free_disk G ${NC}"

if [ $current_free_disk -lt $max_free_disk ]
then
	echo -e "${RED} need to clean up docker images ${NC}"
	docker images | grep none | awk '{print $3 }' | xargs docker rmi
	docker images | grep wecloud | awk '{print $1":"$2}' | xargs docker rmi
else
	echo -e "${GREEN}no need clean${NC}"
fi
```
