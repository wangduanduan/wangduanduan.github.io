---
title: "5个接口压力测试工具"
date: "2021-05-31 13:00:16"
draft: false
---

# ab
- C语言
- 优点
   - 安装简单
- 缺点
   - 不支持指定测试时长

## 安装
```bash
# debian/ubuntu
apt-get install apache2-utils
# centos
yum -y install httpd-tools
```

# wrk

- [https://github.com/wg/wrk](https://github.com/wg/wrk)
- C语言
- 优点
   - 支持lua脚本
> wrk is a modern HTTP benchmarking tool capable of generating significant load when run on a single multi-core CPU. It combines a multithreaded design with scalable event notification systems such as epoll and kqueue.
> An optional LuaJIT script can perform HTTP request generation, response processing, and custom reporting. Details are available in SCRIPTING and several examples are located in scripts/.


## 安装
```bash
git clone https://github.com/wg/wrk.git
cd wrk
make
sudo ln -s $PWD/wrk /usr/bin/wrk
```

## 基本使用
```bash
wrk -t12 -c400 -d30s http://127.0.0.1:8080/index.html

Running 30s test @ http://127.0.0.1:8080/index.html
  12 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   635.91us    0.89ms  12.92ms   93.69%
    Req/Sec    56.20k     8.07k   62.00k    86.54%
  22464657 requests in 30.00s, 17.76GB read
Requests/sec: 748868.53
Transfer/sec:    606.33MB
```

# k6
**k6** is a modern load testing tool, building on [our](https://k6.io/about) years of experience in the load and performance testing industry. It provides a clean, approachable scripting API, [local](https://k6.io/docs/getting-started/running-k6) and [cloud execution](https://k6.io/docs/cloud), and flexible configuration.<br />This is how load testing should look in the 21st century.

- [https://github.com/k6io/k6](https://github.com/k6io/k6)
- go语言开发
- 优点
   - 支持使用脚本开发测试
   - 功能强大
   - ......
   - 支持将测试结果直接写入influxdb, 这是亮点啊
- 缺点
   - 如果你只想用几个参数来测试接口，大可不必用k6

## 安装
```bash
# macos
brew install k6
// 其他平台也是支持的，参考官方文档
```

# autocannon

- Javascript/Node.js
- [https://github.com/mcollina/autocannon](https://github.com/mcollina/autocannon)
- 优点
   - 如果你是Node.js开发者，安装autocannon是非常简单的

## 安装
```bash
npm i autocannon -g
```

## 使用


# ali

- [https://github.com/nakabonne/ali](https://github.com/nakabonne/ali)
- go语言开发
- 特点
   - 支持自动在控制台绘图

## 安装
```bash
brew install nakabonne/ali/ali
```