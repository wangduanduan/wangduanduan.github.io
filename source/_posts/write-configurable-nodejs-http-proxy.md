---
title: 手写可配置的express & nodejs的代理
date: 2018-02-09 13:24:35
tags:
- 代理
---

注意：该文章中设置代理的方法存在很大的问题，请不要在使用。这里只作为记录。
非常推荐你使用[http-proxy-middleware](https://github.com/chimurai/http-proxy-middleware)，作为生产环境代理的包。你可以看我的这篇文章，里面有一个非常小巧的写法，可以实现各种代理的方法。
关于该文章中设置代理会产生的问题，在这篇文章中我会做详细的说明。

nodejs比较好的代理包有：[node-http-proxy](https://github.com/nodejitsu/node-http-proxy)和[http-proxy-middleware](https://github.com/chimurai/http-proxy-middleware)。这两个我都用过，它们的优点自不用说，只说说缺点：`它们不能从配置文件里读取代理配置。每添加一个拦截路径都需要多加一个接口调用。`

![](http://p3alsaatj.bkt.clouddn.com/20180209132526_lgeTcJ_bVVFlt.jpeg)

所以，我需要自己写一个http代理，要包含一下功能：

1. 从配置文件里读取代理配置
2. 可以路径重写

这样做的好处是：`新增服务只需要在配置文件上加上该服务，无需修改业务逻辑`

# 1. /config/default.js
```
module.exports = {
	"ENV":"dev",
	"PORT":"8088",

	"maxAge": 10,

	"proxy":{
		"olap":{
			"host":"172.16.200.225",
			"port":"8092",
			"form":"",
			"to":""
		},
		"qc":{
			"host":"192.168.40.231",
			"port":"30088"
		},
		"api":{
			"host":"192.168.40.231",
			"port":"30412"
		},
		"ocm":{
			"host": process.env.ocm_host || "192.168.40.119",
			"port": process.env.ocm_port || "31003"
		}
	}
}
```
# 2. /app.js
将所有要走代理的路径前必需加上 `/p`, 这个是我的个人配置，当然也可以是其他的名字。

```
var express = require('express');
var compression = require('compression');
var path = require('path');
var config = require('config');
var log4js = require('log4js');
var wsProxyConfig = config.get('proxy');

var routes = require('./routes/index');
var views = require('./routes/views');
var proxy = require('./routes/proxy');


app.use('/p',proxy);
```

# 3. /routes/proxy.js
```
var express = require('express');
// config是一个第三方包，它的功能是
// 自动根据环境变量帮你读取config目录下
// 的配置文件，默认会读取default.json，
// config支持很多文件类型。
var config = require('config');
var request = require('request');
var log4js = require('log4js');
var path = require('path');

var router = express.Router();
// 此处就是获取配置文件的proxy项了
var proxyConfig = config.get('proxy');

// 这里记录代理的日志
log4js.configure({
  appenders: [
    {
    	type: 'file',
    	filename: './logs/all-proxy-logs.log',
    	maxLogSize: 10*1024*1024, //max 10mb
    	backups: 5,
    	compress: true
    },
    {
    	type: 'stdout'
    }
  ]
});
var logger = log4js.getLogger('proxy');


router.all('/:apiName/*', function(req, res, next) {
 	// apiName 必需要对应配置文件的proxy的属性名
 	var apiName = req.params.apiName;

 	if(!apiName){
 		res.status(404).end('api not found');
 	}
    
    // 如果apiName不在配置文件里，则报500
 	else if(!proxyConfig[apiName]){
 		res.status(500).end('api has no config');
 	}

 	else{
 	    // originUrl是原始的url
 	    // 例如 /p/qc/calls
 		var originalUrl = req.originalUrl;
	 	var api = proxyConfig[apiName];
	 	var url = originalUrl.replace('/p','');

	 	url = `http://${api.host}:${api.port}` + url;
        
        // 某些需要路径重写的地方
	 	if(api.form && api.to){
	 		url = url.replace(api.form, api.to);
	 	}
        
        // 必须要删除这个host
        // 因为本地测试时，这个host是localhost
        // 这会导致服务端报错
	 	delete req.headers.host;
        
        // 修改好的请求头
	 	var option = {
	 		url: url,
	 		headers: req.headers
	 	};
        
        // 使用request发起请求
	 	var proxy = request(option);
	 	// 此处是关键，将请求流写入代理，将代理的响应写入原始响应
	 	req.pipe(proxy);
	 	proxy.pipe(res);
        
        // 代理结束响应时，原始请求结束，并输出日志
	 	proxy.on('end', function(){
	 		var log = `${req.method} ${res.statusCode} ${req.originalUrl} ---> ${option.url} ${req.headers.sessionid}`;

	 		if(res.statusCode < 400){
	 			logger.info(log);
	 		}
	 		else{
	 			logger.error(log);
	 		}

	 		res.end();
	 	});
 	}

});

module.exports = router;

```

# 4. 相关第三方模块
- [node-config](https://github.com/lorenwest/node-config)
- [request](https://github.com/request/request)
- [log4js-node](https://github.com/nomiddlename/log4js-node)


  [1]: /img/bVVFlt