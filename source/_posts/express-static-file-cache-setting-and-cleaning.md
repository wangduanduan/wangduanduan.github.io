---
title: Express静态文件浏览器缓存设置与缓存清除
date: 2018-04-08 09:00:48
tags:
- Express
- 静态文件
- 浏览器缓存
---

# 1. Express设置缓存

Express设置静态文件的方法很简单，一行代码搞定。`app.use(express.static(path.join(__dirname, 'public'), {maxAge: MAX_AGE}))`,
注意MAX_AGE的单位是毫秒。这句代码的含义是让pulic目录下的所有文件都可以在浏览器中缓存，过期时长为MAX_AGE毫秒。

```
app.use(express.static(path.join(__dirname, 'public'), {maxAge: config.get('maxAge')}))
```

# 2. Express让浏览器清除缓存

缓存的好处是可以更快的访问服务，但是缓存也有坏处。例如设置缓存为10天，第二天的时候服务更新了。如果客户端不强制刷新页面的话，浏览器会一致使用更新前的静态文件，这样会导致一些BUG。你总当每次出问题时，客户打电话给你后，你让他强制刷新浏览器吧？

所以，最好在服务重启后，重新让浏览器获取最新的静态文件。

设置的方式是给每一个静态文件设置一个时间戳。

例如：`vendor/loadjs/load.js?_=123898923423"></script>`，这种形势。

## 2.1. Express 路由

```
// /routes/index.js
router.get('/home', function (req, res, next) {
  res.render('home', {config: config, serverStartTimestamp: new Date().getTime()})
})
```

## 2.2. 视图文件

```
// views/home.html
<script src="vendor/loadjs/load.js?_=<%= serverStartTimestamp %>"></script>
```

设置之后，每次服务更新或者重启，浏览器都会使用最新的时间戳serverStartTimestamp，去获取静态文件。

## 2.3. 动态加载JS文件

有时候js文件并不是直接在HTML中引入，可能是使用了一些js文件加载库，例如requirejs, LABjs等。这些情况下，可以在全局设置环境变量SERVER_START_TIMESTAMP，用来表示服务启动的时间戳，在获取js的时候，将该时间戳拼接在路径上。

注意：`环境变量SERVER_START_TIMESTAMP，一定要在其他脚本使用前定义。`

```
// views/home.html
<script>
  var SERVER_START_TIMESTAMP = <%= serverStartTimestamp %>
</script>

// load.js
'vendor/contact-center/skill.js?_=' + SERVER_START_TIMESTAMP
```