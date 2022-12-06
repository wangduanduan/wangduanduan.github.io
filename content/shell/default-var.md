---
title: '设置变量默认值'
date: '2020-06-03 18:44:33'
draft: false
---

## 用法

| Parameter        | What does it do?                                                |
| ---------------- | --------------------------------------------------------------- |
| `${VAR:-STRING}` | If `VAR` is empty or unset, use `STRING` as its value.          |
| `${VAR-STRING}`  | If `VAR` is unset, use `STRING` as its value.                   |
| `${VAR:=STRING}` | If `VAR` is empty or unset, set the value of `VAR` to `STRING`. |
| `${VAR=STRING}`  | If `VAR` is unset, set the value of `VAR` to `STRING`.          |
| `${VAR:+STRING}` | If `VAR` is not empty, use `STRING` as its value.               |
| `${VAR+STRING}`  | If `VAR` is set, use `STRING` as its value.                     |
| `${VAR:?STRING}` | Display an error if empty or unset.                             |
| `${VAR?STRING}`  | Display an error if unset.                                      |

#

# 例子

执行下面的例子，如果环境变量中 CONF 的值存在，则取 CONF 的值，否则用默认值 7

```bash
#/bin/bash

a=${CONF:-"7"}
echo $a;
```
