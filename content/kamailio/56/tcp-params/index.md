---
title: "1.8 TCP参数"
draft: false
tags:
- all
categories:
- all
---

The following parameters allows to tweak the TCP behaviour.

# 1. disable_tcp

Global parameter to disable TCP support in the SIP server. Default value
is 'no'.

Example of usage:

      disable_tcp=yes

# 2. tcp_accept_aliases

If a message received over a tcp connection has "alias" in its via a new
tcp alias port will be created for the connection the message came from
(the alias port will be set to the via one).

Based on draft-ietf-sip-connect-reuse-00.txt, but using only the port
(host aliases are dangerous, involve extra DNS lookups and the need for
them is questionable)

See force_tcp_alias for more details.

Note: For NAT traversal of TCP clients it is better to not use
tcp_accept_aliases but just use nathelper module and
fix_nated\_\[contact\|register\] functions.

Default is "no" (off)

     tcp_accept_aliases= yes|no

# 3. tcp_accept_haproxy

Enable the internal TCP stack to expect a PROXY-protocol-formatted
header as the first message of the connection. Both the human-readable
(v1) and binary-encoded (v2) variants of the protocol are supported.
This option is typically useful if you are behind a TCP load-balancer,
such as HAProxy or an AWS' ELB, and allows the load-balancer to provide
connection information regarding the upstream client. This enables the
use of IP-based ACLs, even behind a load-balancer.

Please note that enabling this option will reject any inbound TCP
connection that does not conform to the PROXY-protocol spec.

For reference: A PROXY protocol -
<https://www.haproxy.org/download/1.8/doc/proxy-protocol.txt>

Default value is **no**.

``` c
tcp_accept_haproxy=yes
```

# 4. tcp_accept_hep3

Enable internal TCP receiving stack to accept HEP3 packets. This option
has to be set to **yes** on a Kamailio instance acting as Homer
SIPCapture server that is supposed to receive HEP3 packets over TCP/TLS.

Default value is **no**.

``` c
tcp_accept_hep3=yes
```

# 5. tcp_accept_no_cl

Control whether to throw or not error when there is no Content-Length
header for requests received over TCP. It is required to be set to
**yes** for XCAP traffic sent over HTTP/1.1 which does not use
Content-Length header, but splits large bodies in many chunks. The
module **sanity** can be used then to restrict this permission to HTTP
traffic only, testing in route block in order to stay RFC3261 compliant
about this mandatory header for SIP requests over TCP.

Default value is **no**.

``` c
tcp_accept_no_cl=yes
```

# 6. tcp_accept_unique

If set to 1, reject duplicate connections coming from same source IP and
port.

Default set to 0.

``` c
tcp_accept_unique = 1
```

# 7. tcp_async

**Alias name:** **tcp_buf_write**

If enabled, all the tcp writes that would block / wait for connect to
finish, will be queued and attempted latter (see also tcp_conn_wq_max
and tcp_wq_max).

**Note:** It also applies for TLS.

    tcp_async = yes | no (default yes)

# 8. tcp_children

Number of children processes to be created for reading from TCP
connections. If no value is explicitly set, the same number of TCP
children as UDP children (see "children" parameter) will be used.

Example of usage:

      tcp_children=4

# 9. tcp_clone_rcvbuf

Control if the received buffer should be cloned from the TCP stream,
needed by functions working inside the SIP message buffer (such as
msg_apply_changes()).

Default is 0 (don't clone), set it to 1 for cloning.

Example of usage:

      tcp_clone_rcvbuf=1

# 10. tcp_connection_lifetime ⭐️

Lifetime in seconds for TCP sessions. TCP sessions which are inactive
for longer than **tcp_connection_lifetime** will be closed by Kamailio.
Default value is defined is 120. Setting this value to 0 will close the
TCP connection pretty quick ;-).

Note: As many SIP clients are behind NAT/Firewalls, the SIP proxy should
not close the TCP connection as it is not capable of opening a new one.

Example of usage:

      tcp_connection_lifetime=3605

# 11. tcp_connection_match

If set to 1, try to be more strict in matching outbound TCP connections,
attempting to lookup first the connection using also local port, not
only the local IP and remote IP+port.

Default is 0.

``` c
tcp_connection_match=1
```

# 12. tcp_connect_timeout ⭐️

Time in seconds before an ongoing attempt to establish a new TCP
connection will be aborted. Lower this value for faster detection of TCP
connection problems. The default value is 10s.

Example of usage:

      tcp_connect_timeout=5

# 13. tcp_conn_wq_max

Maximum bytes queued for write allowed per connection. Attempting to
queue more bytes would result in an error and in the connection being
closed (too slow). If tcp_buf_write is not enabled, it has no effect.

    tcp_conn_wq_max = bytes (default 32 K)

# 14. tcp_crlf_ping

Enable SIP outbound TCP keep-alive using PING-PONG (CRLFCRLF - CRLF).

    tcp_crlf_ping = yes | no default: yes

# 15. tcp_defer_accept

Tcp accepts will be delayed until some data is received (improves
performance on proxies with lots of opened tcp connections). See linux
tcp(7) TCP_DEFER_ACCEPT or freebsd ACCF_DATA(0). For now linux and
freebsd only.

WARNING: the linux TCP_DEFER_ACCEPT is buggy (\<=2.6.23) and doesn't
work exactly as expected (if no data is received it will retransmit syn
acks for \~ 190 s, irrespective of the set timeout and then it will
silently drop the connection without sending a RST or FIN). Try to use
it together with tcp_syncnt (this way the number of retrans. SYNACKs can
be limited => the timeout can be controlled in some way).

