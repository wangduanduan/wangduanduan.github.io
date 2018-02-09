---
title: nodejs 日志插件比较 VS 自定义日志插件
date: 2018-02-07 13:46:51
tags:
---

# 1. [morgan](https://github.com/expressjs/morgan)
- 【优点】morgan配置非常简单
- 【优点】支持自定义日志格式
- 【优点】支持日志分机
- 【优点】支持日志压缩：使用[rotating-file-stream](https://github.com/iccicci/rotating-file-stream)
- 【缺点】无法同时往console和文件中写日志

# 2. [log4js-node](https://github.com/nomiddlename/log4js-node)
- 【优点】配置简单
- 【优点】支持同时往控制台和文件中写数据
- 【优点】支持按照时间或文件大小分割文件
- 【优点】支持文件压缩
```
"use strict";
var path = require('path')
, log4js = require('../lib/log4js');

log4js.configure(
  {
    appenders: [
      {
        type: "file",
        filename: "important-things.log",
        maxLogSize: 10*1024*1024, // = 10Mb
        numBackups: 5, // keep five backup files
        compress: true, // compress the backups
        encoding: 'utf-8',
        mode: parseInt('0640', 8),
        flags: 'w+'
      },
      {
        type: "dateFile",
        filename: "more-important-things.log",
        pattern: "yyyy-MM-dd-hh",
        compress: true
      },
      {
        type: "stdout"
      }
    ]
  }
);

var logger = log4js.getLogger('things');
logger.debug("This little thing went to market");
logger.info("This little thing stayed at home");
logger.error("This little thing had roast beef");
logger.fatal("This little thing had none");
logger.trace("and this little thing went wee, wee, wee, all the way home.");
```

# 3. [winston](https://github.com/winstonjs/winston)
- 没用过，不做评论

# 4. [fluent-logger-node](https://github.com/fluent/fluent-logger-node)
- 往fluntd中写日志，没用过

# 5. [express-winston](https://github.com/bithavoc/express-winston)
- 没用过

# 6. 如何自定义一个日志插件
- 可以自定义日志结构
- 日志文件可以用gzip压缩
- 不影响往console写日志
- 可以按时间分割日志
- 支持日志覆盖，最多保留1个月的备份

使用[rotating-file-stream](https://github.com/iccicci/rotating-file-stream)
```
var path = require('path');
var fs = require('fs');
var rfs = require('rotating-file-stream');

var logDirectory = __dirname;

function Wpad(num) {
    return (num > 9 ? "" : "0") + num;
}


/**
 * [Wgenerator 创建文件名函数]
 * @Author   Wdd
 * @DateTime 2017-02-22T10:13:39+0800
 * 日志会保留一个月的：因为日志文件名是只使用日期，9月8号的日志就会覆盖8月8号的日志
 * 文件的格式是gzip
 * 文件名例如：22-log.gizp
 */
function Wgenerator(time, index) {
    if(! time){
        return "temp-log.txt.gzip";
    }

    return "/storage/"+ Wpad(time.getDate()) +"-log.txt.gzip";
}

var accessLogStream = rfs(Wgenerator, {
    interval: '1d', // 周期为1天
    path: logDirectory,
    compress: 'gzip' ,
    rotationTime:true
});

/**
 * [exports description]
 * @Author   Wdd
 * @DateTime 2017-02-22T10:24:06+0800
 * 使用方式：
 * 1. 安装rotating-file-stream
 * 2. 在根目录下创建一个文件夹，例如logs。然后把access-log.js放进去
 * 3. 在app.js中var mylog = require('./logs/access-log');
 * 4. 在app = express(); 后添加一句 app.use(mylog);
 * 5. 日志文件会自动生成在./logs/storage文件夹下面，当天的日志会保存在暂存的./logs/temp-log.gzip里
 */
module.exports = function(req, res, next){

	req._startTime = new Date();

	res.once('finish', function(){

		var msg = "";
		//hostname
		msg = process.env.hostname+" ";

		// 时间
		msg += new Date()+" ";

		// 请求方式
		msg += req.method+" ";

		// 响应状态码
		msg += res.statusCode+" ";

		// sessionId
		msg += req.headers.sessionid+" ";

		// 响应时长
		msg += new Date() - req._startTime ;

		// 请求路径
		msg += " " + req.originalUrl +'\n\r\n\r';

		accessLogStream.write(msg);
	});

	next();
};

```


