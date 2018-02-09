---
title: ssh 无密码登录远程服务器
date: 2018-01-29 21:27:38
tags:
- ssh
---

# 1. 前提说明
A(本机 mac item2)
B(远程机器 ip:a.b.c.d centos)

# 2. 过程1
# 3. 生成public_key与private_key
在本机上输入，可以一路回车，不用说明
```
ssh-keygen -t rsa
```

最终会在`~/.ssh/`下生成两个文件
```
id_rsa
id_rsa.pub
```

# 4. 将public_key上传到远程服务器
注意：在本机上输入
```
// 回车之后，需要输入远程主机B的登录密码
scp ~/.ssh/id_rsa.pub root@a.b.c.d:/root/.ssh
```

# 5. 登录远程主机
在本机上输入
```
// 需要输入远程主机的密码
ssh root@a.b.c.d

// 进到远程主机~/.ssh/目录下, 此目录下应该已经有了之前上传的id_rsa.pub文件
// 如果目录下没有authorized_keys文件，那么将id_rsa.pub改名成authorized_keys

mv id_rsa.pub authorized_keys

// 如果远程目录下已经存在authorized_keys文件，可以将id_rsa.pub追加进去

cat id_rsa.pub >> authorized_keys
```

# 6. 本机配置
注意，此时需要退出ssh, 在本机上执行以下命令
```
vi ~/.ssh/config

在config文件中追加以下内容，并保存退出

Host serverName
Hostname a.b.c.d
Port 22
User root
IdentityFile ~/.ssh/id_rsa
```

然后试一下，只需要`ssh serverName`, 就可以直接登录远程服务器，是不是很爽

# 7. 参考文献
- [scp 命令教程](http://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/scp.html)
- [mac用iterm2实现ssh，怎么像SecureCRT一样保存IP和账号密码？](https://www.zhihu.com/question/30640159)

# 8. 精华推荐
最后推荐一本非常好的linux常用命令手册，非常不错哦。

> Linux下有很多命令行工具供我们使用，每个工具总是提供了大量参数供我们选择； 实际工作中，我们用到的工具，最常用的总是那么几个参数组合； 为此，我写了这本书相对实用的书；

> 这本书专注于Linux工具的最常用用法，以便读者能以最快时间掌握，并在工作中应用；

- [《Linux工具快速教程》](http://linuxtools-rst.readthedocs.io/zh_CN/latest/index.html)
