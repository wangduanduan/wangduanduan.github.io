---
title: centos7 服务管理指令
date: 2018-01-29 21:40:36
tags:
- centos7
---

功能 | 命令
--- | ---
使服务开启启动 | systemctl enable httpd.service
关闭服务开机启动 | systemctl disabled httpd.service
检查服务状态 | systemctl status httpd.service
查看所有已启动的服务 | systemctl list-units --type=service
启动服务 | systemctl start httpd.service
停止服务 | systemctl stop httpd.service
重启服务 | systemctl restart httpd.service