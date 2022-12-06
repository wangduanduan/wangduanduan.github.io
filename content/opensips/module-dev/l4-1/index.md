---
title: "ch4-1 USE_FUNC_PARAM参数类型"
date: "2021-04-21 14:02:28"
draft: false
---
模块传参有两种类型

1. 直接赋值传参
2. 间接函数调用传参

```bash
str local_zone_code = {"",0};
int some_int_param = 0;

static param_export_t params[]={
	// 直接字符串赋值
	{"local_zone_code", STR_PARAM,  &local_zone_code.s},
  // 直接整数赋值
	{"some_int_param", INT_PARAM,  &some_int_param},
  // 函数调用 字符窜
	{"zone_code_map", STR_PARAM|USE_FUNC_PARAM,  (void *)&set_code_zone_map},
  // 函数调用 整数
	{"zone_code_map_int", INT_PARAM|USE_FUNC_PARAM,  (void *)&set_code_zone_map_int},
	{0,0,0}
};
```

使用函数处理参数的好处是，可以对参数做更复杂的处理。

例如：

1. 某个参数可以多次传递
2. 对参数进行校验，在启动前就可以判断传参是否有问题。
```bash
static int set_code_zone_map(unsigned int type, void *val)
{
     LM_INFO("set_zone_code_map type:%d val:%s \n",type,(char *)val);
    return 1;
}
```

