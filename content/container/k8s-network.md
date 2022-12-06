---
title: "K8s pod node网络"
date: "2022-10-26 08:57:54"
draft: false
---

# 1. 同一个Node上的pod网段相同
- kube-node1
   - pod1: 172.16.30.8
   - pod2: 172.16.30.9
   - pod3: 172.16.30.23
- kube-node2
   - pod4: 172.18.0.5
   - pod5: 172.18.0.6

# 2. pod中service name dns解析

使用nslookup命令去查询service name

- 第2行 DNS服务器名
- 第3行 DNS服务器地址
- 第5行 目标主机的名称
- 第6行 目标主机的IP地址

```shell
bash-5.0# nslookup security
Server:		10.254.10.20
Address:	10.254.10.20#53

Name:	security.test.svc.cluster.local
Address: 10.254.63.136
```

## 2.1. 问题1：

那么问题来了，为什么我要解析的域名是security, 但是返回的主机名是security.test.svc.cluster.local呢？

```shell
bash-5.0# cat /etc/resolv.conf
nameserver 10.254.10.20
search test.svc.cluster.local svc.cluster.local cluster.local
options ndots:5
```

在/etc/resolve.conf中，search选项后有几个值，它的作用是，如果你搜索的主机名中没有点, 那么你输入的名字就会和search选中的名字组合，也就是说。

你输入的是abc, 那么就会按照如何下的顺序去解析域名

1. abc.test.svc.cluster.local
2. abc.svc.cluster.local
3. cluster.local

所以我们看到的dns解析的名字就是abc.test.svc.cluster.local。

## 2.2. 问题2：
在resolve.conf中，dns服务器的地址是10.254.10.20，那么这个地址运行的是什么呢？

我们用dns反向解析，将IP解析为域名，可以看到主机的名称为kube-dns.kube-system.svc.cluster.local.

```shell
bash-5.0# nslookup 10.254.10.20
20.10.254.10.in-addr.arpa	name = kube-dns.kube-system.svc.cluster.local.
```

而实际上，这个IP地址就是kube-dns的地址。

```shell
[root@kube-m ~]# kubectl get service -n kube-system -o wide
NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE    SELECTOR
kube-dns               ClusterIP   10.254.10.20     <none>        53/UDP,53/TCP    15d    k8s-app=kube-dns
```

而k8s-app=kube-dns这个label可以选中coredns

```shell
[root@kube-m ~]# kubectl get pod -l k8s-app=kube-dns -nkube-system
NAME                       READY   STATUS    RESTARTS   AGE
coredns-79f9c855c5-nrk88   1/1     Running   0          15d
coredns-79f9c855c5-x75rq   1/1     Running   0          5h45m
```

