---
title: "influxdb HTTP 接口学习"
date: "2019-12-05 11:12:33"
draft: false
---
# 

# 查询某个字段

```sql
q=SELECT real_used_size FROM opensips WHERE  time > '2019-12-05T00:10:00Z'
```

正常查询结果，下面是例子，和上面的sql没有关系。

:::warning
时间必须用单引号括起来，不能用双引号，格式也必须是YYYY-MM-DDTHH:MM:SSZ
:::

```sql
{
    "results": [
        {
            "statement_id": 0,
            "series": [
                {
                    "name": "cpu_load_short",
                    "columns": [
                        "time",
                        "value"
                    ],
                    "values": [
                        [
                            "2015-01-29T21:55:43.702900257Z",
                            2
                        ],
                        [
                            "2015-01-29T21:55:43.702900257Z",
                            0.55
                        ],
                        [
                            "2015-06-11T20:46:02Z",
                            0.64
                        ]
                    ]
                }
            ]
        }
    ]
}
```

如果有报错，数组项中的某一个会有error属性，值为报错原因

```sql
{
"results":[
  {
  "statement_id": 0,
  "error": "invalid operation: time and *influxql.StringLiteral are not compatible"
  }
]
}
```



# 批次查询

语句之间用分号隔开

```sql
q=SELECT real_used_size FROM opensips WHERE  time > '2019-12-05T00:10:00Z';SELECT real_used_size FROM opensips WHERE  time > '2019-12-09T00:10:00Z'
```
返回结果中的statement_id就表示对应的语句

```sql
{
    "results": [
        {
            "statement_id": 0,
            "series": [
                {
                    "name": "cpu_load_short",
                    "columns": [
                        "time",
                        "value"
                    ],
                    "values": [
                        [
                            "2015-01-29T21:55:43.702900257Z",
                            2
                        ],
                        [
                            "2015-01-29T21:55:43.702900257Z",
                            0.55
                        ],
                        [
                            "2015-06-11T20:46:02Z",
                            0.64
                        ]
                    ]
                }
            ]
        },
        {
            "statement_id": 1,
            "series": [
                {
                    "name": "cpu_load_short",
                    "columns": [
                        "time",
                        "count"
                    ],
                    "values": [
                        [
                            "1970-01-01T00:00:00Z",
                            3
                        ]
                    ]
                }
            ]
        }
    ]
}
```



# 查询结果 按分钟求平均值

```sql
q=SELECT MEAN(real_used_size) FROM opensips WHERE time > '2019-12-05T03:10:00Z' GROUP BY time(1m)
```


# 其他查询参数

| chunked=[true &#124; |  |  |
| --- | --- | --- |
| db=<database_name> |  |  |
| epoch=[ns,u,µ,ms,s,m,h] |  |  |
| p=<password> |  |  |
| pretty=true |  |  |
| q=<query> |  |  |
| u=<username> |  |  |




# 参考教程

- 报错处理 [https://docs.influxdata.com/influxdb/v1.7/troubleshooting/errors/](https://docs.influxdata.com/influxdb/v1.7/troubleshooting/errors/)
- 数据查询 [https://docs.influxdata.com/influxdb/v1.6/guides/querying_data/](https://docs.influxdata.com/influxdb/v1.6/guides/querying_data/)
- 函数 [https://docs.influxdata.com/influxdb/v1.7/query_language/functions/](https://docs.influxdata.com/influxdb/v1.7/query_language/functions/)

