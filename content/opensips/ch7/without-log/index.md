---
title: "opensips启动失败没有任何报错日志"
date: "2019-08-02 17:48:49"
draft: false
---
1. 将opensips.cfg文件中的，log_stderror的值改为yes, 让出错直接输出到标准错误流上，然后opensips start
2. 如果第一步还是没有日志输出，则opensips -f opensips.cfg

