---
title: "路由分类"
date: "2019-06-16 10:46:44"
draft: false
---
opensips路由分为两类，主路由和子路由。**主路由被opensips调用，子路由在主路由中被调用。可以理解子路由是一种函数。**

**所有路由中不允许出现无任何语句的情况，否则将会导致opensips无法正常启动，例如下面**

```bash
route[some_xxx]{

}
```

主路由分为几类

1. 请求路由
2. 分支路由
3. 失败路由
4. 响应路由
5. 本地路由
6. 启动路由
7. 定时器路由
8. 事件路由
9. 错误路由

> inspect：查看sip消息内容
> modifies: 修改sip消息内容，例如修改request url
> drop: 丢弃sip请求
> forking: 可以理解为发起一个invite, 然后可以拨打多个人
> signaling: 信令层的操作，例如返回200ok之类的

| 路由 | 是否必须 | 默认行为 | 可以做 | 不可以做 | 触发方向 | 触发次数 |
| --- | --- | --- | --- | --- | --- | --- |
| 请求路由 | 是 | drop | inspect,modifies, drop, signaling |  | incoming, inbound |  |
| 分支路由 | 否 | send out | forking, modifies, drop, inspect | relaying, replying,<br />signaling | outbound, outgoing, branch frok | 一个请求/事务一次 |
| 失败路由 | 否 | 将错误返回给产生者 | signaling，replying, inspect |  | incoming | 一个请求/事务一次 |
| 响应路由 | 否 | relay back | inspect, modifies | signaling | incoming, inbound | 一个请求/事务一次 |
| 本地路由 | 否 | send out |  | signaling | outbound | 本地路由只能有一个 |

剩下的启动路由，定时器路由，事件路由，错误路由只能用来做和sip消息无关的事情。


## 请求路由

请求路由因为受到从外部网络来的请求而触发。

```bash
 # 主路由
route {
      ......
     if (is_method("INVITE")) {
  				route(check_hdrs,1); # 调用子路由check_hdrs，1是传递给子路由的参数
  				if ($rc<0) # 使用$rc获取上个子路由的处理结果
         	exit;
			}

}
# sub-route
route[check_hdrs] {
     	if (!is_present_hf("Content-Type"))
       	return(-1);
     	if ( $param(1)==1 && !has_body() ) # 子路由使用$param(1), 获取传递的第一个参数
       	return(-2);  # 使用return() 返回子路由的处理结果
		return(1); 
}

```

$rc和$retcode都可以获取子路由的返回结果。

请求路由是必须的一个路由，所有从网络过来的请求，都会经过请求路由。

在请求路由中，可以做三个动作

1. 给出响应
2. 向前传递
3. 丢弃这个请求

**注意事项：**

1. request路由被到达的sip请求触发
2. 默认的动作是丢弃这个请求


## 分支路由
**注意事项：**

1. request路由被到达的sip请求触发
2. 默认的动作是发出这个请求
3. t_on_branch并不是立即执行分支路由，而是注册分支路由的处理事件
4. 注意所有**t_on_**开头的函数都是注册钩子，而不是立即执行。注册钩子可以理解为不是现在执行，而是未来某个时间会被触发执行。
5. 分支路由只能用来触发一次，多次触发将会重写
6. 你可以在这个路由中修改sip request url, 但是不能执行reply等信令方面的操作
```bash
route{
	...
  t_on_branch("nat_filter")
  ...
}

branch_route[nat_filter]{

}
```


## 失败的路由

1. 当收到大于等于300的响应时触发失败路由
2. <br />
```bash
route{
	...
  t_on_failure("vm_redirect")
  ...
}

failure_route[vm_redirects]{
}
```


## 响应路由
当收到响应时触发，包括1xx-6xx的所有响应。

响应路由分为两类

1. 全局响应路由，即不带名称的onreply_route{},  自动触发，在带名响应路由前执行。
2. 带名称的响应路由，即onreplay_route[some_name]{}，需要用t_on_reply()方法来设置触发。

```bash
route{
	t_on_reply("inspect_reply");
}

onreply_route{
  xlog("$rm/$rs/$si/$ci: global onreply route");
}

onreply_route[inspect_reply]{
     if ( t_check_status("1[0-9][0-9]") ) {
       xlog("provisional reply $T_reply_code received\n");
     } if ( t_check_status("2[0-9][0-9]") ) {
       xlog("successful reply $T_reply_code received\n");
       remove_hf("User-Agent");
     } else {
       xlog("non-2xx reply $T_reply_code received\n");
     }
}
```


## 本地路由
有些请求是opensips自己发的，这时候触发本地路由。<br />使用场景：在多人会议时，opensips可以给多人发送bye消息。

```bash
local_route {

}
```


## 启动路由
可以让你在opensips启动时做些初始化操作

**注意启动路由里面一定要有语句**，哪怕是写个xlog("hello"), 否则opensips将会无法启动。

```bash
startup_route {
}
```


## 计时器路由
在指定的周期，触发路由。可以用来更新本地缓存。

**注意计时器路由里面一定要有语句**，哪怕是写个xlog("hello"), 否则opensips将会无法启动。

如：每隔120秒，做个事情
```bash
timer_route[gw_update, 120] {
     # update the local cache if signalized
     if ($shv(reload) == 1 ) {
       avp_db_query("select gwlist from routing where id=10",
                    "$avp(list)");
       cache_store("local","gwlist10"," $avp(list)");
     }
}
```


## 事件路由
当收到某些事件是触发，例如日志，数据库操作，数据更新，某些

在事件路由的内部，可以使用$param(key)的方式获取事件的某些属性。

```bash
xlog("first parameters is $param(1)\n"); # 根据序号
xlog("Pike Blocking IP is $param(ip)\n"); # 根据key
```

```bash
event_route[E_DISPATCHER_STATUS] {

}

event_route[E_PIKE_BLOCKED] {
		xlog("IP $param(ip) has been blocked\n");
}
```

更多可以参考： [https://opensips.org/html/docs/modules/devel/event_route.html](https://opensips.org/html/docs/modules/devel/event_route.html)



## 错误路由
用来捕获运行时错误，例如解析sip消息出错。

```bash
error_route {
   xlog("$rm from $si:$sp  - error level=$(err.level),
     info=$(err.info)\n");
        sl_send_reply("$err.rcode", "$err.rreason");
        exit;
 }
```


