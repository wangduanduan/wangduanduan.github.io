---
title: 浏览器端数据库存储方案的整理 -- indexDB 和 localStorage
date: 2018-06-02 12:17:17
tags:
- indexDB
---

> 有些安全性不太重要的数据，我不想花大力气搞一台服务器，再安装mysql或者 monogdb，再写点rest接口。这也太麻烦了，浏览器里本来就有很好用的数据库。你为什么不尝试一下呢？

# 1. 客户端存储目前有两个方案比较

方案 | 优点 | 缺点
--- | --- | ---
localStorage | 简单易用，同步操作 | 存储容量小，一般不超过10MB
indexDB | 接口都是异步的，操作不便 | 容量比localStorage大

如果要使用localStorage，那么存储量比较小。如果是用indexDB，那么最好找点开源库，直接封装友好的API, 来方便我们使用indexDB。

下面介绍一些很好用的的库。


# 2. 简介

## 2.1. localForage

- `离线存储， 提供强大的API封装IndexedDB,WebSQL,localStorage`
- 12073 star
- https://github.com/localForage/localForage

```
localforage.setItem('key', 'value', function (err) {
  // if err is non-null, we got an error
  localforage.getItem('key', function (err, value) {
    // if err is non-null, we got an error. otherwise, value is the value
  });
});
```

## 2.2. Dexie.js

- `专业封装 IndexedDB`
- 3040 star
- https://github.com/dfahlander/Dexie.js

```
	const db = new Dexie('MyDatabase');

	// Declare tables, IDs and indexes
	db.version(1).stores({
		friends: '++id, name, age'
	});

  	// Find some old friends
	await db.friends
		.where('age')
		.above(75)
		.toArray();

	// or make a new one
	await db.friends.add({
		name: 'Camilla',
		age: 25,
		street: 'East 13:th Street',
		picture: await getBlob('camilla.png')
	});
```

## 2.3. zangodb

- `给HTML5 IndexedDB 封装类似mongodb类似接口, 如果你熟悉mongodb, 那一定会用zangodb`
- 688 star
- https://github.com/erikolson186/zangodb

```
let db = new zango.Db('mydb', { people: ['age'] });
let people = db.collection('people');

let docs = [
    { name: 'Frank', age: 20 },
    { name: 'Thomas', age: 33 },
    { name: 'Todd', age: 33 },
    { name: 'John', age: 28 },
    { name: 'Peter', age: 33 },
    { name: 'George', age: 28 }
];

people.insert(docs).then(() => {
    return people.find({
        name: { $ne: 'John' },
        age: { $gt: 20 }
    }).group({
        _id: { age: '$age' },
        count: { $sum: 1 }
    }).project({
        _id: 0,
        age: '$_id.age'
    }).sort({
        age: -1
    }).forEach(doc => console.log('doc:', doc));
}).catch(error => console.error(error));
```

## 2.4. JsStore

- `使用类似 sql的接口操作 indexDB`
- 74 star
- https://github.com/ujjwalguptaofficial/JsStore

```
var value = {
    column1: value1,
    column2: value2,
    column3: value3,
    ...
    columnN: valueN
};

connection.insert({
    into: "TABLE_NAME",
    values: [Value], //you can insert multiple values at a time

}).then(function(rowsAffected) {
    if (rowsAffected > 0) {
        alert('Successfully Added');
    }
}).catch(function(error) {
    alert(error.message);
});
```

## 2.5. minimongo

- `基于localstorage的浏览器端mongodb数据库`
- 697 star
- https://github.com/mWater/minimongo

```
// Require minimongo
var minimongo = require("minimongo");

var LocalDb = minimongo.MemoryDb;

// Create local db (in memory database with no backing)
db = new LocalDb();

// Add a collection to the database
db.addCollection("animals");

doc = { species: "dog", name: "Bingo" };

// Always use upsert for both inserts and modifies
db.animals.upsert(doc, function() {
	// Success:

	// Query dog (with no query options beyond a selector)
	db.animals.findOne({ species:"dog" }, {}, function(res) {
		console.log("Dog's name is: " + res.name);
	});
});
```

## 2.6. pouchdb

- `基于indexDB的CouchDB-style浏览器端数据库`
- 10599 star
- https://github.com/pouchdb/pouchdb

```
var db = new PouchDB('dbname');

db.put({
  _id: 'dave@gmail.com',
  name: 'David',
  age: 69
});

db.changes().on('change', function() {
  console.log('Ch-Ch-Changes');
});

db.replicate.to('http://example.com/mydb');
```

## 2.7. lowdb

- `小型json数据库，浏览器端基于localStorage, lodash风格的接口，让它非常可爱😊`
- 7997 star
- https://github.com/typicode/lowdb

```
import low from 'lowdb'
import LocalStorage from 'lowdb/adapters/LocalStorage'

const adapter = new LocalStorage('db')
const db = low(adapter)

db.defaults({ posts: [] })
  .write()

// Data is automatically saved to localStorage
db.get('posts')
  .push({ title: 'lowdb' })
  .write()
```

# 3. 参考
- [html5-local-storage-revisited](https://www.sitepoint.com/html5-local-storage-revisited/)
- [maximum-item-size-in-indexeddb](https://stackoverflow.com/questions/5692820/maximum-item-size-in-indexeddb)