---
title: jest jenkins搭建自动化测试CI教程
date: 2018-07-16 20:58:21
tags:
- jest
- jenkins
- ci
---

> 关于jest和jenkins集成，我走了一些弯路。之前一直用jenkins打包nodejs镜像。想做nodejs自动化接口测试时，我也按照打包镜像的套路走，感觉走到死胡同。网上搜`jest jenkins integration`, 感觉很多答案都不靠谱。终于自己走通了一遍。

# 1. 安装jenkins nodejs插件

地址：https://plugins.jenkins.io/nodejs

![](http://p3alsaatj.bkt.clouddn.com/20180716210423_ixn1oc_Jietu20180716-210411.jpeg)

- 注意该插件要求jenkins版本不低于1.651.3

## 1.1. 安装方法

`方法1`：在jenkins插件管理，可选插件中搜索并安装
`方法2`：如果搜索不到nodejs, 可以在该插件的介绍页面选择`latest.hpi`, 下载这个文件，然后再插件管理》高级标签页面选择上传刚才的`hpi`文件。



![](http://p3alsaatj.bkt.clouddn.com/20180716210627_eWn8gN_Screenshot.jpeg)

![](http://p3alsaatj.bkt.clouddn.com/20180716210915_aCIn6F_Jietu20180716-210903.jpeg)

## 1.2. 插件初始化设置

在全局工具管理页面，路径为`/configureTools/`, 

1. 点击Nodejs 安装这一栏，新增别名
2. 选择Nodejs版本，建议不要最新版，最好和本地开发环境一样的版本即可
3. 输入一些全局安装包，例如: `yarn`
4. 最后别忘记点击保存

![](http://p3alsaatj.bkt.clouddn.com/20180716211246_fnKu4l_Jietu20180716-211220.jpeg)


# 2. 创建一个任务

1. 输入一个名称
2. 选择FreeStyle风格
3. 点击确定

![](http://p3alsaatj.bkt.clouddn.com/20180716211615_KonR3t_Jietu20180716-211606.jpeg)

# 3. 任务配置

## 3.1. 源码管理

1. 源码管理当然选择私有部署的git仓库了

![](http://p3alsaatj.bkt.clouddn.com/20180716212144_CMXTaO_Jietu20180716-212111.jpeg)

## 3.2. 触发器构建

1. 记住方框里面的地址，这个地址需要填入到gilab响应仓库的`settings>integrations>URL`, 然后选择add webhook, 这边git一旦push, jenkins那边就会自动构建测试任务了。

![](http://p3alsaatj.bkt.clouddn.com/20180716212313_ENwdDS_Jietu20180716-212249.jpeg)

【下图： 私有gitlab仓库集成设置】

![](http://p3alsaatj.bkt.clouddn.com/20180716212645_nLHRSD_Jietu20180716-212633.jpeg)

## 3.3. 构建环境选择nodejs

![](http://p3alsaatj.bkt.clouddn.com/20180716212827_0Ifs6f_Jietu20180716-212803.jpeg)

## 3.4. 构建

1. 选择执行shell
2. 在命令中输入如下代码

`注意：第一次构建可能会很慢，因为要安装nodejs, npm, yarn之类的软件`

```
echo $PATH // 输出 path
pwd // 输入当前目录
node --version // 输出node版本
yarn --version // 输出yarn版本

yarn --registry=https://registry.npm.taobao.org // 使用淘宝仓库，安装更快
yarn run test:report // 运行测试
```

![](http://p3alsaatj.bkt.clouddn.com/20180716212945_ttrGNU_Jietu20180716-212927.jpeg)


## 3.5. 构建后操作

1. 构建后操作可以选择安装一个`publish html reports`, 用来查看测试报告。如果没有改选项，则需要安装该插件

![](http://p3alsaatj.bkt.clouddn.com/20180716213355_mohuli_Jietu20180716-213303.jpeg)

![](http://p3alsaatj.bkt.clouddn.com/20180716213502_o3WHlC_Jietu20180716-213454.jpeg)


# 4. 第一次构建

不出意外的情况下，第一次构建成功。

安装了`publish html reports`插件后，这边会多出一个选项。

![](http://p3alsaatj.bkt.clouddn.com/20180716213819_ccKdHB_Jietu20180716-213807.jpeg)

点击进去可以发现测试报告。

`注意` 测试报告并不是publish html reports生成的。

![](http://p3alsaatj.bkt.clouddn.com/20180716213937_Ft7YJr_Jietu20180716-213919.jpeg)

# 5. 测试报告如何生成？

测试报告实际上是[jest-html-reporter](https://www.npmjs.com/package/jest-html-reporter)生成的。

```
  "scripts": {
    "test:report": "jest --reporters='jest-html-reporter'"
  },
```

我的项目目录如下：

![](http://p3alsaatj.bkt.clouddn.com/20180716214502_tvPCcT_Jietu20180716-214433.jpeg)


# 6. 最后: 如果你也需要自动化接口测试工具

可以试试我最近写的一个工具：`https://github.com/wangduanduan/Aest`。

## 6.1. Aest

![Travis](https://img.shields.io/travis/wangduanduan/Aest.svg)

![](https://img.shields.io/badge/code_style-standard-brightgreen.svg) [![](https://img.shields.io/badge/node-%3E%3D8.0.0-brightgreen.svg)]() ![npm](https://img.shields.io/npm/v/aester.svg) ![Packagist](https://img.shields.io/packagist/l/doctrine/orm.svg)




功能强大的REST接口测试工具, Power By [Jest](https://jestjs.io/en/), [axios](https://github.com/axios/axios), [superstruct](https://github.com/ianstormtaylor/superstruct), [mustache](https://github.com/janl/mustache.js), [lodash](https://lodash.com/)

## 6.2. 特点

- `非常简单`: 大部分工作量在于写配置文件
- `请求模板`: 可以在配置文件中加入运行时变量，如`/users/{{id}}`
- `响应体结构验证`: 支持对响应体的字段类型进行严格校验，多字段、少字段、字段类型不符合预期都会报错
- `非常详细的报错提示`: 

## 6.3. 安装

```
yarn add aester
npm i aester -S
```