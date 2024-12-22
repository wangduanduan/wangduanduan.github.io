---
title: "DMQ模块源码学习笔记"
date: "2024-12-22 18:07:08"
draft: false
type: posts
tags:
- all
categories:
- all
---

# 背景

多个SIP注册服务器之间，如何同步分机的注册信息呢？

简单的方案就是使用共享数据库的方式同步注册信息，这个方案实现起来简单，但是分机的注册信息本身就是个需要频繁增删改查的，数据库很可能在大量注册分机的压力下，成为性能的瓶颈。

除了数据库之外，OpenSIPS和kamailio分别提供了不同的方案。

OpenSIPS提供的方案是使用cluster模块，cluster模块在多个实例之间同步分机的注册信息，注册信息的格式是OpenSIPS自定义的格式。
Kamailio的方案是DMQ模块， DMQ听起来高大上，放佛是依赖外部的一个服务。 但它其实就是扩展SIP消息，通过SIP消息来广播分机的注册信息。

```log
KDMQ sip:notification_peer@192.168.40.15:5090 SIP/2.0
Via: SIP/2.0/UDP 192.168.40.15;branch=z9hG4bK55e5.423d95110000
To: <sip:notification_peer@192.168.40.15:5090>
From: <sip:notification_peer@192.168.40.15:5060>;tag=2cdb7a33a7f21abb98fd3a44968e3ffd-5b01
CSeq: 10 KDMQ
Call-ID: 1fe138e07b5d0a7a-50419@192.168.40.15
Content-Length: 116
User-Agent: kamailio (4.3.0 (x86_64/linneaus))
Max-Forwards: 1
Content-Type: text/plain

sip:192.168.40.16:5060;status=active
sip:192.168.40.15:5060;status=disabled
sip:192.168.40.17:5060;status=active
```

# 源码分析

该模块一共暴露了8个参数，其中7个参数都是简单类型，INT和STR，就直接取对应变量的地址就可以了。

其中notification_address参数是用来配置集群中其他节点的通信地址的，因为要配置多次，所以需要用一个函数来解析。

```c
// dmq.c
static param_export_t params[] = {
	{"num_workers", PARAM_INT, &dmq_num_workers},
	{"ping_interval", PARAM_INT, &dmq_ping_interval},
	{"server_address", PARAM_STR, &dmq_server_address},
	{"server_socket", PARAM_STR, &dmq_server_socket},
	{"notification_address", PARAM_STR|PARAM_USE_FUNC, dmq_add_notification_address},
	{"notification_channel", PARAM_STR, &dmq_notification_channel},
	{"multi_notify", PARAM_INT, &dmq_multi_notify},
	{"worker_usleep", PARAM_INT, &dmq_worker_usleep},
	{0, 0, 0}
};
```

这些参数都没有加上static关键词，主要目的为了在dmq模块的其他c文件能使用。

```c
// dmq.c
int dmq_num_workers = DEFAULT_NUM_WORKERS;
int dmq_worker_usleep = 0;
str dmq_server_address = {0, 0};
str dmq_server_socket = {0, 0};
str dmq_notification_channel = str_init("notification_peer");
int dmq_multi_notify = 0;
int dmq_ping_interval = 60;
str_list_t *dmq_notification_address_list = NULL;
```


## dmq_add_notification_address

这个函数是在脚本解析阶段执行，每次配置一个notification_address，它就会被调用一次。

最终的目的就是组装dmq_notification_address_list这个链表结构，它里面存的就是集群里其他节点的SIP通信地址。


```c
static int dmq_add_notification_address(modparam_t type, void *val)
{
	str tmp_str;
	int total_list = 0; /* not used */

	if(val == NULL) {
		LM_ERR("invalid notification address parameter value\n");
		return -1;
	}
	tmp_str.s = ((str *)val)->s;
	tmp_str.len = ((str *)val)->len;

	/*
	这个参数的格式是个SIP URL
	如： 
		sip:10.0.0.21:5060
		sip:10.0.0.21:5061;transport=tls
	所以需要做一次解析，其实也是验证数据的格式是否正确
	dmq_notification_uri 是个static类型的值，可以重复使用
	*/
	if(parse_uri(tmp_str.s, tmp_str.len, &dmq_notification_uri) < 0) {
		LM_ERR("could not parse notification address\n");
		return -1;
	}

	/* initial allocation */
	if(dmq_notification_address_list == NULL) {
		/* 
		初次分配，
		申请一块内容，用来存储第一个元素
		*/
		dmq_notification_address_list = pkg_malloc(sizeof(str_list_t));
		// 申请失败
		if(dmq_notification_address_list == NULL) {
			PKG_MEM_ERROR;
			return -1;
		}
		// 装载列表的第一项
		dmq_tmp_list = dmq_notification_address_list;
		dmq_tmp_list->s = tmp_str;
		dmq_tmp_list->next = NULL;
		LM_DBG("Created list and added new notification address to the list "
			   "%.*s\n",
				dmq_tmp_list->s.len, dmq_tmp_list->s.s);
	} else {
		// 思考这里传入的是双层指针，而不是指针，这是为什么？
		// 在函数参数中使用指向指针的指针，可以修改指针本身的值
		// append_str_list 就要修改last指针的指向
		// notification_address 每次被设置一次，链表就要增加一项，dmq_tmp_list就要向后移动一位
		dmq_tmp_list = append_str_list(
				tmp_str.s, tmp_str.len, &dmq_tmp_list, &total_list);
		if(dmq_tmp_list == NULL) {
			LM_ERR("could not append to list\n");
			return -1;
		}
		LM_DBG("added new notification address to the list %.*s\n",
				dmq_tmp_list->s.len, dmq_tmp_list->s.s);
	}
	return 0;
}
```

