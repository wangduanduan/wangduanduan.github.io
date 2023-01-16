---
title: "vfs_cache_pressure和min_free_kbytes对cache的影响"
date: "2022-06-29 06:57:56"
draft: false
---


# 环境

- kernal Linux 5.15.48-1-MANJARO #1 SMP PREEMPT Thu Jun 16 12:33:56 UTC 2022 x86_64 GNU/Linux
- docker  20.10.16

# 初始内存
```
               total        used        free      shared  buff/cache   available
内存：       30Gi       1.9Gi        19Gi       2.0Mi       9.6Gi        28Gi
交换：         0B          0B          0B
```


# 初始配置
```
sysctl -n vm.min_free_kbytes
67584
sysctl -n vm.vfs_cache_pressure
200
```

# vfs_cache_pressure的对内存的影响
vfs_cache_pressure设置为200， 理论系统倾向于回收内存


