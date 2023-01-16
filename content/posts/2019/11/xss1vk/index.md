---
title: "Mysql计划任务：Event Scheduler"
date: "2019-11-13 13:09:46"
draft: false
---
从MySql5.1.6增加计划任务功能


# 判断计划任务是否启动

```sql
SHOW VARIABLES LIKE 'event_scheduler'
```

# 开启计划任务

```sql
set global event_scheduler=on
```


# 创建计划任务

```sql
create test_e on scheduler every 1 day do sql
```


# 修改计划任务

```sql
# 临时关闭事件
ALTER EVENT e_test DISABLE;

# 开启事件
ALTER EVENT e_test ENABLE;

# 将每天清空test表改为5天清空一次
ALTER EVENT e_test ON SCHEDULE EVERY 5 DAY;
```


# 删除计划任务

```sql
drop event e_test
```


