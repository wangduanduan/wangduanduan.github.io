---
title: Mongo DB增删改查命令概要
date: 2018-02-07 09:12:15
tags:
- mongodb
---

# 1 列出并选用
## 1.1 列出所有数据库

```
> show dbs 
local   0.000GB
myblog  0.000GB
```

## 1.2 使用某个数据库

```
> use myblog
switched to db myblog
```

## 1.3 列出所有集合

```
> show collections
articles
replicationColletion
sessions
users
wangduanduan
```

# 2 插入数据 insert(value)

```
// 在已经存在的集合中插入数据
> db.users.insert({name:'hh',age:23})
Inserted 1 record(s) in 43ms

// 在不存在的集合中插入数据,集合不存在则自动创建集合并插入
> db.students.insert({name:'hh',age:23})
Inserted 1 record(s) in 72ms
```

# 3 查询 find(option)

## 3.1 查询集合里所有的文档
```
> db.users.find()
/* 1 */
{
    "_id" : ObjectId("583e908453be942d0c5419dc"),
    "login_name" : "wangduanduan",
    "password" : "wrong age"
}

/* 2 */
{
    "_id" : ObjectId("583ed2a5cc9a937db049616d"),
    "login_name" : "hh",
    "password" : "sdfsdf"
}

/* 3 */
{
    "_id" : ObjectId("583fb2e9b12f8b7a7aa37572"),
    "name" : "wangduanduan",
    "age" : 34.0
}

/* 4 */
{
    "_id" : ObjectId("583fb707b12f8b7a7aa37573"),
    "name" : "hh",
    "age" : 23.0
}
```

## 3.2 按条件查询文档
```
> db.users.find({name:'wangduanduan'})
/* 1 */
{
    "_id" : ObjectId("583fb2e9b12f8b7a7aa37572"),
    "name" : "wangduanduan",
    "age" : 34.0
}
```
`注意`
```
// 这是错的，查不到结果
> db.users.find({_id:'583fb2e9b12f8b7a7aa37572'})
Fetched 0 record(s) in 1ms


// 这是正确的
> db.users.find({_id:ObjectId('583fb2e9b12f8b7a7aa37572')})
/* 1 */
{
    "_id" : ObjectId("583fb2e9b12f8b7a7aa37572"),
    "name" : "wangduanduan",
    "age" : 34.0
}
```

## 3.3 查询集合内文档的个数
```
> db.users.count()
4
```

## 3.4 比较运算符
- $gt: 大于
- $gte: 大于等于
- $lt: 小于
- $lte: 小于等于
- $ne: 不等于

```
// 查询用户里年龄大于30岁的人， 其他条件以此类推
> db.user.find({age:{$gt:30}})

/* 1 */
{
    "_id" : ObjectId("583fb2e9b12f8b7a7aa37572"),
    "name" : "wangduanduan",
    "age" : 34.0
}
```

## 3.5 逻辑运算符
### 3.5.1 与
```
// 查询名字是wangduanduan,age=34的用户
> db.users.find({name:'wangduanduan',age:34})
/* 1 */
{
    "_id" : ObjectId("583fb2e9b12f8b7a7aa37572"),
    "name" : "wangduanduan",
    "age" : 34.0
}
```
### 3.5.2 $in 或
```
// 查询名字是wangduanduan,或hh的用户
> db.users.find({name:{$in:['wangduanduan','hh']}})
/* 1 */
{
    "_id" : ObjectId("583fb2e9b12f8b7a7aa37572"),
    "name" : "wangduanduan",
    "age" : 34.0
}
```

### 3.5.3 $nin 非
```
// 查询名字不是wangduanduan或者hh的用户
> db.users.find({name:{$nin:['wangduanduan','hh']}})
/* 1 */
{
    "_id" : ObjectId("583e908453be942d0c5419dc"),
    "login_name" : "wangduanduan",
    "password" : "wrong age"
}

/* 2 */
{
    "_id" : ObjectId("583ed2a5cc9a937db049616d"),
    "login_name" : "hh",
    "password" : "sdfsdf"
}
```

## 3.6 正则匹配
```
// 查询名字是中含有duan的用户
> db.users.find({name:/duan/})
/* 1 */
{
    "_id" : ObjectId("583fb2e9b12f8b7a7aa37572"),
    "name" : "wangduanduan",
    "age" : 34.0
}

/* 2 */
{
    "_id" : ObjectId("583fc919b12f8b7a7aa37575"),
    "name" : "wangduanduan",
    "age" : 45.0
}
```


## 3.7 大招$where
```
// 返回含有login_name字段的文档
db.getCollection('users').find({$where:function(){
    return !!this.login_name;
}})
```


# 4 更新 update();

## 4.1 整体更新
```
> db.users.update({login_name:'wangduanduan'},{name:'heihei',age:34})
Updated 1 existing record(s) in 116ms
```


## 4.2 $set 局部更新
```
// 只是将用户年龄设置成101
> db.users.update({name:'wangduanduan'},{$set:{age:101}})

```
## 4.3 $inc 
```
// 将用户年龄增加1岁，如果文档没有age这个字段，则会增加这个字段
> db.users.update({name:'wangduanduan'},{$inc:{age:1}})
```
## 4.3 upsert操作
```
// 如果查不到文档，则增加文档
> db.users.update({name:'nobody'},{$inc:{age:1}},true)
Updated 1 new record(s) in 3ms

/* 6 */
{
    "_id" : ObjectId("583fd20f2cfa6a4817c4171c"),
    "name" : "nobody",
    "age" : 1.0
}
```
## 4.4 批量更新
```
// upadate 的第四个参数设置成true的时候，就会批量更新
> db.users.update({name:'wangduanduan'},{$set:{age:1891}},false,true)
```

# 5 删除
```
// 删除某些文档
db.person.remove({"name":"joe"})

// 删除整个集合
db.person.remove()
```