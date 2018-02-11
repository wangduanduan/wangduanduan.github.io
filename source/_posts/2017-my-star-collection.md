---
title: 回首2017 你其实是一个收集贝壳的孩子
date: 2018-02-11 14:37:33
tags:
- star
---

![](http://p3alsaatj.bkt.clouddn.com/20180211143825_5WhtUR_Screenshot.jpeg)

> 我不知道世上的人对我怎样评价。我却这样认为：我好像是在海上玩耍，时而发现了一个光滑的石子儿，时而发现一个美丽的贝壳而为之高兴的孩子。尽管如此，那真理的海洋还神秘地展现在我们面前。—— 牛顿

`github`也像是一片海海，2017年，我大约从这篇海中捡了200多个彩色的贝壳。在年底之前，挑一些精致美丽的贝壳，分享出来。

<!-- more -->

# 1. [docsify：想让你的文档拥有Vue官方文档一样的颜值吗？](https://github.com/QingWei-Li/docsify)

`我喜欢Vue的原因是Vue官方文档颜值很高 by me`, 那么你想来一份吗？

- `高颜值`
- `非常简单`
- 无需构建，写完文档直接发布
- 容易使用并且轻量 (~18kB gzipped)
- 智能的全文搜索
- 提供多套主题
- 丰富的 API
- 支持 Emoji
- 兼容 IE10+
- 支持 SSR (example)

![](http://p3alsaatj.bkt.clouddn.com/20180211144002_TNZrwa_Screenshot.jpeg)

# 2. [JavaScript Standard Style：一千个开发者只有一个风格](https://github.com/standard/standard)

`还在为要不要分号争吵吗？ 还在为两个空格和四个空格犹豫吗？ 还在为各种格式检查的配置文件苦恼吗？ `

`其实，你需要的只是JavaScript Standard Style罢了，无数大牛公司在用，你还在犹豫什么？`

`好多编辑器支持JavaScript Standard Style，安装过后，ctrl + s一下，哪怕shi一样的代码，也会瞬间华丽变身成维多利亚的秘密。`

`帅的人已经用了，不帅的还在犹豫`

- `无须配置`。 史上最便捷的统一代码风格的方式，轻松拥有。
- `自动代码格式化`。 只需运行 standard --fix - 从此和脏乱差的代码说再见。
- 提前发现风格及程序问题。 - 减少代码审查过程中反反复复的修改过程，节约时间。
- 使用两个空格 – 进行缩进
- 无分号 – 这没什么不好。不骗你！
- 查看更多 – [为何不试试 standard 规范呢！](https://github.com/standard/standard/blob/master/docs/RULES-zhcn.md#javascript-standard-style)

![](http://p3alsaatj.bkt.clouddn.com/20180211144016_ciMMeG_Screenshot.jpeg)

# 3. [mitt: 纳米级别的事件订阅系统](https://github.com/developit/mitt)

如果你看了mitt的源码，你应该会惊呼：`WTF，人家接近50行代码也能获得2000多颗星！！！！`

- 纳米级别: 小于200B
- 相当有用: 用"*"可以去订阅所有事件
- 非常熟悉: 类似于Node's EventEmitter
- 函数式: 方法不依赖`this`

![](http://p3alsaatj.bkt.clouddn.com/20180211144027_hANzrm_Screenshot.jpeg)

# 4. [faker.js: 最优雅的假数据生成器](https://github.com/Marak/faker.js)

- Supports all Faker API Methods
- Full-Featured Microservice
- Hosted by hook.io

```
var randomName = faker.name.findName(); // Caitlyn Kerluke
var randomEmail = faker.internet.email(); // Rusty@arne.info
var randomCard = faker.helpers.createCard(); // random contact card containing many properties
```
![](http://p3alsaatj.bkt.clouddn.com/20180211144039_JErY9F_Screenshot.jpeg)

# 5. [superstruct: 精准详细的runtime 数据验证工具](https://github.com/ianstormtaylor/superstruct)

- `给出的错误提示很详细，非常容易定位bug`
- `帮你做好那些数据验证的脏活累活`

```
const { superstruct, struct } = window.Superstruct

const User = struct({
  id: 'number',
  name: 'string',
})

const data = {
  id: 'invalid',
  name: 'Jane Smith',
}

try {
  const user = User(data)
  log('valid', user)
} catch (e) {
  const { message, path, data, type, value } = e
  log('invalid', { message, path, data, type, value })
}

function log(type, data) {
  document.body.className = type
  document.body.textContent = JSON.stringify(data, null, 2)
}
```

`可以看一下她输出的错误信息`
```
{
  "message": "Expected a value of type `number` for `id` but received `\"invalid\"`.",
  "path": [
    "id"
  ],
  "data": {
    "id": "invalid",
    "name": "Jane Smith"
  },
  "type": "number",
  "value": "invalid"
}
```

# 6. [uppy: 下一代开源文件上传插件](https://github.com/transloadit/uppy)


`Uppy是一款时尚，模块化的文件上传器，可以与任何应用程序无缝集成。这是快速，易于使用，让您担心比建立一个文件上传更重要的问题。`


- 从本地磁盘，Google云端硬盘，Dropbox，Instagram获取文件，或使用相机捕捉和记录自拍;
- 用一个漂亮的界面预览和编辑元数据;
- 上传到最终目的地，可选择进行处理/编码

![](https://raw.githubusercontent.com/transloadit/uppy/master/uppy-screenshot.jpg)

# 7. [Inquirer.js: 在命令行里做问卷调查](https://github.com/SBoudrias/Inquirer.js)

```
'use strict'
var inquirer = require('inquirer')

var questions = [
  {
    type: 'input',
    name: 'name',
    message: '请输入你的名字'
  },
  {
    type: 'input',
    name: 'age',
    message: '请输入你的年龄',
    default: function () {
      return '10'
    }
  },
  {
    type: 'list',
    name: 'sex',
    message: '请选择你的性别',
    choices: ['男', '女']
  }
]

inquirer.prompt(questions).then(answers => {
  console.log(JSON.stringify(answers, null, '  '))
})
```

```
➜  src git:(master) ✗ node query.js
? 请输入你的名字 wdd
? 请输入你的年龄 23
? 请选择你的性别 男
{
  "name": "wdd",
  "age": "23",
  "sex": "男"
}
```


