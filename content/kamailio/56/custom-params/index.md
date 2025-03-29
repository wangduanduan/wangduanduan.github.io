---
title: "1.15 自定义全局参数"
draft: false
tags:
- all
categories:
- all
---


These are parameters that can be defined by the writer of kamailio.cfg
in order to be used inside routing blocks. One of the important
properties for custom global parameters is that their value can be
changed at runtime via RPC commands, without restarting Kamailio.

The definition of a custom global parameter must follow the pattern:

    group.variable = value desc "description"

The value can be a quoted string or integer number.

Example:

``` c
pstn.gw_ip = "1.2.3.4" desc "PSTN GW Address"
```

The custom global parameter can be accessed inside a routing block via:

    $sel(cfg_get.group.variable)

Example:

``` c
$ru = "sip:" + $rU + "@" + $sel(cfg_get.pstn.gw_ip);
```

**Note:** Some words cannot be used as (part of) names for custom
variables or groups, and if they are used a syntax error is logged by
kamailio. These keywords are: "yes", "true", "on", "enable", "no",
"false", "off", "disable", "udp", "UDP", "tcp", "TCP", "tls", "TLS",
"sctp", "SCTP", "ws", "WS", "wss", "WSS", "inet", "INET", "inet6",
"INET6", "sslv23", "SSLv23", "SSLV23", "sslv2", "SSLv2", "SSLV2",
"sslv3", "SSLv3", "SSLV3", "tlsv1", "TLSv1", "TLSV1"
