---
title: "IE8/9 支持WebSocket方案，flash安全策略"
date: "2022-10-29 11:43:23"
draft: false
---

IE8/9原生是不支持WebSocket的，但是我们可以使用flash去模拟一个WebSocket接口出来。

这方面，[https://github.com/gimite/web-socket-js](https://github.com/gimite/web-socket-js)  已经可以使用。

除了客户端之外，服务端需要做个flash安全策略设置。

这里的服务端是指WebSocet服务器所在的服务端。默认端口是843端口。

客户端使用flash模拟WebSocket时，会打开一个到服务端843端口的TCP链接。

并且发送数据：
```nginx
<policy-file-request>.
```
服务端需要回应下面类似的内容
```nginx
<?xml version="1.0"?>
<!DOCTYPE cross-domain-policy SYSTEM "/xml/dtds/cross-domain-policy.dtd">
<cross-domain-policy>
    <site-control permitted-cross-domain-policies="all"/>
    <allow-access-from domain="*" to-ports="*" secure="false"/>
    <allow-http-request-headers-from domain="*" headers="*"/>
</cross-domain-policy>
```

# Node.js实现

- policy.js
```javascript
module.exports.policyFile =
`<?xml version="1.0"?>
<!DOCTYPE cross-domain-policy SYSTEM "/xml/dtds/cross-domain-policy.dtd">
<cross-domain-policy>
    <site-control permitted-cross-domain-policies="all"/>
    <allow-access-from domain="*" to-ports="*" secure="false"/>
    <allow-http-request-headers-from domain="*" headers="*"/>
</cross-domain-policy>`
```

- index.js

```javascript
const Net = require('net')
const {policyFile} = require('./policy')

const port = 843

console.log(policyFile)

const server = new Net.Server()

server.listen(port, function() {
    console.log(`Server listening for connection requests on socket localhost:${port}`);
});


server.on('connection', function(socket) {
    console.log('A new connection has been established.');

    socket.end(policyFile)

    socket.on('data', function(chunk) {
        console.log(`Data received from client: ${chunk.toString()}`);
    });

    socket.on('end', function() {
        console.log('Closing connection with the client');
    });

    socket.on('error', function(err) {
        console.log(`Error: ${err}`);
    });
});
```

