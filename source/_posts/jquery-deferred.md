---
title: 熟练使用使用jQuery Promise (Deferred)
date: 2018-01-29 13:43:23
tags:
- jQuery
---

# 1 情景再现

以前用nodejs写后端程序时，遇到`Promise`这个概念，这个东西好呀！不用谢一层一层回调，直接用类似于jQuery的连缀方式。后来遇到`bluebird`这个库，它就是Promise库中很有名的。我希望可以把Promise用在前端的`ajax`请求上，但是我不想又引入bluebird。后来发现，jquery本身就具有类似于Promise的东西。于是我就jquery的Promise写一些异步请求。

# 2 不堪回首

看看一看我以前写异步请求的方式
```
// 函数定义
function sendRequest(req,successCallback,errorCallback){
    $.ajax({
        ...
        ...
        success:function(res){
            successCallback(res);
        },
        error:function(res){
            errorCallback(res);
        }
    });
}

// 函数调用,这个函数的匿名函数写的时候很容易出错，而且有时候难以理解
sendRequest(req,function(res){
    //请求成功
    ...
},function(res){
    //请求失败
    ...
});
```

# 3 面朝大海

下面是我希望的异步调用方式
```
sendRequest(req)
.done(function(res){
    //请求成功
    ...
})
.fail(function(req){
    //请求失败
    ...
});
```

# 4 废话少说，放‘码’过来
> talk is cheap, show me the code

```
// 最底层的发送异步请求，做成Promise的形式

App.addMethod('_sendRequest',function(path,method,payload){
    var dfd = $.Deferred();
    $.ajax({
        url:path,
        type:method || "get",
        headers:{
            sessionId:session.id || ''
        },
        data:JSON.stringify(payload),
        dataType:"json",
        contentType : 'application/json; charset=UTF-8',
        success:function(data){
            dfd.resolve(data);
        },
        error:function(data){
            dfd.reject(data);
        }
    });
    return dfd.promise();
});

//根据callId查询录音文件，不仅仅是异步请求可以做成Promise形式，任何函数都可以做成Promise形式
App.addMethod('_getRecordingsByCallId',function(callId){
    var dfd = $.Deferred(),
        path = '/api/tenantcalls/'+callId+'/recordings';

    App._sendRequest(path)
    .done(function(res){dfd.resolve(res);})
    .fail(function(res){dfd.reject(res);});

    return dfd.promise();
});

// 获取录音
App.addMethod('getCallDetailRecordings',function(callId){
    App._getRecordingsByCallId(callId)
    .done(function(res){
        // 获取结果后渲染数据
        App.renderRecording(res);
    })
    .fail(function(res){
        App.error(res);
    });
});
```

# 5 注意事项
- jQuery的Promise主要是用了jQquery的$.Derferred()方法，一些老版本的jquery并不支持此方法。
- jQuery版本必须大于等于1.5，推荐使用1.11.3

# 6 参考文献
 
 - [jquery官方api文档](http://api.jquery.com/)
 - [jquery维基百科文档](https://en.wikipedia.org/wiki/JQuery)


# 7 最后
以上文章仅供参考，不包完全正确。欢迎评论，3q。


