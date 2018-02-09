---
title: centos7 初始化软件安装及服务管理
date: 2018-02-09 13:10:42
tags:
- centos7
---

> 因为阿里云最近搞活动，所以买了一台阿里云香港的一台最低配置主机。用来搞搞开发，做静态页面，给女朋友发短信，爬爬页面，翻墙等等。

# 1. 软件安装

## 1.1. 安装git
```
yum install git

//检查git是否安装成功
git --version
```

## 1.2. 安装oh-my-zsh
```
// 检查有没有安装zsh, 没有安装的话，先安装zsh
cat /etc/shells

// 没有安装zsh,先安装zsh
yum install zsh

// 然后安装oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## 1.3. 安装ss
基于python2.7

[参考文献](http://heroi.cn/2017/08/09/%E9%98%BF%E9%87%8C%E4%BA%91ecs%E9%A6%99%E6%B8%AF%E8%8A%82%E7%82%B9%E6%90%AD%E5%BB%BAss%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91%E5%85%A8%E8%BF%87%E7%A8%8B/)

```
// 安装setuptools pip
yum install python-setuptools && easy_install pip

// 安装shadowsocks
pip install shadowsocks

// 新建/etc/shadowsocks.json 文件
{
    "server":"0.0.0.0",
    "server_port":your-server_port,
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"your-password",
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open":false,
    "workers":5
}

// 服务启动
ssserver -c /etc/shadowsocks.json -d start

// 服务停止
ssserver -d stop

// 查看服务状态
netstat -tunlp
```

## 1.4. 安装nodejs
```
yum install epel-release
yum install nodejs

// 如果出现 CentOS 7 使用 npm 失败 npm: symbol SSL_set_cert_cb
yum -y install yum-utils
yum-config-manager --enable cr && yum update

// 安装cnpm
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

## 1.5. 安装nginx
[参考](http://www.centoscn.com/nginx/2017/0119/8422.html)
```
// 直接通过 yum install nginx 肯定是不行的,因为yum没有nginx，所以首先把 nginx 的源加入 yum 中。
// 将nginx放到yum repro库中
rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

// 查看nginx信息
yum info nginx

// 安装nginx
yum install nginx
```

# 2. 安装python3
```
yum install epel-release
yum install python34
python3 --version
```

# 3. 服务管理
功能 | 命令
--- | ---
使服务开启启动 | systemctl enable httpd.service
关闭服务开机启动 | systemctl disabled httpd.service
检查服务状态 | systemctl status httpd.service
查看所有已启动的服务 | systemctl list-units --type=service
启动服务 | systemctl start httpd.service
停止服务 | systemctl stop httpd.service
重启服务 | systemctl restart httpd.service


