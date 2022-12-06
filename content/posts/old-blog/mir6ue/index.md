---
title: "tavern 测试题目"
date: "2021-06-13 18:58:15"
draft: false
---

# 测试题目


## 1. 测试文件的名称的格式是什么？

> this needs to be in a file called test_x.tavern.yaml, where x should be a description of the contained tests.



## 2. 如何指定测试用例的名称去执行测试用例？

> This can then be selected with the -k flag to pytest - e.g. pass pytest -k fake to run all tests with ‘fake’ in the name.



# 3. 用什么指令来保存http请求的响应体？
> save



# 4. 有哪些判断值类型的关键词？
> - !anyint: Matches any integer
> - !anyfloat: Matches any float (note that this will NOT match integers!)
> - !anystr: Matches any string
> - !anybool: Matches any boolean (this will NOT match null)
> - !anylist: Matches any list
> - !anydict: Matches any dict/’mapping’



# 5. 变量的格式是什么？
> "{some:s}"



# 6. 环境变量如何读取？
> tavern.env_vars.



# 7. 如何获取请求变量
> tavern.request_vars.xxx


## 8. Strict key 是什么含义？

## 9. 如何定义锚点和引用锚点？

# 10. 如何引入外部yaml文件？

## 11. 如何将string类型的参数转为整数类型？
>     an_integer: !int "{my_integer:d}" # Works 



