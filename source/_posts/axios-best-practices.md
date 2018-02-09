---
title: axios进阶：用最优雅的方式写ajax请求
date: 2018-02-09 11:59:25
tags:
- axios
---

> `可以用配置解决的问题，请勿硬编码`
> 姊妹篇 [jQuery进阶：用最优雅的方式写ajax请求](https://segmentfault.com/a/1190000008678653)
> 或许你也可以试试：[xfire: 简单优雅、高度可配置的fetch接口批量生成工具](https://segmentfault.com/a/1190000012830130)

[axios](https://github.com/axios/axios)是Vue官方推荐的ajax库, 用来取代vue-resource。

`优点：`
- `增加一个ajax接口，只需要在配置文件里多写几行就可以`
- `不需要在组件中写axios调用，直接调用api方法，很方便`
- `如果接口有调整，只需要修改一下接口配置文件就可以`
- `统一管理接口配置`

# content-type配置

```
// filename: content-type.js
module.exports = {
  formData: 'application/x-www-form-urlencoded; charset=UTF-8',
  json: 'application/json; charset=UTF-8'
}
```

# api 配置
```
// filename: api-sdk-conf.js
import contentType from './content-type'

export default {
  baseURL: 'http://192.168.40.231:30412',
  apis: [
    {
      name: 'login',
      path: '/api/security/login?{{id}}',
      method: 'post',
      contentType: contentType.formData,
      status: {
        401: '用户名或者密码错误'
      }
    }
  ]
}
```

# request.js 方法
```
// request.js
import axios from 'axios'
import qs from 'qs'
import contentType from '@/config/content-type'
import apiConf from '@/config/api-sdk-conf'

var api = {}

// render 函数用来渲染路径上的变量, 算是一个微型的模板渲染工具
// 例如render('/{{userId}}/{{type}}/{{query}}', {userId:1,type:2, query:3})
// 会被渲染成 /1/2/3

function render (tpl, data) {
  var re = /{{([^}]+)?}}/
  var match = ''

  while ((match = re.exec(tpl))) {
    tpl = tpl.replace(match[0], data[match[1]])
  }

  return tpl
}

// fire中的this, 会动态绑定到每个接口上
function fire (query = {}, payload = '') {
  // qs 特别处理 formData类型的数据
  if (this.contentType === contentType.formData) {
    payload = qs.stringify(payload)
  }
  
  // 直接返回axios实例，方便调用then,或者catch方法
  return axios({
    method: this.method,
    url: render(this.url, query),
    data: payload,
    headers: {
      contentType: this.contentType
    }
  })
}

apiConf.apis.forEach((item) => {
  api[item.name] = {
    url: apiConf.baseURL + item.path,
    method: item.method,
    status: item.status,
    contentType: item.contentType,
    fire: fire
  }
})

export default api
```

# 在组件中使用
```
import api from '@/apis/request'
...
      api.login.fire({id: '?heiheihei'}, {
        username: 'admin',
        password: 'admin',
        namespace: '_system'
      })
...
```

浏览器结果：
```
Request URL:http://192.168.40.231:30412/api/security/login??heiheihei
Request Method:POST
Status Code:200 OK
Remote Address:192.168.40.231:30412
Referrer Policy:no-referrer-when-downgrade

POST /api/security/login??heiheihei HTTP/1.1
Host: 192.168.40.231:30412
Connection: keep-alive
Content-Length: 47
Accept: application/json, text/plain, */*
Origin: http://localhost:8080
contentType: application/x-www-form-urlencoded; charset=UTF-8
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36
Content-Type: application/x-www-form-urlencoded
Referer: http://localhost:8080/
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8

username=admin&password=admin&namespace=_system
```

# 更多
`有个地方我不是很明白，希望懂的人可以给我解答一下`

如果某个组件中只需要`login`方法，但是我这样写会报错。
```
import {login} from '@/apis/request'
```

这样写的前提是要在request.js最后写上
```
export var login = api.login
```

但是这是我不想要的，因为每次增加一个接口，这里都要export一次， 这不符合`开放闭合原则`，请问有什么更好的方法吗？


