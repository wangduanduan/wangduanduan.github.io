---
title: "源码笔记 - 自定义事件路由(中)"
date: "2024-12-28 09:43:00"
draft: false
type: posts
tags:
- all
categories:
- all
---



[[_TOC_]]



# route_list

route.h定义了几个函数分别用来获取、查找、新增route

```c
// src/core/route.h
int route_get(struct route_list *rt, char *name);
int route_lookup(struct route_list *rt, char *name);
void push(struct action *a, struct action **head);

struct route_list
{
	struct action **rlist;
	int idx;					 /* first empty entry */
	int entries;				 /* total number of entries */
	struct str_hash_table names; /* name to route index mappings */
};
```



## rlist

我们对route_list数据模型进行简化:

rlist是一个固定长度的一维数组，通过索引来访问对应的值。如果数组的空间不足，那么就创建一个两倍大的空数据，然后先把原始数据复制过去。这种复制方式保持的原始数据的索引位置。有点像golang的切片扩容机制。

这里最为重要的就是保持数组元素的索引位置在扩容后不变。

```c
static inline int route_new_list(struct route_list *rt)
{
	int ret;
	struct action **tmp;

	ret = -1;
	if(rt->idx >= rt->entries) {
    // 两倍扩容
		tmp = pkg_realloc(rt->rlist, 2 * rt->entries * sizeof(struct action *));
		if(tmp == 0) {
			LM_CRIT("out of memory\n");
			goto end;
		}
		/* init the newly allocated memory chunk */
		memset(&tmp[rt->entries], 0, rt->entries * sizeof(struct action *));
		rt->rlist = tmp;
		rt->entries *= 2;
	}
	if(rt->idx < rt->entries) {
		ret = rt->idx;
		rt->idx++;
	}
end:
	return ret;
}
```



## str_hash_table

我们对hash_table的数据模型进行简化，它其实就是一hash表，key是路由的名，值是一个正数，正数代表了路由执行单元的索引位置。



如果我们用js对route_list来表示

1. dispatcher:dst-down对应的是索引0
2. 索引0在rlist里对应的是func1
3. dispatcher:dst-down事件发生后，调用func1

```js
let rlist = [func1, func2, func3]
let names = {
  'dispatcher:dst-down': 0,
  'rtpengine:dtmf-event': 1
}
```

其实这里完全可以不用数组，如果在js里,  可以直接用函数作为hash的key

```js
let names = {
  'dispatcher:dst-down': func1,
  'rtpengine:dtmf-event': func2
}
```



## action

```c
// src/core/route_struct.h
struct action
{
	int cline;
	char *cfile;
	char *rname;
	enum action_type type; /* forward, drop, log, send ...*/
	int count;
	struct action *next;
	action_u_t val[MAX_ACTIONS];
};
```



## str_hash_table

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





在src/core/route.c中定义如下几个变量，分别管理着6钟不同的路由。

```c
// src/core/route.c
/* main routing script table  */
struct route_list main_rt; 
struct route_list onreply_rt;
struct route_list failure_rt;
struct route_list branch_rt;
struct route_list onsend_rt;
struct route_list event_rt;
```


