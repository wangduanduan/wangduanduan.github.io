---
title: "我的数据可视化处理过程"
date: "2020-02-16 14:55:15"
draft: false
---

# 数据规整
我的数据来源一般都是来自于日志文件，不同的日志文件格式可能都不相同。所以第一步就是把数据抽取出来，并且格式化。

一般情况下我会用grep或者awk进行初步的整理。如果shell脚本处理不太方便，通常我会写个js脚本。

Node.js的readline可以实现按行取出。处理过后的输出依然是写文件。

```javascript
const readline = require('readline')
const fs = require('fs')
const dayjs = require('dayjs')
const fileName = 'data.log'
const batch = dayjs().format('MMDDHHmmss')
const dist = fs.createWriteStream(`${fileName}.out`)

const rl = readline.createInterface({
  input: fs.createReadStream(fileName)
})

rl.on('line', handlerLine)

function handlerLine (line) {
    let info = line.split(' ')
    let time = dayjs(`2020-${info[0]} ${info[1]}`).valueOf()
    let log = `rtpproxy,tag=b${batch} socket=${info[2]},mem=${info[3]} ${time}000000\n`
    console.log(log)
    dist.write(log)
}
```

输出的文件格式如下，至于为什么是这种格式，且看下文分晓。

```javascript
rtpproxy,tag=b0216014954 socket=691,mem=3106936 1581477499000000000
rtpproxy,tag=b0216014954 socket=615,mem=3109328 1581477648000000000
rtpproxy,tag=b0216014954 socket=669,mem=3113764 1581477901000000000
rtpproxy,tag=b0216014954 socket=701,mem=3114820 1581477961000000000
```


# 数据导入
以前我都会把数据规整后的输出写成一个JSON文件，然后写html页面，引入Echarts库，进行数据可视化。

但是这种方式过于繁琐，每次都要写个Echars的Options。

所以我想，如果把数据写入influxdb，然后用grafana去做可视化，那岂不是十分方便。

所以，我们要把数据导入influxdb。


# 启动influxdb grafana
下面是一个Makefile， 用来启动容器。

1. make create-network 用来创建两个容器的网络，这样grafana就可以通过容器名访问influxdb了。
2. make run-influxdb 启动influxdb，其中8086端口是influxdb对外提供服务的端口
3. make run-grafana 启动grafana, 其中3000端口是grafana对外提供服务的端口

```makefile
run-influxdb:
	docker run -d -p 8083:8083 -p 8086:8086 --network b2 --name influxdb  influxdb:latest
run-grafana:
	docker run -d --name grafana --network b2  -p 3000:3000 grafana/grafana
create-network:
	docker network create -d bridge --ip-range=192.168.1.0/24 --gateway=192.168.1.1 --subnet=192.168.1.0/24 b2
```

4. 接着你打开localhost:3000端口，输入默认的用户名密码 admin/amdin来登录


5. 创建默认的数据库

进入influxb的容器中创建数据库

```makefile
docker exec -it influxdb bash
influx
create database mydb
```

6. grafana中添加influxdb数据源


7. 使用curl上传数据到influxdb

```makefile
curl -i -XPOST "http://localhost:8086/write?db=mydb" --data-binary @data.log.out
```

8. grafana上添加dashboard



# 结论
通过使用influxb来存储数据，grafana来做可视化。每次需要分析的时候，我需要做的仅仅只是写个脚本去规整数据，这样就大大提供了分析效率。