On FreeBSD:

    tcp_defer_accept =  yes | no (default no)

On Linux:

    tcp_defer_accept =  number of seconds before timeout (default disabled)

# 16. tcp_delayed_ack

Initial ACK for opened connections will be delayed and sent with the
first data segment (see linux tcp(7) TCP_QUICKACK). For now linux only.

    tcp_delayed_ack  = yes | no (default yes when supported)

# 17. tcp_fd_cache

If enabled FDs used for sending will be cached inside the process
calling tcp_send (performance increase for sending over tcp at the cost
of slightly slower connection closing and extra FDs kept open)

    tcp_fd_cache = yes | no (default yes)

# 18. tcp_keepalive

Enables keepalive for tcp (sets SO_KEEPALIVE socket option)

    tcp_keepalive = yes | no (default yes)

# 19. tcp_keepcnt ⭐️

Number of keepalives sent before dropping the connection (TCP_KEEPCNT
socket option). Linux only.

    tcp_keepcnt = number (not set by default)

# 20. tcp_keepidle ⭐️

Time before starting to send keepalives, if the connection is idle
(TCP_KEEPIDLE socket option). Linux only.

    tcp_keepidle  = seconds (not set by default)

# 21. tcp_keepintvl ⭐️

Time interval between keepalive probes, when the previous probe failed
(TCP_KEEPINTVL socket option). Linux only.

    tcp_keepintvl = seconds (not set by default)

# 22. tcp_linger2

Lifetime of orphaned sockets in FIN_WAIT2 state (overrides
tcp_fin_timeout on, see linux tcp(7) TCP_LINGER2). Linux only.

    tcp_linger2 = seconds (not set by default)

# 23. tcp_max_connections ⭐️

Maximum number of tcp connections (if the number is exceeded no new tcp
connections will be accepted). Default is defined in tcp_init.h: #define
DEFAULT_TCP_MAX_CONNECTIONS 2048

Example of usage:

      tcp_max_connections=4096

# 24. tcp_no_connect ⭐️

Stop outgoing TCP connects (also stops TLS) by setting tcp_no_connect to
yes.

You can do this any time, even even if Kamailio is already started (in
this case using the command "kamcmd cfg.set_now_int tcp no_connect 1").

# 25. tcp_poll_method

Poll method used (by default the best one for the current OS is
selected). For available types see io_wait.c and poll_types.h: none,
poll, epoll_lt, epoll_et, sigio_rt, select, kqueue, /dev/poll

Example of usage:

      tcp_poll_method=select

# 26. tcp_rd_buf_size

Buffer size used for tcp reads. A high buffer size increases performance
on server with few connections and lot of traffic on them, but also
increases memory consumption (so for lots of connection is better to use
a low value). Note also that this value limits the maximum message size
(SIP, HTTP) that can be received over tcp.

The value is internally limited to 16MByte, for higher values recompile
Kamailio with higher limit in tcp_options.c (search for "rd_buf_size"
and 16777216). Further, you may need to increase the private memory, and
if you process the message stateful you may also have to increase the
shared memory.

Default: 4096, can be changed at runtime.

``` c
tcp_rd_buf_size=65536
```

# 27. tcp_reuse_port ⭐️

Allows reuse of TCP ports. This means, for example, that the same TCP
ports on which Kamailio is listening on, can be used as source ports of
new TCP connections when acting as an UAC. Kamailio must have been
compiled in a system implementing SO_REUSEPORT (Linux \> 3.9.0, FreeBSD,
OpenBSD, NetBSD, MacOSX). This parameter takes effect only if also the
system on which Kamailio is running on supports SO_REUSEPORT.

    tcp_reuse_port = yes (default no)

# 28. tcp_script_mode

Specify if connection should be closed (set to CONN_ERROR) if processing
the received message results in error (that can also be due to negative
return code from a configuration script main route block). If set to 1,
the processing continues with the connection open.

Default 0 (close connection)

    tcp_script_mode = 1

# 29. tcp_send_timeout ⭐️

Time in seconds after a TCP connection will be closed if it is not
available for writing in this interval (and Kamailio wants to send
something on it). Lower this value for faster detection of broken TCP
connections. The default value is 10s.

Example of usage:

      tcp_send_timeout=3

# 30. tcp_source_ipv4, tcp_source_ipv6

Set the source IP for all outbound TCP connections. If setting of the IP
fails, the TCP connection will use the default IP address.

    tcp_source_ipv4 = IPv4 address
    tcp_source_ipv6 = IPv6 address

# 31. tcp_syncnt

Number of SYN retransmissions before aborting a connect attempt (see
linux tcp(7) TCP_SYNCNT). Linux only.

    tcp_syncnt = number of syn retr. (default not set)

# 32. tcp_wait_data

Specify how long to wait (in milliseconds) to wait for data on tcp
connections in certain cases. Now applies when reading on tcp connection
for haproxy protocol.

Default: 5000ms (5secs)

``` c
tcp_wait_data = 10000
```

# 33. tcp_wq_blk_size

Block size used for tcp async writes. It should be big enough to hold a
few datagrams. If it's smaller than a datagram (in fact a tcp write())
size, it will be rounded up. It has no influenced on the number of
datagrams queued (for that see tcp_conn_wq_max or tcp_wq_max). It has
mostly debugging and testing value (can be ignored).

Default: 2100 (\~ 2 INVITEs), can be changed at runtime.

# 34. tcp_wq_max

Maximum bytes queued for write allowed globally. It has no effect if
tcp_buf_write is not enabled.

    tcp_wq_max = bytes (default 10 Mb)