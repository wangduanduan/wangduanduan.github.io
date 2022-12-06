---
title: "ch4-3 $var() 类型的传参"
date: "2021-04-25 09:10:28"
draft: false
---
假如一个模块暴露了一个函数，叫做do_something(), 仅支持传递一个参数。这个函数在c文件中对应w_do_something()

```bash
// 在opensips.cfg文件中

route{
	do_something("abc")
}

static int w_do_something(struct sip_msg* msg, char* str1){
 	// 在c文件中，我们打印str1的值，这个字符串就是abc
}
```

```bash
// 在opensips.cfg文件中

route{
	$var(num)="abc";
	do_something("$var(num)")
}

static int w_do_something(struct sip_msg* msg, char* str1){
 	// 在c文件中，我们打印str1的值，这个字符串就是$var(num)
  // 这时候就有问题了，其实我们想获取的是$var(num)的值abc, 而不是字符串$var(num)
}
```

那怎么获取$var()的传参的值呢？这里就需要用到了函数的fixup_函数。

```bash
static cmd_export_t cmds[]={
    {"find_zone_code", (cmd_function)w_do_something, 2, fixup_do_something, 0, REQUEST_ROUTE},
    {0,0,0,0,0,0}
};

// 调用fixup_spve， 只有在fixup函数中，对函数的参数执行了fixup, 在真正的执行函数中，才能得到真正的$var()的值
static int fixup_do_something(void** param, int param_no)
{
    LM_INFO("fixup_find_zone_code: param: %s  param_no: %d\n", (char *)*param, param_no);
    return fixup_spve(param);
}


static int w_do_something (struct sip_msg* msg, char* str1){
    str zone;

    if (fixup_get_svalue(msg, (gparam_p)str1, &zone) != 0) {
        LM_WARN("cannot find the phone!\n");
        return -1;
    }
    
    LM_INFO("zone:%s\n", zone.s);
    return 1;
}
```

