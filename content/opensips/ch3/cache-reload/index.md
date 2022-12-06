---
title: "模块缓存策略与reload方法"
date: "2019-08-20 09:11:21"
draft: false
---

# 常见的问题
有时候如果你直接在数据库中改动某些值，但是opensips并没有按照预设的值去执行，那么你就要尝试使用mi命令去reload相关模块。


# 有缓存模块
opensips在启动时，会将某些模块所使用的表**一次性全部加载到数据库，状态变化时，再回写到数据库**。有一下模块列表：

- dispather
- load_balancer
- carrierroute
- dialplan
- ...

判断一个模块是否是一次性加载到内存的，有个简便方法，看这个模块是否提供类似于 xx_reload的mi接口，有reload的mi接口，就说明这个模块是使用一次性读取，变化回写的方式读写数据库。

将模块一次性加载到内存的好处时不用每次都查数据库，运行速度会大大提升。

以dispather为例子，opensips在启动时会从数据库总加载一系列的目标到内存中，然后按照设定值，周期性的向目标发送options包，如果目标挂掉，三次未响应，opensips将会将该目标的状态设置为非0值，表示该地址不可用，同时将该状态回写到数据库。


# 无缓存模块
无缓存的模块每次都会向数据库查询数据。常见的模块有alias_db，该模块的说明

> ALIAS_DB module can be used as an alternative for user aliases via usrloc. The main feature is that it does not store all adjacent data as for user location and always uses database for search (**no memory caching**).


ALIAS_DB一般用于呼入时接入号的查询，在多租户的情况下，如果大多数租户都是使用呼入的场景，那么ALIAS_DB模块可能会是一个性能瓶颈，建议将该模块使用一些内存数据库替代。



# 从浏览器reload模块
opensips在加载了httpd和mi_http模块之后，可以在opensips主机的8888端口访问到管理页面，具体地址如：<br />http://opensips_host:8888/mi

![Jietu20190827-075246@2x.jpg](https://cdn.nlark.com/yuque/0/2019/jpeg/280451/1566863682080-41348c89-e7fb-4c7e-92e9-e8f641460436.jpeg#align=left&display=inline&height=582&name=Jietu20190827-075246%402x.jpg&originHeight=582&originWidth=2296&size=121723&status=done&width=2296)<br />这个页面可以看到opensips所加载的模块，然后我们点击carrierroute,  可以看到该模块所支持的管理命令列表，如下图左侧列表所示，其中cr_reload_routes就是一个管理命令。

![Jietu20190827-075326.jpg](https://cdn.nlark.com/yuque/0/2019/jpeg/280451/1566863747570-a04794ae-010b-45c9-8f8d-f611f04bdd91.jpeg#align=left&display=inline&height=822&name=Jietu20190827-075326.jpg&originHeight=822&originWidth=2746&size=161286&status=done&width=2746)

然后我们点击cr_reload_routes连接，跳转到下图所示页面。参数可以不用填写，直接点击submit就可以。正常情况下回返回 200 : OK，就说明reload模块成功。

![Jietu20190827-075352.jpg](https://cdn.nlark.com/yuque/0/2019/jpeg/280451/1566863833785-a3469a46-c14a-4c71-a021-8b5f0d66dffc.jpeg#align=left&display=inline&height=528&name=Jietu20190827-075352.jpg&originHeight=528&originWidth=1334&size=73900&status=done&width=1334)



# 使用curl命令reload模块

如果因为某些原因，无法访问web界面，那么可以使用curl等http命令行工具执行curl命令，例如

```bash
curl http://192.168.40.98:8888/mi/carrierroute/cr_reload_routes?arg=
```


