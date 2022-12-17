---
title: "监控pod重启并写日志文件"
date: "2021-07-28 21:21:33"
draft: false
---
一般来说，监控pod状态重启和告警，可以使用普罗米修斯或者kubewatch。

但是如果你只想将某个pod重启了，往某个日志文件中写一条记录，那么下面的方式将是非常简单的。

实现的思路是使用kubectl 获取所有pod的状态信息，统计发生过重启的pod, 然后和之前的重启次数做对比，如果比之前记录的次数大，那么肯定是发生过重启了。

```bash
#!/bin/bash
now=$(date "+%Y-%m-%d %H:%M:%S")
log_file="/var/log/pod.restart.log"
ns="some-namespace"

echo $now start pod restart monitor >> $log_file

# touch一下之前的记录文件，防止文件不存在
touch restart.old.log

# 生成本次的统计数据
kubectl get pod -n $ns -o wide | awk '$4 > 0{print $1,$4}' | grep -v NAME > restart.now.log


# 按行读取本次统计数据
# 数据格式为：podname 重启次数

while read line
do
	# pod name
	name=$(echo $line | awk '{print $1}')
  
  # 重启次数
  count=$(echo $line | awk '{print $2}')
  
  # 检查本次重启的pod名称是否在之前的记录中存在
  if grep $name restart.old.log; then
    # 如果存在，则取出之前记录的重启次数
  	t=$(grep $name restart.old.log | awk '{print $2}')
    # 和本次记录的重启次数比较，如果本次的重启次数较大
    # 则说明pod一定重启过
    if [ $count -gt $t]; then
    	echo $now ERROR pod_restart $name >> $log_file
    fi
  else
  	# 如果重启的pod不存在之前的记录中，也说明pod重启过
  	echo $now ERROR pod_restart $name >> $log_file
  fi
done < restart.now.log

# 删除老的记录文件
rm -f restart.old.log

# 将新的记录文件重命名为老的记录文件
mv restart.now.log restart.old.log
```

然后可以将上面的脚本做成定时任务，每分钟执行一次。那么就可以将pod重启的信息写入文件。

然后配合一些日志监控的程序，就可以监控日志文件。然后提取关键词，最后发送告警信息。

其实我们也可以在写告警日志文件的同时，通过curl发送http请求，来发送告警通知。

在公有云上，可以使用钉钉的通知webhook, 也是非常方便的。

