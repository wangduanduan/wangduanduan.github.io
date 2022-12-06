---
title: "NAT解决方法"
date: "2019-09-17 08:58:52"
draft: false
---

# 解决信令的过程

1. NAT检测
2. 使用rport解决Via
3. 在初始化请求和响应中修改Contact头
4. 处理来自NAT内部的注册请求
5. Ping客户端使NAT映射保持打开
6. 处理序列化请求


# 实现NAT检测 nat_uac_test

使用函数 nat_uac_test

```bash
1 搜索Contact头存在于RFC 1918 中的地址
2 检测Via头中的received参数和源地址是否相同
4 最顶部的Via出现在RFC1918 / RFC6598地址中
8 搜索SDP头出现RFC1918 / RFC6598地址
16 测试源端口是否和Via头中的端口不同
32 比较Contact中的地址和源信令的地址
64 比较Contact中的端口和源信令的端口
```
						

上边的测试都是可以组合的，并且任何一个测试通过，则返回true。

例如下面的测试19，实际上是1+2+16三项测试的组合

```bash
nat_uac_test("19")
```

# 使用rport和receive参数标记Via头

从NAT内部出去的呼叫，往往可能不知道自己的出口IP和端口，只有远端的SIP服务器收到请求后，才能知道UAC的真是出口IP和端口。出口IP用received=x.x.x.x，出口端口用rport=xx。当有消息发到UAC时，应当发到received和rport所指定的地址和端口。

```bash
# 原始的Via
Via: SIP/2.0/UDP 192.168.4.48:5062;branch=z9hG4bK523223793;rport
# 经过opensips处理后的Via
Via: SIP/2.0/UDP 192.168.4.48:5062;received=192.168.4.48;branch=z9hG4bK523223793;rport=5062
```


# 修复Contact头
Via头和Contact头是比较容易混淆的概念，但是两者的功能完全不同。Via头使用来导航183和200响应应该如何按照原路返回。Contact用来给序列化请求，例如BYE和UPDATE导航。如果Contact头不正确，可能会导致呼叫无法挂断。那么就需要用fix_nated_contact()函数去修复Contact头。另外，对于183和200的响应也需要去修复Contact头。


# 处理注册请求


# RFC 1918 地址组

- 10.0.0.0        -   10.255.255.255  (10/8 prefix)
- 172.16.0.0      -   172.31.255.255  (172.16/12 prefix)
- 192.168.0.0     -   192.168.255.255 (192.168/16 prefix)

# 参考

- [http://www.rfcreader.com/#rfc1918](http://www.rfcreader.com/#rfc1918)

