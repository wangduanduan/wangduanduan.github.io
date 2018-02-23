---
title: PyMongo学习笔记
date: 2018-02-22 16:32:39
tags:
- python
- pymongo
- mongodb
---

# 1. 环境
- mongodb 3.4
- pymongo 3.6.0
- macOS

# 2. 安装pymongo
```
pip3 install pymongo
```

# 3. 建立数据库链接
```
from pymongo import MongoClient

conn = MongoClient('localhost', 27017)

// 或者 conn = MongoClient('mongodb://localhost:27017/')
```

# 4. 获取数据库
```
db = conn.db_name // 如果数据库不存在，则自动创建

db = conn['db-name'] // 如果数据库名中有中划线，则需要使用中括号的形式
```

# 5. 获取集合
```
collection = db.test_users // 如果集合不存在，则自动创建

// 或者 collection = db['test-users']
```
注意：只有当数据库或者集合中有数据被插入时，集合才真正被创建。

> An important note about collections (and databases) in MongoDB is that they are created lazily - none of the above commands have actually performed any operations on the MongoDB server. Collections and databases are created when the first document is inserted into them.

# 6. 插入单个文档 insert_one
```
post = {"name":"wangduanduan", "province":"shanghai", "age": 12}
db.collection.inser_one(post)

5a8e90b83617b1a34a06d890 // 插入成功后会返回ObjectId
```

# 7. 查询一个文档 find_one
如果你确定你的查询结果里只有一个，那么最好使用find_one来做查询

```
db.find_one({"name":"wangduanduan"})
```

# 8. 按照ObjectId查询 ObjectId()
ObjectId不是字符串，你绝对不能把它当做字符串来做查询，虽然它看起来像字符串。

```
// good 
db.find_one('_id': ObjectId("5a8e82af3617b1a035d10264"))

// bad 这是查不到结果的
db.find_one('_id': "5a8e82af3617b1a035d10264")
```

# 9. 关于Unicode字符串的注意事项
MongoDB使用[BSON格式](http://bsonspec.org/)来存储数据，而BSON是utf-8编码的，所以pymongo必须要确保字符串是utf-8格式的。

[python3 unicode字符串深入阅读](http://docs.python.org/howto/unicode.html)

# 10. 批量插入 insert_many()
```
db.test_users.insert_many([user1, user2])

[ObjectId1, ObjectId] // 插入成功后会以数组形式返回ObjectId
```

# 11. 条件查询 find()
```
db.test_users.find()
// 返回符合条件的集合
```

# 12. 统计文档数量 count()
```
db.test_users.find().count()
1 // 返回文档的数量
```

# 13. 范围查询
返回查询如大于小于不能与之类的，MongoDB都是支持的，[详情参见](https://docs.mongodb.com/manual/reference/operator/)

例如：查询日期小于2009年11月12号12点的文章，并按照作者排序
```
d = datetime.datetime(2009, 11, 12, 12) // 
posts.find({"date": {"$lt": d}}).sort("author")
```

更多类似与`$lt`之类的用法，可以参考[Query and Projection Operators](https://docs.mongodb.com/manual/reference/operator/query/)

# 14. 索引

以user_id建立索引后，profiles集合就有两个索引了，因为MongoDB自带_id索引。

下面设置的user_id索引，并将其设置成唯一值。
```
result = db.profiles.create_index([('user_id', pymongo.ASCENDING)], unique=True)
sorted(list(db.profiles.index_information()))
[u'_id_', u'user_id_1']
```

如果插入重复的user_id，那么会插入不成功，这个功能可以避免数据重复。

```
>>> new_profile = {'user_id': 213, 'name': 'Drew'}
>>> duplicate_profile = {'user_id': 212, 'name': 'Tommy'}
>>> result = db.profiles.insert_one(new_profile)  # This is fine.
>>> result = db.profiles.insert_one(duplicate_profile)
Traceback (most recent call last):
DuplicateKeyError: E11000 duplicate key error index: test_database.profiles.$user_id_1 dup key: { : 212 }
```

关于索引，可以参考[Indexes](https://docs.mongodb.com/manual/indexes/)

# 15. 参考
- [PyMongo 3.6.0 Documentation](https://api.mongodb.com/python/current/)
- [ObjectId](https://docs.mongodb.com/manual/reference/method/ObjectId/)
- [collection – Collection level operations](https://api.mongodb.com/python/current/api/pymongo/collection.html)
