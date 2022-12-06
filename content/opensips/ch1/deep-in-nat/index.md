---
title: "深入NAT网络"
date: "2019-11-05 16:29:43"
draft: false
---
- NAT的产生原因是IPv4的地址不够用，网络中的部分主机只能公用一个外网IP。
- NAT工作在网络层和传输层，主要是对IP地址和端口号的改变
- NAT的优点
   - 节约公网IP
   - 安全性更好，所有流量都需要经过入口的防火墙
- NAT的缺点
   - 对于UPD应用不够友好



# NAT 工作原理
内部的设备X, 经过NAT设备后，NAT设备会改写源IP和端口<br />![image.png](https://cdn.nlark.com/yuque/0/2019/png/280451/1572943077192-78f4530d-9bfc-4e9f-a488-6ee447e577a5.png#align=left&display=inline&height=334&name=image.png&originHeight=844&originWidth=1432&size=201086&status=done&style=none&width=566)


# NAT 类型

## 1. 全锥型

- 每个内部主机都有一个静态绑定的外部ip:port
- 任何主机发往NAT设备上特定ip:port的包，都会被转发给绑定的主机
- 这种方式的缺点很明显，黑客可以使用端口扫描工具，扫描出暴露的端口，然后通过这个端口攻击内部主机
- 在内部主机没有往外发送流量时，外部流量也能够进入内部主机

![image.png](https://cdn.nlark.com/yuque/0/2019/png/280451/1572943413440-135a57b9-6517-4cdd-a1b4-56c59273cd57.png#align=left&display=inline&height=311&name=image.png&originHeight=622&originWidth=1196&size=141988&status=done&style=none&width=598)-


## 2. 限制锥形

- NAT上的ip:port与内部主机是动态绑定的
- 如果内部主机没有向某个主机先发送过包，那么NAT会拒绝外部主机进入的流量

![image.png](https://cdn.nlark.com/yuque/0/2019/png/280451/1572943838117-6fd712bd-a649-48b1-a03a-41f05c0d2759.png#align=left&display=inline&height=304&name=image.png&originHeight=608&originWidth=1188&size=153067&status=done&style=none&width=594)


## 3. 端口限制型

- 端口限制型除了有限制锥型的要求外，还增加了端口的限制

![image.png](https://cdn.nlark.com/yuque/0/2019/png/280451/1572943950482-37299fa8-7161-4b2e-9dd4-fdbb3e4f7bd6.png#align=left&display=inline&height=280&name=image.png&originHeight=656&originWidth=1386&size=151799&status=done&style=none&width=591)


## 4. 对称型

- 对称型最难穿透，因为每次交互NAT都会使用不同的端口号，所以内外网端口映射根本无法预测

![image.png](https://cdn.nlark.com/yuque/0/2019/png/280451/1572944115984-952ed90f-0f42-480a-8c9a-0f8f0c49fc0f.png#align=left&display=inline&height=304&name=image.png&originHeight=608&originWidth=1192&size=129426&status=done&style=none&width=596)



# NAT对比表格

| NAT类型 | 收数据前是否需要先发送数据 | 是否能够预测下一次的NAT打开的端口对 | 是否限制包的目的ip:port |
| --- | --- | --- | --- |
| 全锥形 | 否 | 是 | 否 |
| 限制锥形 | 是 | 是 | 仅限制IP |
| 端口限制型 | 是 | 是 | 是 |
| 对称型 | 是 | 否 | 是 |






