---
title: "使用return语句减少逻辑嵌套"
date: "2021-03-23 14:54:08"
draft: false
---
使用return(int)语句可以返回整数值。

- return(0) 相当于exit(), 后续的路由都不在执行
- return(正整数) 后续的路由还会继续执行，if测试为true
- return(负整数) 后续的路由还会继续执行, if测试为false
- 可以使用 `$rc` 或者 `$retcode` 获取上一个路由的返回值
```bash
# 请求路由
route{
	route(check_is_feature_code);
  xlog("check_is_feature_code return code is $rc");
  ...
  ...
  route(some_other_check);
}
route[check_is_feature_code]{
	if ($rU !~ "^\*[0-9]+") {
  	xlog("check_is_feature_code: is not feature code $rU");
    # 非feature code, 提前返回
    return(1);
  }
  
  # 下面就是feature code的处理
  ......
}
route[some_other_check]{
	...
}
```


