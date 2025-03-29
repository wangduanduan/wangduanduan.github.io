---
title: "1.5 核心值"
draft: false
tags:
- all
categories:
- all
---


Values that can be used in `'if`' expressions to check against Core
Keywords

> 主要还是用在if语句里做比较

# 1. INET

This keyword can be used to test whether the SIP packet was received
over an IPv4 connection.

Example of usage:

``` c
    if (af==INET) {
        log("the SIP message was received over IPv4\n");
    }
```

# 2. INET6

This keyword can be used to test whether the SIP packet was received
over an IPv6 connection.

Example of usage:

``` c
  if(af==INET6)
  {
      log("the SIP message was received over IPv6\n");
  };
```

# 3. SCTP

This keyword can be used to test the value of 'proto' and check whether
the SIP packet was received over SCTP or not.

Example of usage:

``` c
  if(proto==SCTP)
  {
      log("the SIP message was received over SCTP\n");
  };
```

# 4. TCP

This keyword can be used to test the value of 'proto' and check whether
the SIP packet was received over TCP or not.

Example of usage:

``` c
  if(proto==TCP)
  {
      log("the SIP message was received over TCP\n");
  };
```

# 5. TLS

This keyword can be used to test the value of 'proto' and check whether
the SIP packet was received over TLS or not.

Example of usage:

``` c
  if(proto==TLS)
  {
      log("the SIP message was received over TLS\n");
  };
```

# 6. UDP

This keyword can be used to test the value of 'proto' and check whether
the SIP packet was received over UDP or not.

Example of usage:

``` c
  if(proto==UDP)
  {
      log("the SIP message was received over UDP\n");
  };
```

# 7. WS

This keyword can be used to test the value of 'proto' and check whether
the SIP packet was received over WS or not.

Example of usage:

``` c
  if(proto==WS)
  {
      log("the SIP message was received over WS\n");
  };
```

# 8. WSS

This keyword can be used to test the value of 'proto' and check whether
the SIP packet was received over WSS or not.

Example of usage:

``` c
  if(proto==WSS)
  {
      log("the SIP message was received over WSS\n");
  };
```

# 9. max_len

Note: This command was removed.

# 10. myself

This is a reference to the list of local IP addresses, hostnames and
aliases that has been set in the Kamailio configuration file. This lists
contain the domains served by Kamailio.

The variable can be used to test if the host part of an URI is in the
list. The usefulness of this test is to select the messages that has to
be processed locally or has to be forwarded to another server.

See "alias" to add hostnames,IP addresses and aliases to the list.

Example of usage:

``` c
    if(uri==myself) {
        log("the request is for local processing\n");
    };
```

Note: You can also use the is_myself() function.