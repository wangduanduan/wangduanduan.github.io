---
title: "xmysql 一行命令从任何mysql数据库生成REST API"
date: "2019-08-06 13:56:20"
draft: false
---
github向我推荐这个[xmysql](https://github.com/o1lab/xmysql)时候，我瞟了一眼它的简介`One command to generate REST APIs for any MySql Database`, 说实话这个介绍让我眼前一亮，想想每次向后端的同学要个接口的时候，他们总是要`哼哧哼哧`搞个半天给才能我。抱着试试看的心态，我试用了一个疗程，oh不是， 是安装并使用了一下。 说实话，体验是蛮不错的，但是体验一把过后，我想不到这个工具的使用场景，因为`你不可能把数据库的所有表都公开出来，让前端随意读写,` 但是试试看总是不错的.

# 1 来吧，冒险一次！
<br />`安装与使用`

| npm install -g xmysqlxmysql -h localhost -u mysqlUsername -p mysqlPassword -d databaseName浏览器打开：http://localhost:3000， 应该可以看到一堆json |
| :--- |


# 2 特点

- 产生REST Api从任何mysql 数据库 🔥🔥
- 无论主键，外键，表等的命名规则如何，都提供API 🔥🔥
- 支持复合主键 🔥🔥
- REST API通常使用：CRUD，List，FindOne，Count，Exists，Distinct<br />批量插入，批量删除，批量读取 🔥
- 关联表
- 翻页
- 排序
- 按字段过滤 🔥
- 行过滤 🔥
- 综合功能
- Group By, Having (as query params) 🔥🔥
- Group By, Having (as a separate API) 🔥🔥
- Multiple group by in one API 🔥🔥🔥🔥
- Chart API for numeric column 🔥🔥🔥🔥🔥🔥
- Auto Chart API - (a gift for lazy while prototyping) 🔥🔥🔥🔥🔥🔥
- XJOIN - (Supports any number of JOINS) 🔥🔥🔥🔥🔥🔥🔥🔥🔥
- Supports views
- Prototyping (features available when using local MySql server only)
- Run dynamic queries 🔥🔥🔥
- Upload single file
- Upload multiple files
- Download file

# 3 API 概览
| HTTP Type | API URL | Comments |
| :--- | :--- | :--- |
| GET | / | Gets all REST APIs |
| GET | /api/tableName | Lists rows of table |
| POST | /api/tableName | Create a new row |
| PUT | /api/tableName | Replaces existing row with new row |
| POST :fire: | /api/tableName/bulk | Create multiple rows - send object array in request body |
| GET :fire: | /api/tableName/bulk | Lists multiple rows - /api/tableName/bulk?_ids=1,2,3 |
| DELETE :fire: | /api/tableName/bulk | Deletes multiple rows - /api/tableName/bulk?_ids=1,2,3 |
| GET | /api/tableName/:id | Retrieves a row by primary key |
| PATCH | /api/tableName/:id | Updates row element by primary key |
| DELETE | /api/tableName/:id | Delete a row by primary key |
| GET | /api/tableName/findOne | Works as list but gets single record matching criteria |
| GET | /api/tableName/count | Count number of rows in a table |
| GET | /api/tableName/distinct | Distinct row(s) in table - /api/tableName/distinct?_fields=col1 |
| GET | /api/tableName/:id/exists | True or false whether a row exists or not |
| GET | [/api/parentTable/:id/childTable](https://wdd.js.org/readme-of-xmysql.html#relational-tables) | Get list of child table rows with parent table foreign key |
| GET :fire: | [/api/tableName/aggregate](https://wdd.js.org/readme-of-xmysql.html#aggregate-functions) | Aggregate results of numeric column(s) |
| GET :fire: | [/api/tableName/groupby](https://wdd.js.org/readme-of-xmysql.html#group-by-having-as-api) | Group by results of column(s) |
| GET :fire: | [/api/tableName/ugroupby](https://wdd.js.org/readme-of-xmysql.html#union-of-multiple-group-by-statements) | Multiple group by results using one call |
| GET :fire: | [/api/tableName/chart](https://wdd.js.org/readme-of-xmysql.html#chart) | Numeric column distribution based on (min,max,step) or(step array) or (automagic) |
| GET :fire: | [/api/tableName/autochart](https://wdd.js.org/readme-of-xmysql.html#autochart) | Same as Chart but identifies which are numeric column automatically - gift for lazy while prototyping |
| GET :fire: | [/api/xjoin](https://wdd.js.org/readme-of-xmysql.html#xjoin) | handles join |
| GET :fire: | [/dynamic](https://wdd.js.org/readme-of-xmysql.html#run-dynamic-queries) | execute dynamic mysql statements with params |
| GET :fire: | [/upload](https://wdd.js.org/readme-of-xmysql.html#upload-single-file) | upload single file |
| GET :fire: | [/uploads](https://wdd.js.org/readme-of-xmysql.html#upload-multiple-files) | upload multiple files |
| GET :fire: | [/download](https://wdd.js.org/readme-of-xmysql.html#download-file) | download a file |
| GET | /api/tableName/describe | describe each table for its columns |
| GET | /api/tables | get all tables in database |


# 3 更多资料

- 项目地址：[https://github.com/o1lab/xmysql](https://github.com/o1lab/xmysql)

