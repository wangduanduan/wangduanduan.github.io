title: cypress基础教程
tags:
  - cypress
  - 端到端测试
categories: []
date: 2018-07-12 16:43:00
---
# 1. 软件安装.

# 2. 安装cypress

- 安装cypress客户端：http://download.cypress.io/desktop 
- 安装vscode编辑器：https://code.visualstudio.com/Download

# 3. 初始化

1. 假如项目目录是 `/test`
2. 打开cypress客户端， 点击箭头位置，通过资源管理器选择`/test`目录
3. 如果`/test`没有cypress目录，那么cypress就会在test目录下新建cypress目录，并初始化一些文件

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180712165231_6m1oNT_Jietu20180712-165215.jpeg)

# 4. cypress目录分析

```
- cypress // cypress目录
---- fixtures 测试数据配置文件，可以使用fixture方法读取
---- integration 测试脚本文件
---- plugin 插件文件
---- support 支持文件
- cypress.json // cypress全局配置文件
```

# 5. 基本例子

一般流程

1. 访问某个页面
2. 查找DOM进行交互，例如输入，点击，选择之类
3. 进行断言

```
describe('Hacker News登录测试', () => {
  it('登录页面', () => {
    cy.visit('https://news.ycombinator.com/login?goto=news')
    cy.get('input[name="acct"]').eq(0).type('test')
    cy.get('input[name="pw"]').eq(0).type('123456')
    cy.get('input[value="login"]').click()

    cy.get('body').should('contain', 'Bad login')
  })
})
```

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180712214300_oiyXLR_Jietu20180712-214248.jpeg)

# 6. DOM选取

参考： https://docs.cypress.io/guides/core-concepts/interacting-with-elements.html#

- jquery选择法
- 通过客户端GUI工具选取

# 7. DOM交互

- .click() 单击
- .dblclick() 双击
- .type() 输入
- .clear() 清空
- .check() 选中
- .uncheck() 取消选中
- .select() 下拉框选择
- .trigger() 反转

# 8. 断言
- .contains() 查找匹配字符串
- .should()

更多断言参考 https://docs.cypress.io/guides/references/assertions.html

## 8.1. 长度断言

```
// retry until we find 3 matching <li.selected>
cy.get('li.selected').should('have.length', 3)
```

## 8.2. 类断言

```
// retry until this input does not have class disabled
cy.get('form').find('input').should('not.have.class', 'disabled')
```

## 8.3. 值断言

```
// retry until this textarea has the correct value
cy.get('textarea').should('have.value', 'foo bar baz')
```

## 8.4. 文本断言

```
// retry until this span does not contain 'click me'
cy.get('a').parent('span.help').should('not.contain', 'click me')
```

## 8.5. 可见性断言

```
// retry until this button is visible
cy.get('button').should('be.visible')
```

## 8.6. 存在性断言

```
// retry until loading spinner no longer exists
cy.get('#loading').should('not.exist')
```

## 8.7. 状态断言

```
// retry until our radio is checked
cy.get(':radio').should('be.checked')
```

# 9. 读取测试配置数据

- Cypress.env() 可以读取全局配置
- fixture(文件名).as(变量), 可以将文件中的配置数据读取为变量，作为后续的测试用例来使用，注意这一步是异步的，必须放在before或者beforeEach等钩子函数中使用

```
describe('软电话登录', function () {
  before(() => {
    cy.fixture(Cypress.env('envName') + '-login-data.json').as('loginData')
  })

  it('wellClient test', function () {
    cy.log(this.loginData)

    cy.visit(this.loginData.url)

    cy.get('#config-env').select('CMB-TEST')
    cy.get('#config').click()

    cy.get('#well-code').type(this.loginData.jobNumber)
    cy.get('#well-password').type(this.loginData.password)
    cy.get('#well-namespace').type(this.loginData.domain)
    cy.get('#well-deviceId').type(this.loginData.ext)

    cy.get('#well-login').click()

    cy.wait(3000)
    cy.get('#well-login').should('not.be.visible')
  })
})

```

# 10. 全局配置 cypress.json

参考：https://docs.cypress.io/guides/references/configuration.html#Options

# 11. 变量与别称

参考：https://docs.cypress.io/guides/core-concepts/variables-and-aliases.html#

# 12. 钩子函数

参考： https://docs.cypress.io/guides/core-concepts/writing-and-organizing-tests.html#Hooks

- before()
- beforeEach()
- afterEach()
- after()

# 13. 最佳实践

参考： https://docs.cypress.io/guides/references/best-practices.html

# 其他
- cy.window() 异步获取window对象，无法直接使用window对象