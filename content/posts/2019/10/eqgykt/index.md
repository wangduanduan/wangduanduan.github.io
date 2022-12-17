---
title: "influxdb http操作"
date: "2019-10-09 16:22:18"
draft: false
---

# 创建数据库

```c
curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE testdb"
```



# 写数据到数据库

```c
curl -i -XPOST 'http://localhost:8086/write?db=mydb' --data-binary 'cpu_load_short,host=server01,region=us-west value=0.64 1434055562000000000'
```


# 批量写入

output.txt
```bash
nginx_second,tag=ip169 value=21 1592638800000000000
nginx_second,tag=ip169 value=32 1592638801000000000
nginx_second,tag=ip169 value=20 1592638802000000000
nginx_second,tag=ip169 value=11 1592638803000000000
```
```bash
curl -i -XPOST 'http://localhost:8086/write?db=mydb' --data-binary @output.txt
```


# 参考

- [https://docs.influxdata.com/influxdb/v1.7/guides/writing_data/](https://docs.influxdata.com/influxdb/v1.7/guides/writing_data/)

