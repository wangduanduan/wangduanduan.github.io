---
title: jQuery进阶：用最优雅的方式写ajax请求
date: 2018-02-07 13:42:36
tags:
- ajxa
- jQuery
---

# 1. 首先需要一个配置文件
```
var api = {
	basePath: 'http://192.168.200.226:58080',
	pathList: [
		{
			name: 'agentHeartBeat',
			path:'/api/csta/agent/heartbeat/{{agentId}}/{{type}}/{{something}}',
			method:'get'
		},
		{
			name: 'setAgentState',
			path: '/api/csta/agent/state',
			method: 'post'
		},
		{
			name: 'getAgents',
			path: '/user/agent/{{query}}',
			method: 'get'
		}
	]
}
```

# 2. 然后需要一个方法，把配置文件生成接口
```
function WellApi(Config){
var headers = {};
var Api = function(){};

Api.pt = Api.prototype;

var util = {
	ajax: function(url, method, payload) {
	    return $.ajax({
        	url: url,
        	type: method || "get",
        	data: JSON.stringify(payload),
        	headers: headers,
        	dataType: "json",
        	contentType: 'application/json; charset=UTF-8'
	    });
	},

	/**
	 * [render 模板渲染]
	 * 主要用于将 /users/{{userId}} 和{userId: '89898'}转换成/users/89898，和mastache语法差不多，
	 * 当然我们没必要为了这么小的一个功能来引入一个模板库
	 * query字符串可以当做一个参数传递进来
	 * 例如： /users/{{query}}和{query:'?name=jisika&sex=1'}
	 * @Author   Wdd
	 * @DateTime 2017-03-13T19:42:58+0800
	 * @param    {[type]} tpl [description]
	 * @param    {[type]} data [description]
	 * @return   {[type]} [description]
	 */
	render: function(tpl, data){
		var re = /{{([^}]+)?}}/;
		var match = '';

		while(match = re.exec(tpl)){
		    tpl = tpl.replace(match[0],data[match[1]]);
		}

		return tpl;
	}
};

/**
 * [setHeader 暴露设置头部信息的方法]
 * 有些方法需要特定的头部信息，例如登录之后才能获取sesssionId,然后访问所有的接口时，必须携带sessionId
 * 才可以访问
 * @Author   Wdd
 * @DateTime 2017-03-13T10:34:03+0800
 * @param    {[type]} headers [description]
 */
Api.pt.setHeader = function(headers){
	headers = headers;
};

/**
 * [fire 发送ajax请求，this会绑定到每个接口上]
 * @Author   Wdd
 * @DateTime 2017-03-13T19:42:13+0800
 * @param    {[type]} pathParm [description]
 * @param    {[type]} payload [description]
 * @return   {[type]} [description]
 */
function fire(pathParm, payload){
    var url = util.render(this.path, pathParm);
    return util.ajax(url, this.method, payload);
}


/**
 * [for 遍历所有接口]
 * @Author   Wdd
 * @DateTime 2017-03-13T19:49:33+0800
 * @param    {[type]} var i [description]
 * @return   {[type]} [description]
 */
for(var i=0; i < Config.pathList.length; i++){

    Api.pt[Config.pathList[i].name] = {
        path: Config.basePath + Config.pathList[i].path,
        method: Config.pathList[i].method,
        fire: fire
    };
}

return new Api();
}
```

# 3. 试用一下
```
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title></title>
	<script src="http://cdn.bootcss.com/jquery/1.11.3/jquery.min.js"></script>
	<script src="api.js"></script>
	<script src="jquery-ajax.js"></script>
</head>
<body>

<script type="text/javascript">
	var saas = WellApi(api);

	saas.agentHeartBeat.fire({agentId: '5001@1011.cc', type:'a', something: 'test'})
	.done(function(res){
		console.log('心跳成功');
	})
	.fail(function(res){
		console.log('心跳失败');
	});
    
    // 如果没有参数要渲染到路径上，那个第一个参数可以传空对象
	saas.setAgentState.fire({}, {status: 'Ready'})
	.done(function(res){
		console.log('设置成功');
	})
	.fail(function(res){
		console.log('设置失败');
	});


</script>
</body>
</html>
```

# 4. 注意点
`fire(pathParm, payload)`中的`pathParm`是最终会被渲染到请求的路径里面，而paylaod代表请求体。 

例如：
```
// 路径这么写
/api/{{version}}/agent/{{id}}/{{somethingElse}}

// pathParm这样写
{version: 1, id: '2', somethingElse: 'sss'}

// 最终路径会被渲染成
/api/1/agent/2/sss
```

`path里面不仅仅可放一个变量的`，具体可以参考[mustache](https://github.com/janl/mustache.js)语法，上面代码里的render是以最简单的实现。

# 5. 优点与扩展
- [优点]：类似与promise的回调方式
- [优点]：增加一个接口只是需要增加一个配置文件，很方便
- [扩展]：当前的ajax 的contentType我只写了json，有兴趣可以扩展其他的数据类型
- [缺点]：没有对函数参数进行校验