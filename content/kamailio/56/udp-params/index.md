---
title: "1.11 UDP参数"
draft: false
tags:
- all
categories:
- all
---


# 1. udp4_raw

Enables raw socket support for sending UDP IPv4 datagrams (40-50%
performance increase on linux multi-cpu).

Possible values: 0 - disabled (default), 1 - enabled, -1 auto.

In "auto" mode it will be enabled if possible (sr started as root or
with CAP_NET_RAW). udp4_raw can be used on Linux and FreeBSD. For other
BSDs and Darwin one must compile with -DUSE_RAW_SOCKS. On Linux one
should also set udp4_raw_mtu if the MTU on any network interface that
could be used for sending is smaller than 1500.

The parameter can be set at runtime as long as sr was started with
enough privileges (core.udp4_raw).

    udp4_raw = on

# 2. udp4_raw_mtu

MTU value used for UDP IPv4 packets when udp4_raw is enabled. It should
be set to the minimum MTU of all the network interfaces that could be
used for sending. The default value is 1500. Note that on BSDs it does
not need to be set (if set it will be ignored, the proper MTU will be
used automatically by the kernel). On Linux it should be set.

The parameter can be set at runtime (core.udp4_raw_mtu).

# 3. udp4_raw_ttl

TTL value used for UDP IPv4 packets when udp4_raw is enabled. By default
it is set to auto mode (-1), meaning that the same TTL will be used as
for normal UDP sockets.

The parameter can be set at runtime (core.udp4_raw_ttl).