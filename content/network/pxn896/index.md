---
title: "ngrep明文http抓包教程"
date: "2019-08-16 09:59:08"
draft: false
---
一般使用tcpdump抓包，然后将包文件下载到本机，用wireshark去解析过滤。

但是这样会显得比较麻烦。

ngrep可以直接在linux转包，明文查看http的请求和响应信息。


# 安装

```bash
apt install ngrep # debian
yum install ngrep # centos7

# 如果centos报错没有ngrep, 那么执行下面的命令, 然后再安装
rpm -ivh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```



# HTTP抓包

- -W byline 头信息会自动换行
- host 192.168.60.200  是过滤规则 源ip或者目的ip是192.168.60.200

```bash
ngrep -W byline host 192.168.60.200

interface: eth0 (192.168.1.0/255.255.255.0)
filter: (ip or ip6) and ( host 192.168.60.200 )
####
T 192.168.1.102:39510 -> 192.168.60.200:7775 [AP]
GET / HTTP/1.1.
Host: 192.168.60.200:7775.
User-Agent: curl/7.52.1.
Accept: */*.
.

#
T 192.168.60.200:7775 -> 192.168.1.102:39510 [AP]
HTTP/1.1 302 Moved Temporarily.
Server: Apache-Coyote/1.1.
Set-Cookie: JSESSIONID=211CA612EC681B9FDCE7726B03F42088; Path=/; HttpOnly.
Location: http://192.168.60.200:7775/homepage.action.
Content-Type: text/html.
Content-Length: 0.
Date: Fri, 16 Aug 2019 02:16:51 GMT.
```


# 过滤规则

## 按IP地址过滤
```bash
ngrep -W byline host 192.168.60.200 # 源地址或者目的地址是 192.168.60.200
```


## 按端口过滤

```bash
ngrep -W byline port 80 # 源端口或者目的端口是 80
```


## 按照正则匹配

```bash
ngrep -W byline -q HTTP # 匹配所有包中含有HTTP的
```


# 指定网卡

默认情况下，ngrep使用网卡列表中的一个网卡，当然你也可以使用-d选项来指定抓包某个网卡。

```bash
ngrep -W byline -d eth0 host 192.168.60.200
```


# 参考

- [https://www.tecmint.com/ngrep-network-packet-analyzer-for-linux/](https://www.tecmint.com/ngrep-network-packet-analyzer-for-linux/)
- [https://github.com/jpr5/ngrep](https://github.com/jpr5/ngrep)

