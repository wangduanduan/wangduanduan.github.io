---
title: 端到端测试哪家强？不容错过的Cypress
date: 2018-05-14 10:43:02
tags:
- 端到端测试
---

# 1. 目前E2E测试工具有哪些？

项目 | Web | Star
---|--- | ---
[puppeteer](https://github.com/GoogleChrome/puppeteer) | Chromium (~170Mb Mac, ~282Mb Linux, ~280Mb Win) | 31906
[nightmare](https://github.com/segmentio/nightmare) | Electron |15502
[nightwatch](https://github.com/nightwatchjs/nightwatch) |WebDriver | 8135
[protractor](https://github.com/angular/protractor) | selenium |7532
[casperjs](https://github.com/casperjs/casperjs) |PhantomJS |7180
[cypress](https://github.com/cypress-io/cypress) | Electron | 5303
[Zombie](https://github.com/assaf/zombie) | 不需要 | 4880
[testcafe](https://github.com/DevExpress/testcafe) | 不需要 |4645
[CodeceptJS](https://github.com/Codeception/CodeceptJS) | webdriverio |  1665

端到端测试一般都需要一个Web容器，来运行前端应用。例如Chromium, Electron, PhantomJS, WebDriver等等。

从体积角度考虑，这些Web容器`体积一般都很大`。

从速度的角度考虑：`PhantomJS, WebDriver < Electon, Chromium`。

而且每个工具的侧重点也不同，建议按照需要去选择。

# 2. 优秀的端到端测试工具应该有哪些特点？

- 安装简易：我希望它非常容易安装，最好可以一行命令就可以安装完毕
- 依赖较少：我只想做个E2E测试，不想安装jdk, python之类的东西
- 速度很快：运行测试用例的速度要快
- 报错详细：详细的报错
- API完备：鼠标键盘操作接口，DOM查询接口等
- Debug方便：出错了可以很方便的调试，而不是去猜



# 3. 为什么要用Cypress？

Cypress基本上拥有了上面的特点之外，还有以下特点。

- `时光穿梭` 测试运行时，Cypress会自动截图，你可以轻易的查看每个时间的截图
- `Debug友好` 不需要再去猜测为什么测试有失败了，Cypress提供Chrome DevTools, 所以Debug是非常方便的。
- `实时刷新` Cypress检测测试用例改变后，会自动刷新
- `自动等待` 不需要在使用wait类似的方法等待某个DOM出现，Cypress会自动帮你做这些
- `Spies, stubs, and clocks` Verify and control the behavior of functions, server responses, or timers. The same functionality you love from unit testing is right at your fingertips.
- `网络流量控制` 在不涉及服务器的情况下轻松控制，存根和测试边缘案例。无论你喜欢，你都可以存储网络流量。
- `一致的结果` 我们的架构不使用Selenium或WebDriver。向快速，一致和可靠的无剥落测试问好。
- `截图和视频` 查看失败时自动截取的截图，或无条件运行时整个测试套件的视频。

# 4. 安装cypress

## 4.1. 使用npm方法安装

注意这个方法需要下载压缩过Electron, 所以可能会花费几分钟时间，请耐心等待。

```
npm i cypress -D
```

## 4.2. 直接下载Cypress客户端

你可以把Cypress想想成一个浏览器，可以单独把它下载下来，安装到电脑上，当做一个客户端软件来用。

打开之后就是这个样子，可以手动去打开项目，运行测试用例。

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180516092612_wiNNiZ_Jietu20180516-092604.jpeg)


# 5. 初始化Cypress

Cypress初始化，会在项目根目录自动生成cypress文件夹，并且里面有些测试用例模板，可以很方便的学习。

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180516092918_zwtp3h_Jietu20180516-092911.jpeg)

初始化的方法有两种。
1. 如果你下载的客户端，那么你用客户端打开项目时，它会检测项目目录下有没有Cypress目录，如果没有，就自动帮你生成模板。

2. 如果你使用npm安装的Cypress，可以使用命令`node_modules/.bin/cypress open`去初始化

# 6. 编写测试用例

```
// hacker-news.js
describe('Hacker News登录测试', () => {
  it('登录页面', () => {
    cy.visit('https://news.ycombinator.com/login?goto=news')
    cy.get('input[name="acct"]').eq(0).type('test')
    cy.get('input[name="pw"]').eq(0).type('123456')
    cy.get('input[value="login"]').click()

    cy.contains('Bad login')
  })
})
```

# 7. 查看结果

打开Cypress客户端，选择要测试项目的根目录，点击hacker-news.js后，测试用例就会自动运行

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180517162959_83xejF_Jietu20180517-162945.jpeg)


运行结束后，左侧栏目鼠标移动上去，右侧栏都会显示出该步骤的截图，所以叫做时光穿梭功能。

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180517164346_Lipgu6_Jietu20180517-163217.jpeg)

从截图也可以看出来，Cypress的步骤描述很详细。
