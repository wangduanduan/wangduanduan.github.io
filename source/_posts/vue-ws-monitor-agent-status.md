---
title: Vue+websocket+stompjs 实时监控坐席状态demo
date: 2018-02-07 09:36:49
tags:
- Vue
- WebSocket
- stompjs
---

由于是前后端分离的demo, 程序的后端我不管，我只负责把前端做好，这只是个demo， 还有很多不完善的地方。

2018-01-09新增：
后端的MQ事件结构现在也改了，该demo只能看看了。

html
```
<!DOCTYPE html>
<html lang="zh-cn">
<head>
	<meta charset="utf-8">
	<link href="http://cdn.bootcss.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<table class="table" id="event-queue">
	<thead>
		<tr>
			<th>当前状态</th>
			<th>状态改变时间</th>
			<th>姓名</th>
			<th>工号</th>
			<th>分机号</th>
			<th>对方号码</th>
			<th>呼入数</th>
			<th>呼出数</th>
		</tr>
	</thead>
	<tbody>
		<tr v-for="item in eventQueue">
			<td>{{item.agentStatus | transAgentStatus}}</td>
			<td>{{item.agentStatusTime}}</td>
			<td>{{item.userName}}</td>
			<td>{{item.loginName}}</td>
			<td>{{item.deviceId}}</td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
	</tbody>
</table>


	<script src="http://cdn.bootcss.com/vue/1.0.26/vue.js"></script>
	<script src="js/websocket-suport.min.js"></script>
	<script src="js/main.js"></script>
</body>
</html>
```

js
```
var tm = (function(){
	var App = function(){};
	var app = App.prototype;
	var config = {
		dest: 'http://xxx.xxx.xxx.xxx:58080/mvc/stomp',
		topic: '/topic/csta/namespace/testwdd2.com'
		// topic: '/topic/csta/device/8002@testwdd2.com'
	};


	var eventQueue = [];
	var vm = new Vue({
		el:'#event-queue',
		data:{
			eventQueue: eventQueue
		}
	});

	Vue.filter('transAgentStatus', function(status){
		switch(status){
			case 'NotReady': return '未就绪';
			case 'WorkNotReady': return '话后处理状态';
			case 'Idle': return '就绪';
			case 'OnCallIn': return '呼入通话';
			case 'OnCallOut': return '呼出通话';
			case 'Logout': return '登出';
			case 'Ringing': return '振铃';
			case 'OffHook': return '摘机';
			case 'CallInternal': return '内部通话';
			case 'Dailing': return '外线已经振铃';
			case 'Ringback': return '回铃';
			case 'Conference': return '会议';
			case 'OnHold': return '保持';
			case 'Other': return '其他';
		}

		return '';
	});

	/**
	 * [render description]
	 * @Author   Wdd
	 * @DateTime 2016-12-26T16:06:16+0800
	 * @param    {[string]} tpl [模板字符串]
	 * @param    {[object]} data [data对象]
	 * @return   {[string]} [渲染后的字符串]
	 */
	app.render = function(tpl,data){
        var re = /{{([^}]+)?}}/g;

        while(match = re.exec(tpl)){
            tpl = tpl.replace(match[0],data[match[1]] || '');
        }

        return tpl;
    };

	app.initWebSocket = function(dest, topic){
		dest = dest || config.dest;
		topic = topic || config.topic;

		var socket = new SockJS(dest);
		var ws = Stomp.over(socket);

		ws.connect({}, function(frame) {

		    ws.subscribe(topic, function(event) {
		        // var eventInfo = JSON.parse(event.body);
		        app.handerEvent(JSON.parse(event.body));
		    });
		}, function(frame) {

		    console.log(frame);
		    console.error(new Date() + 'websocket失去连接');
		});
	};

	/**
	 * [findAgentIndex description]
	 * @Author   Wdd
	 * @DateTime 2016-12-28T10:34:13+0800
	 * @param    {[string]} agentId [description]
	 * @return   {[int]} [description]
	 */
	app.findAgentIndex = function(agentId){
		for(var i = eventQueue.length - 1; i >= 0; i--){
			if(eventQueue[i].agentId === agentId){
				return i;
			}
		}

		return -1;
	};

	/**
	 * [handerEvent 处理websocket事件]
	 * @Author   Wdd
	 * @DateTime 2016-12-28T10:33:03+0800
	 * @param    {[object]} data [description]
	 * @return   {[type]} [description]
	 */
	app.handerEvent = function(data){
		if(data.eventType === 'CallEvent'){
			return;
		}
		if(!data.eventSrc){
			return;
		}

		var eventItem = {
			agentStatus: '',
			eventName: data.eventName,
			agentId: '',
			loginName: '',
			userName: '',
			deviceId: data.deviceId,
			agentStatusTime: ''
		};

		var agent = data.eventSrc.agent || '';

		if(agent){
			eventItem.agentId = agent.agentId;
			eventItem.loginName = agent.loginName;
			eventItem.userName = agent.userName;
			eventItem.agentStatus = agent.agentStatus;
			eventItem.agentStatusTime = agent.agentStatusTime;
		}
		// 针对登出事件的agentId在外层
		else if(data.agentMode){
			eventItem.agentStatus = data.agentMode;
			eventItem.agentId = data.agentId;
		}
		else if(data.agentStatus){
			eventItem.agentStatus = data.agentStatus;
		}

		if(!eventItem.agentId){
			return;
		}

		var itemIndex = app.findAgentIndex(eventItem.agentId);

		// 新的座席加入
		if(itemIndex === -1){
			eventQueue.push(eventItem);
		}
		// 更新已有座席的状态
		else{
			eventQueue[itemIndex].agentStatus = eventItem.agentStatus;
			eventQueue[itemIndex].agentStatusTime = eventItem.agentStatusTime;
			eventQueue[itemIndex].eventName = eventItem.eventName;
		}

	};


	return new App();
})();
```

