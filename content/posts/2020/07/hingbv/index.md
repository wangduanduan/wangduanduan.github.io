---
title: "mac上netstat命令"
date: "2020-07-23 14:16:35"
draft: false
---
Mac上的netstat和Linux上的有不少的不同之处。

在Liunx上常使用

| Linux | Mac |
| --- | --- |
| netstat -nulp | netstat -nva -p udp |
| netsat -ntlp | netsat -nva -p tcp |


注意，在Mac上netstat的-n和linux上的含义相同

