---
title: "Taskwarrior 命令行下的专业TodoList神器"
date: "2021-03-25 09:09:01"
draft: false
---


# 简介
Taskwarrior是命令行下的todolist, 特点是快速高效且功能强大，

- 支持项目组
- 支持燃烧图
- 支持各种类似SQL的语法过滤
- 支持各种统计报表


# 安装
```sql
sudo apt-get install taskwarrior
```


# 使用说明

## 增加Todo
```sql
task add 分机注册测试 due:today
Created task 1.
```


# 显示TodoList
```bash
➜  ~ task list

ID Age Due        Description      Urg 
 1 5s  2021-03-25 分机注册测试     8.98
```

## 开始一个任务
```bash
➜  ~ task 1 start
Starting task 1 '分机注册测试'.
Started 1 task.
➜  ~ task ls

ID A Due Description     
 1 *  9h 分机注册测试    
```


## 标记完成一个任务
```bash
➜  ~ task 1 done
Completed task 1 '分机注册测试'.
Completed 1 task.

# 任务完成后 task ls将不会显示已经完成的任务
➜  ~ task ls
No matches.

# 可以使用task all 查看所有的todolist
➜  ~ task all 

ID St UUID     A Age  Done Project Due        Description                       
 - C  341a0f48   2min 55s          2021-03-25 分机注册测试
```


## 燃烧图

```bash
# 按天的燃烧图
task burndown.daily
# 按月的燃烧图
task burndown.monthly
# 按周的燃烧图
task burndown.weekly
```

### 日历
```bash
task calendar
```

# 更多介绍
更多好玩的东西，可以去看看官方的使用说明文档 [https://taskwarrior.org/docs/](https://taskwarrior.org/docs/)


# 参考

- [https://taskwarrior.org/](https://taskwarrior.org/)
- 更多命令 [https://taskwarrior.org/docs/commands/](https://taskwarrior.org/docs/commands/)