打开控制台，输入tm.initWebsocket()后，websocket连接正常。
![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180207093803_2QPxWp_Screenshot.jpeg)

之后坐席状态改变，可以看到有事件推送过来。
![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180207093819_vbKAv5_Screenshot.jpeg)


看下整个页面：
![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180207093836_bj5ctf_Screenshot.jpeg)


`最后，这个小小的监控如果用jQuery写，也可以，不过就是太坑了，每次都要去找到Dom元素，再更新DOM，用了Vue这类的框架，页面的dom操作完全不用关心了，真是太舒服了。\(^o^)/`

# 1. 关于stomp的重连
`程序后服务端使用RabbitMQ`
这里我直接引用我的另一个项目的部分代码，这个没有使用SockJS， 直接使用浏览器原生的WebSocket。
重连的原理很简单，就是检测到断开时，去调用我的reconnectWs方法，这里我也做了重连的次数限制。

```
initWebSocket: function(callback, errorCallback) {
            callback = callback || function(){};

            if(ws && ws.connected){
                return;
            }

            Config.isManCloseWs = false;

            var url = Config.wsProtocol + Config.SDK + Config.eventPort + Config.eventBasePath + "/websocket";

            if(typeof WebSocket != 'function'){
                alert('您的浏览器版本太太太老了，请升级你的浏览器到IE11，或使用任何支持原生WebSocket的浏览器');
                return;
            }

            try{
                var socket = new WebSocket(url);
            }
            catch(e){
                console.log(e);
                return;
            }


            var wsHeartbeatId = '';

            ws = Stomp.over(socket);

            if(!Config.useWsLog){
                ws.debug = null;
            }

            ws.connect({}, function(frame) {

                Config.currentReconnectTimes = 0;

                var dest = Config.newWsTopic + env.loginId.replace(/\./g,'_');

                var lastEventSerial = '';

                ws.subscribe(dest, function(event) {
                    var eventInfo = {};

                    try{
                        eventInfo = JSON.parse(event.body);
                        delete eventInfo.params;
                        delete eventInfo._type;
                        delete eventInfo.topics;
                    }
                    catch(e){
                        console.log(e);
                        return;
                    }

                    if(lastEventSerial === eventInfo.serial){
                        util.error('Error: event repeat sent !');
                        return;
                    }
                    else{
                        lastEventSerial = eventInfo.serial;
                    }

                    if(Config.useEventLog){
                        util.debugout.log(' ' + JSON.stringify(eventInfo));
                    }

                    eventHandler.deliverEvent(eventInfo);
                });
                callback();

            }, function(frame) {
                // websocket upexpected disconnected
                // maybe network disconnection, or browser in offline
                // this condition will emit wsDisconnected event
                if(Config.isManCloseWs){return;}
                errorCallback();

                util.log(frame);
                util.error(new Date() + 'websocket disconnect');
                // clearInterval(wsHeartbeatId);

                if(Config.currentReconnectTimes < Config.maxReconnectTimes){
                    Config.currentReconnectTimes++;
                    util.reconnectWs();
                }
                else{
                    var errorMsg = {
                        eventName: 'wsDisconnected',
                        msg: 'websocket disconnect'
                    };
                    wellClient.ui.main({
                        eventName:'wsDisconnected'
                    });
                    util.debugout.log('>>> websocket disconnect');

                    wellClient.triggerInnerOn(errorMsg);
                }
            });
        },

        reconnectWs: function(){
            setTimeout(function(){
                util.log('>>> try to reconnect');
                util.debugout.log('>>> try to reconnect');
                util.initWebSocket(function(){},function(){});

            }, Config.timeout * 1000);
        },
```

# 2. 参考
- [STOMP Over WebSocket](http://jmesnil.net/stomp-websocket/doc/)

  [1]: /img/bVHuvW
  [2]: /img/bVHuwt
  [3]: /img/bVHuwV