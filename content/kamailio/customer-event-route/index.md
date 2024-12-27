---
title: "源码笔记 - 自定义事件路由(上)"
date: "2024-12-27 20:45:03"
draft: false
type: posts
tags:
- all
categories:
- all
---



[[_TOC_]]



# 事件路由简介

在某些模块中，我们看到有一些模块自定义的事件路由。

例如dispatcher模块，或者rtpengine模块。

```sh
event_route[dispatcher:dst-down] {
    xlog("L_ERR", "Destination down: $rm $ru ($du)\n");
}

event_route[rtpengine:dtmf-event] {
    xlog("L_INFO", "callid: $avp(dtmf_event_callid)\n");
		xlog("L_INFO", "source_tag: $avp(dtmf_event_source_tag)\n");
		xlog("L_INFO", "timestamp: $avp(dtmf_event_timestamp)\n");
		xlog("L_INFO", "dtmf: $avp(dtmf_event)\n");
}
```



# disapcher模块



在dispatch.c文件中，我们看到如下代码

```c
if(!ds_skip_dst(old_state) && ds_skip_dst(idx->dlist[i].flags)) {
		ds_run_route(msg, address, "dispatcher:dst-down", rctx);
} else {
		if(ds_skip_dst(old_state) && !ds_skip_dst(idx->dlist[i].flags))
			ds_run_route(msg, address, "dispatcher:dst-up", rctx);
}
```



ds_run_route还是定义在dispatch.c文件中，

````c
static void ds_run_route(sip_msg_t *msg, str *uri, char *route, ds_rctx_t *rctx)
````



接着又一个重要调用。 这里似乎在查找路由。

route这个参数其实就是**dispatcher:dst-down**， 或者 **dispatcher:dst-up**，

那么event_rt又是什么鬼呢？

```c
rt = route_lookup(&event_rt, route);
```

event_rt是一个route_list的结构体

```c
// route.c
struct route_list event_rt;
```

route_list的结构如下，重点是这个str_hash_table这个字段，它似乎是一个hash

```c
struct route_list
{
	struct action **rlist;
	int idx;					 /* first empty entry */
	int entries;				 /* total number of entries */
	struct str_hash_table names; /* name to route index mappings */
};
```

str_hash_table的结构如下：

```c
struct str_hash_table
{
	struct str_hash_head *table;
	int size;
};

struct str_hash_head
{
	struct str_hash_entry *next;
	struct str_hash_entry *prev;
};

struct str_hash_entry
{
	struct str_hash_entry *next;
	struct str_hash_entry *prev;
	str key;
	unsigned int flags;
	union
	{
		void *p;
		char *s;
		int n;
		char data[sizeof(void *)];
	} u;
};
```



```c
int route_lookup(struct route_list *rt, char *name)
{
	int len;
	struct str_hash_entry *e;

	len = strlen(name);
	/* check if exists and non empty*/
	e = str_hash_get(&rt->names, name, len);
	if(e) {
		return e->u.n;
	} else {
		return -1;
	}
}
```



上面介绍了一大堆，我自己都有点晕了。

你给我介绍了事件路由是怎么一层一层调用的，

那我请问你，**这个事件路由是怎么安插代码里的？**事件路由的逻辑在脚本里，而并不是可以映射成模块的某个函数的？

要回答上面上面的问题，就必须要理解yyparse

# yyparse

说实在的我也不太懂这个上古神器，我只是简单了解它的功能，就是把输入一些定制脚本语言，然后输出c语言的函数调用。有点类似编译器的概念。

event_route的关键字是

```c
ROUTE_EVENT event_route
| {rt=EVENT_ROUTE;}   event_route_stm
```

下面就开始进入瞎猜模式，😂

```c
// cfg.y
// 以下注释纯属瞎猜，如果正确，就是凑巧；如果错误，纯属正常；
event_route_stm:
	event_route_main LBRACK EVENT_RT_NAME RBRACK LBRACE actions RBRACE {
		if (!shm_initialized() && init_shm()<0) {
			yyerror("Can't initialize shared memory");
			YYABORT;
		}
    // $3, 在这里代指EVENT_RT_NAME， 就是事件路由的名称
    // 这里其实就是根据名称查询路由的名称
		i_tmp=route_get(&event_rt, $3);
    // -1就是内部错误
		if (i_tmp==-1){
			yyerror("internal error");
			YYABORT;
		}
    // 正值就是重复了
		if (event_rt.rlist[i_tmp]){
			yyerror("duplicate route");
			YYABORT;
		}
    // 最后就是正常，然后把$6, 也就是action放到路由里面
		push($6, &event_rt.rlist[i_tmp]);
	}
```



route_get就是根据事件路由的名称，找到一个放置事件路由的**座位号**

```c

/*
 * if the "name" route already exists, return its index, else
 * create a new empty route
 * return route index in rt->rlist or -1 on error
 */
int route_get(struct route_list *rt, char *name)
{
	int len;
	struct str_hash_entry *e;
	int i;

	len = strlen(name);
	/* check if exists and non empty*/
	e = str_hash_get(&rt->names, name, len);
	if(e) {
		i = e->u.n;
	} else {
		i = route_new_list(rt);
		if(i == -1)
			goto error;
		if(route_add(rt, name, i) < 0) {
			goto error;
		}
	}
	return i;
error:
	return -1;
}
```



然后我们拿着**座位号**，把事件路由安置上

```c
/* adds an action list to head; a must be null terminated (last a->next=0))*/
void push(struct action *a, struct action **head)
{
	struct action *t;
	if(*head == 0) {
		*head = a;
		return;
	}
	for(t = *head; t->next; t = t->next)
		;
	t->next = a;
}
```



至此，我们就回来我们自己提出的问题：事件路由的内容是如何被安插进路由模块的。





