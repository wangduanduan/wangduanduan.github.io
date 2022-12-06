---
title: "pcap抓包教程"
date: "2020-12-02 13:27:13"
draft: false
---

# 准备条件
- 有gcc编译器
- 安装libpcap包


# 1.c 试运行
```c
#include <stdio.h>
#include <pcap.h>

int main(int argc, char *argv[])
{
  char *dev = argv[1];
  printf("Device: %s\n", dev);
  return(0);
}
```

```bash
gcc ./1.c -o 1.exe -lpcap
demo-libpcap git:(master) ✗ ./1.exe eth0
Device: eth0
```

第一个栗子非常简单，仅仅是测试相关的库是否加载正确


# 2.c 获取默认网卡名称



# 参考

- [http://www.tcpdump.org/pcap.html](http://www.tcpdump.org/pcap.html)

