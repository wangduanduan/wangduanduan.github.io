---
title: "模块传参的重构"
date: "2021-04-27 13:36:22"
draft: false
---
写过opensips脚本的同学，往往对函数的传参感到困惑。

例如：

- ds_select_dst()可以接受整数或者值为正数的变量作为第一个参数，但是nat_uac_test()的第一个参数就只能是整数，而不能是变量
- 为什么rl_check()可以接受格式化的字符串，而save()只能接受字符串。
- 为什么`ds_select_dst("1", "4")` 作为整数也要加上双引号？
- 为什么变量要加上双引号？ `ds_select_dst("$var(aa)", "4")`
- 为什么`t_on_branch("1")`路由的钩子要加上双引号？
- 为什么`route(go_to_something);`这里又不需要加上引号？

```bash
ds_select_dst("1", "0");
$var(aa)=1;
ds_select_dst("$var(aa)", "0");
rl_check("gw_$ru", "$var(limit)"); #格式化的gw_$ru
save("location"); #单纯的字符串作为参数
```

从3.0开始，传参可以更加自然。

- 整数可以直接传参，不用加双引号
```bash
do_something(1, 1);
```

- 输入或者输出的$var(), 不用加双引号，加了反而会报错
```bash
do_something($var(a), $var(b));
```

- 格式化字符串，需要加双引号
```bash
do_something(1, "$var(bb)_$var(b)");
```

# 参考

- [https://blog.opensips.org/2019/11/05/the-module-function-interface-rework-in-opensips-3-0/](https://blog.opensips.org/2019/11/05/the-module-function-interface-rework-in-opensips-3-0/)
- [https://www.opensips.org/Documentation/Script-Syntax-3-0#](https://www.opensips.org/Documentation/Script-Syntax-3-0#)

