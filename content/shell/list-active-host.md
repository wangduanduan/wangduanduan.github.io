---
title: '列出网络中活动的主机'
date: '2019-12-26 10:34:15'
draft: false
---

# 使用 ping

-   优点
    -   原生，不用安装软件
-   缺点
    -   速度慢

下面的脚本列出 192.168.1.0/24 的所有主机，大概需要 255 秒

```bash
#!/bin/bash

function handler () {
  echo "will exit"
  exit 0
}

trap 'handler' SIGINT

for ip in 192.168.1.{1..255}
do
  ping -W 1 -c 1 $ip &> /dev/null
  if [ $? -eq 0 ]; then
    echo $ip is alive
  else
    echo $ip is dead
  fi
done
```

# 使用 fping

-   优点
    -   速度快
-   缺点
    -   需要安装 fping

```bash
# 安装fping
brew install fping # mac
yum install fping # centos
apt install fping # debian
```

我用的 fping 是 MacOS X， fping 的版本是 4.2

用 fping 去执行，同样 256 个主机，只需要 5-6s

```bash
fping -g 192.168.1.0/24 -r 1 -a -s
```
