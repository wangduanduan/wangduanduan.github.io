---
title: "拓扑隐藏学习以及实践"
date: "2022-03-31 20:34:02"
draft: false
---

# 1. 拓扑隐藏功能

1. 删除Via头
2. 删除Route
3. 删除Record-Route
4. 修改Contact
5. 可选隐藏Call-ID

如下图所示，根据SIP的Via, Route, Record-Route的头，往往可以推测服务内部的网络结构。

![](https://cdn.nlark.com/yuque/__graphviz/df4521ccc5dea3626b5b7ddd87d68047.svg#lake_card_v2=eyJ0eXBlIjoiZ3JhcGh2aXoiLCJjb2RlIjoiZGlncmFwaHtcblx0cmFua2Rpcj1MUlxuXHRhIC0-IGJcblx0YiAtPiBjXG5cdGMgLT4g55So5oi3XG59IiwidXJsIjoiaHR0cHM6Ly9jZG4ubmxhcmsuY29tL3l1cXVlL19fZ3JhcGh2aXovZGY0NTIxY2NjNWRlYTM2MjZiNWI3ZGRkODdkNjgwNDcuc3ZnIiwiaWQiOiJDN3FXYiIsIm1hcmdpbiI6eyJ0b3AiOnRydWUsImJvdHRvbSI6dHJ1ZX0sImNhcmQiOiJkaWFncmFtIn0=)
我们不希望别人知道的我们的内部网络结构。我们只希望只能看到C这个sip server。<br />经过拓扑隐藏过后

1. 用户看不到关于a、b的via, route, record-route头
2. 用户看到的Contact头被修改成C的IP地址
3. 可以选择把原始的Call-ID也修改

![](https://cdn.nlark.com/yuque/__graphviz/9c819af57d08e4316ef94bc96d54de56.svg#lake_card_v2=eyJ0eXBlIjoiZ3JhcGh2aXoiLCJjb2RlIjoiZGlncmFwaHtcblx0cmFua2Rpcj1MUlxuXHRjIC0-IOeUqOaIt1xufSIsInVybCI6Imh0dHBzOi8vY2RuLm5sYXJrLmNvbS95dXF1ZS9fX2dyYXBodml6LzljODE5YWY1N2QwOGU0MzE2ZWY5NGJjOTZkNTRkZTU2LnN2ZyIsImlkIjoiSlZwYUMiLCJtYXJnaW4iOnsidG9wIjp0cnVlLCJib3R0b20iOnRydWV9LCJjYXJkIjoiZGlhZ3JhbSJ9)当然，拓扑隐藏除了可以隐藏一些信息，也有一个其他的好处：减少SIP消息包的长度。如果SIP消息用UDP传输，减少包的体积，可以大大降低UDP分片的可能性。

所以，综上所述：拓扑隐藏有以下好处

- 隐藏服务内部网络结构
- 减少SIP包的体积



# 2. 脚本例子

拓扑隐藏的实现并不复杂。首先要加载拓扑隐藏的模块

```bash
loadmodule "topology_hiding.so"
```

## 2.1 初始化路由的处理

在初始化路由里，只需要调用topology_hiding()

- U 表示不隐藏Contact的用户名信息
- C 表示隐藏Call-ID

```bash
# if it's an INVITE dialog, we can create the dialog now, will lead to cleaner SIP messages
if (is_method("INVITE"))
        create_dialog();

# we do topology hiding, preserving the Contact Username and also hiding the Call-ID
topology_hiding("UC");
t_relay();
exit;
```


## 2.2 序列化路由的处理

在序列化请求中，只需要调用topology_hiding_match(), 后续的就可以交给OpenSIPS处理了。

```bash
if (has_totag()) {
        if (topology_hiding_match()) {
            xlog("Succesfully matched this request to a topology hiding dialog. \n");
            xlog("Calller side callid is $ci \n");
            xlog("Callee side callid  is $TH_callee_callid \n");
            t_relay();
            exit;
        } else {
            if ( is_method("ACK") ) {
                if ( t_check_trans() ) {
                    t_relay();
                    exit;
                } else
                    exit;
            }
            sl_send_reply("404","Not here");
            exit;
        }
}
```


## 2.3 注意事项

如果用了拓扑隐藏，就不要用record_route()用record_route_preset()， 去设置Record-Route头了，否则SIP消息将会在sip server上一只循环发送。

![](https://cdn.nlark.com/yuque/__puml/0b28cc211a40ae9309ed569ec7002e55.svg#lake_card_v2=eyJ0eXBlIjoicHVtbCIsImNvZGUiOiJAc3RhcnR1bWxcblxuYXV0b251bWJlclxuXG5cbkMgLT4gQzogQUNLXG5DIC0-IEM6IEFDS1xuQyAtPiBDOiBBQ0tcbkMgLT4gQzogQUNLXG5DIC0-IEM6IEFDS1xuQyAtPiBDOiBBQ0tcblxuXG5AZW5kdW1sIiwidXJsIjoiaHR0cHM6Ly9jZG4ubmxhcmsuY29tL3l1cXVlL19fcHVtbC8wYjI4Y2MyMTFhNDBhZTkzMDllZDU2OWVjNzAwMmU1NS5zdmciLCJpZCI6Im5kR3ZvIiwibWFyZ2luIjp7InRvcCI6dHJ1ZSwiYm90dG9tIjp0cnVlfSwiY2FyZCI6ImRpYWdyYW0ifQ==)

# 4. 参考文档

- [https://www.opensips.org/Documentation/Tutorials-Topology-Hiding](https://www.opensips.org/Documentation/Tutorials-Topology-Hiding)
- [https://opensips.org/html/docs/modules/2.1.x/topology_hiding.html#idp256096](https://opensips.org/html/docs/modules/2.1.x/topology_hiding.html#idp256096)

