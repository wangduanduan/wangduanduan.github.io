---
title: "常用语句"
date: "2021-03-23 15:05:06"
draft: false
---

# if
```bash
if (expr) {
	actions
} else {
	actions;
}

if (expr) {
	actions
} 
else if (expr) {
	actions;
}
```


# 表达式操作符号
常用的用黄色标记。

- **==** 等于
- **!=** 不等于
- **=~**  正则匹配 `$rU =~ '^1800*'`  is "$rU begins with 1800"
- **!~**  正则不匹配
- >  大于
- >= 大于等于
- <  小于
- <= 小于等于
- **&&** 逻辑与
- **|| **逻辑或
- **! **逻辑非
- [ ... ] - test operator - inside can be any arithmetic expression



# 其他
出了常见的if语句，opensips还支持switch, while, for each, 因为用的比较少。各位可以看官方文档说明。

[https://www.opensips.org/Documentation/Script-Statements-2-4](https://www.opensips.org/Documentation/Script-Statements-2-4)

