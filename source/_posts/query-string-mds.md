---
title: 查询字符串的最小数据集
date: 2018-01-30 10:45:37
tags:
- docs
---

# 1. 什么是查询字符串？

给个例子：

```
https://en.wikipedia.org/w/load.php?debug=false&lang=en&modules=startup&only=scripts&skin=vector
```

查询字符串是url中问号后边的部分，形式如：key1=value1&key2=value2&key3=value3。这部分称为`查询(query)组件`。

# 2. 查询组件的最小数据集

- `参数名`：
- `是否必须`：
- `是否是精确查询`：
- `描述`：
- `示例`：必须要有，比如说如果查询的是一个时间。那么时间的格式有很多种，务必给出示例
- `约束`：
  - 字符串：最小长度，最大长度。[3,10]
  - 数值型：取值区间。[4, 10]
  - 枚举型：枚举字符串。1代表男，0代表女

# 3. 举例说明：一个用户查询的接口

参数名 | 是否必须 | 是否是精确查询 | 描述 | 示例 | 约束
---|---|---|---|----|---
email | 否 | 是 | 邮箱 | test@tt.cc | 长度：[6, 10] 
age | 否 | 是 | 年龄 | 18 | 取值：[0, 110]
gender | 否 | 是 | 性别 | 1 | 1代表男，0代表女
userName | 否 | 否 | 用户名 | alex | 长度：[4, 40]
token | 是 | 是 | 认证令牌 | 90sdflkajf0asdflkja | 长度：60
registerBeginTime | 否 | 是 | 开始注册时间，返回的结果都是该时间以后的数据 | 2018-09-20 17:23:00 | 长度：19


很多资源


# 4. 参考
- [wikipedia:Query_string](https://en.wikipedia.org/wiki/Query_string)
