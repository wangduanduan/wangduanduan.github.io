---
title: "Hot Reload OpenSIPS vs Kamailio"
date: "2025-03-29 13:49:38"
draft: false
type: posts
tags:
- all
categories:
- all
---

用过nginx的都知道，改了nginx的配置文件，只需要执行`nginx -s reload`就可以让改动生效，而不用重启整个服务。

在kamailio和opensips中，也有类似的热重载功能。

在kamailio中，如果要热重载配置文件，只需要执行`kamcmd app_jsdt.reload`即可。
在opensips中，如果要热重载配置文件，只需要执行`opensips-cli -x mi reload_routes`即可。

理想很丰满，现实很骨感。

如果要只是修改路由模块，两者都可以做热重载。 如果要动态的新增一些模块，那就必须要重启。

# Kamailio的实现方案

必须要用KEMI框架： cfg + [lua|js|python|ruby]

用这个框架，你写的路由脚本将包括两个部分

1. 核心模块，全局配置，模块加载，模块配置，事件路由这部分内容还是写在cfg文件中。
2. 请求路由、响应路由、分支路由、失败路由等这部分内容可以用lua、js、 python等来写。

在热重载的时候，实际上只有外部脚本会被重新加载，而核心模块是不会被重新加载的。

因为部分路由用其他脚本编写，必然涉及到性能比较。官方给出的结论是，在同等条件下，lua的性能是最好的。

https://www.kamailio.org/wikidocs/devel/config-engines/#interpreters-performances

但是实际生产环境如何，还不好说。

另外一点，就是并不是所有模块都实现了KEMI框架的接口，可能存在风险。

# OpenSIPS的实现方案

OpenSIPS在3.0版本首次引入了热重载路由脚本的能力，脚本还是cfg，没有引入其他语言。

https://www.opensips.org/Documentation/Interface-CoreMI-3-0#toc8


# 结论

总体而言，目的是相同的，都是为了热重载路由。

kamailio的方案看似灵活，实则复杂。如果cfg本身就能做热重载，那么就没必要引入其他语言。

我更倾向使用OpenSIPS的方案


# 参考
- https://blog.opensips.org/2019/04/04/no-downtime-for-opensips-3-0-restarts/


