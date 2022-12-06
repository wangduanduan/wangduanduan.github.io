---
title: "tavern"
date: "2021-05-26 15:46:03"
draft: false
---

# 获取环境变量
```
 Authorization: "Basic {tavern.env_vars.SECRET_CI_COMMIT_AUTH}"
```


# x-www-form-urlencoded

```yaml
    request:
      url: "{test_host}/form_data"
      method: POST
      data:
        id: abc123
```


# 按照name过滤运行测试 -k

This can then be selected with the -k flag to pytest - e.g. pass pytest-kfake to run all tests with ‘fake’ in the name.

比如只运行名称包含fake的测试
```yaml
py.test -k fake
```

