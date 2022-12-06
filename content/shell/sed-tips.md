---
title: 'sed替换'
date: '2021-07-08 09:17:30'
draft: false
---

# 直接在原文的基础上修改

```bash
sed -i 's/ABC/abc/g' some.txt
```

# 多次替换

-   方案 1 使用分号

```shell
sed 's/ABC/abc/g;s/DEF/def/g' some.txt
```

-   方案 2 多次使用-e

```shell
sed -e 's/ABC/abc/g' -e 's/DEF/def/g' some.txt
```

# 转译/

如果替换或者被替换的字符中本来就有`/`, 那么替换就会无法达到预期效果，那么我们可以用其他的字符来替代/。

> The / characters may be uniformly replaced by any other single character within any given s command. The / character (or whatever other character is used in its stead) can appear in the _regexp_ or _replacement_ only if it is preceded by a \ character.
> <br />[https://www.gnu.org/software/sed/manual/sed.html](https://www.gnu.org/software/sed/manual/sed.html)

```bash
# 可以用#来替代/
sed 's#ABC#de/#g' some.txt
# 也可以用?来替代/
sed 's?ABC?de#?g' some.txt
```

# 替代的目标中包含变量

```shell
# 注意这里用的是双引号，内部的变量会被转义
sed "s#ABC#${TODAY}#g" some.txt
```

# 参考

-   [https://www.gnu.org/software/sed/manual/sed.html](https://www.gnu.org/software/sed/manual/sed.html)
