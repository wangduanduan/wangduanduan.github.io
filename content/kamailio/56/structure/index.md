---
title: "1.1 脚本结构 - 全局参数、模块配置、路由"
# date: "2025-03-28 23:25:05"
draft: false
# type: posts
tags:
- all
categories:
- all
---

# 1. Structure

The structure of the kamailio.cfg can be seen as three parts:

- global parameters
- modules settings
- routing blocks

For clarity and making it easy to maintain, it is recommended to keep
them in this order, although some of them can be mixed.

> ✅ 这三个部分可以混合，但为了清晰和维护的方便，建议按照这个顺序排列。

# 2. Global Parameters Section

This is the first part of the configuration file, containing the
parameters for the core of kamailio and custom global parameters.

Typically this is formed by directives of the form:

    name=value

The name corresponds to a core parameter as listed in one of the next
sections of this document. If a name is not matching a core parameter,
then Kamailio will not start, rising an error during startup.

> ✅ 无法识别的全局参数，将会导致kamailio无法启动。

The value is typically an integer, boolean or a string.

Several parameters can get a complex value which is formed from a group
of integer, strings or identifiers. For example, such parameter is
**listen**, which can be assigned a value like **proto:ipaddress:port**.

Example of content:

``` c
log_facility=LOG_LOCAL0

children=4

disable_tcp=yes

alias="sip.mydomain.com"

listen=udp:10.0.0.10:5060
```

Usually setting a parameter is ended by end of line, but it can be also
ended with **;** (semicolon). This should be used when the grammar of a
parameter allows values on multiple lines (like **listen** or **alias**)
and the next line creates a conflict by being swallowed as part of value
for previous parameter.

``` c
alias="sip.mydomain.com";
```

If you want to use a reserved config keyword as part of a parameter, you
need to enclose it in quotes. See the example below for the keyword
"dns".

> ✅ 如果要使用保留的配置关键字作为参数的一部分，需要用引号括起来。

``` c
listen=tcp:127.0.0.1:5060 advertise "sip.dns.example.com":5060
```

# 3. Modules Settings Section

This is the second section of the configuration file, containing the
directives to load modules and set their parameters.

It contains the directives **loadmodule** and **modparam**. In the
default configuration file starts with the line setting the path to
modules (the assignment to **mpath** core parameter.

Example of content:

``` c
loadmodule "debugger.so"
...
modparam("debugger", "cfgtrace", 1)
```

# 4. Routing Blocks Section

This is the last section of the configuration file, typically the
biggest one, containing the routing blocks with the routing logic for
SIP traffic handled by Kamailio.

The only mandatory routing block is **request_route**, which contains
the actions for deciding the routing for SIP requests.

See the chapter **Routing Blocks** in this document for more details
about what types of routing blocks can be used in the configuration file
and their role in routing SIP traffic and Kamailio behaviour.

Example of content:

``` c
request_route {

    # per request initial checks
    route(REQINIT);

    ...
}

branch_route[MANAGE_BRANCH] {
    xdbg("new branch [$T_branch_idx] to $ru\n");
    route(NATMANAGE);
}
```