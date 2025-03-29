---
title: "1.4 关键词"
draft: false
tags:
- all
categories:
- all
---

Keywords specific to SIP messages which can be used mainly in `if`
expressions.

> 核心关键词主要用在if语句里，如果用在xlog里打印，那么就打印的是字符串了呀

# 1. af

The address family of the received SIP message. It is INET if the
message was received over IPv4 or INET6 if the message was received over
IPv6.

Exampe of usage:

``` c
    if (af==INET6) {
        log("Message received over IPv6 link\n");
    }
```

# 2. dst_ip

The IP of the local interface where the SIP message was received. When
the proxy listens on many network interfaces, makes possible to detect
which was the one that received the packet.

Example of usage:

``` c
   if(dst_ip==127.0.0.1) {
      log("message received on loopback interface\n");
   };
```

# 3. dst_port

The local port where the SIP packet was received. When Kamailio is
listening on many ports, it is useful to learn which was the one that
received the SIP packet.

Example of usage:

``` c
   if(dst_port==5061)
   {
       log("message was received on port 5061\n");
   };
```

# 4. from_uri

This script variable is a reference to the URI of 'From' header. It can
be used to test 'From'- header URI value.

Example of usage:

``` c
    if(is_method("INVITE") && from_uri=~".*@kamailio.org")
    {
        log("the caller is from kamailio.org\n");
    };
```

# 5. method

The variable is a reference to the SIP method of the message.

Example of usage:

``` c
    if(method=="REGISTER")
    {
       log("this SIP request is a REGISTER message\n");
    };
```

# 6. msg:len

The variable is a reference to the size of the message. It can be used
in 'if' constructs to test message's size.

Example of usage:

``` c
    if(msg:len>2048)
    {
        sl_send_reply("413", "message too large");
        exit;
    };
```

.

# 7. proto

This variable can be used to test the transport protocol of the SIP
message.

Example of usage:

``` c
    if(proto==UDP)
    {
        log("SIP message received over UDP\n");
    };
```

# 8. status

If used in onreply_route, this variable is a referece to the status code
of the reply. If it used in a standard route block, the variable is a
reference to the status of the last reply sent out for the current
request.

Example of usage:

``` c
    if(status=="200")
    {
        log("this is a 200 OK reply\n");
    };
```

# 9. snd_af

# 10. snd_ip

# 11. snd_port

# 12. snd_proto

# 13. src_ip

Reference to source IP address of the SIP message.

Example of usage:

``` c
    if(src_ip==127.0.0.1)
    {
        log("the message was sent from localhost!\n");
    };
```

# 14. src_port

Reference to source port of the SIP message (from which port the message
was sent by previous hop).

Example of usage:

``` c
    if(src_port==5061)
    {
        log("message sent from port 5061\n");
    }
```

# 15. to_ip

# 16. to_port

# 17. to_uri

This variable can be used to test the value of URI from To header.

Example of usage:

``` c
  if(to_uri=~"sip:.+@kamailio.org")
  {
      log("this is a request for kamailio.org users\n");
  };
```

# 18. uri

This variable can be used to test the value of the request URI.

Example of usage:

``` c
    if(uri=~"sip:.+@kamailio.org")
    {
        log("this is a request for kamailio.org users\n");
    };
```
