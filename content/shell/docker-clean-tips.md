---
title: 'Docker镜像批量清理脚本'
date: '2019-08-06 13:48:13'
draft: false
---

使用 jenkins 作为打包的工具，主机上的磁盘空间总是被慢慢被占满，直到 jenkins 无法运行。本文从几个方面来清理 docker 垃圾。

# 批量删除已经退出的容器

```
docker ps -a | grep "Exited" | awk '{print $1 }' | xargs docker rm
```

# 批量删除带有 none 字段的镜像

$3 一般就是取出每一行的镜像 id 字段

```
# 方案1： 根据镜像id删除镜像
docker images| grep none |awk '{print $3 }'|xargs docker rmi
# 方案2: 根据镜像名删除镜像
docker images | grep wecloud | awk '{print $1":"$2}' | xargs docker rmi
```

方案 1，根据镜像 ID 删除镜像时，有写镜像虽然镜像名不同，但是镜像 ID 都是相同的，这是后往往会删除失败。所以根据镜像名删除镜像的效果会更好。

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

# 注意事项

`为了加快打包的速度，一般不要太频繁的删除镜像`。因为老的镜像中的某些不改变的层，可以作为新的镜像的缓存，从而大大加快构建的速度。
