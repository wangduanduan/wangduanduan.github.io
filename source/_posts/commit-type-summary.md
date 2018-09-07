---
title: Git Commit Message 格式与类型分类
date: 2018-02-02 16:33:17
tags:
- git
- git-commit
---

# 1. 缩写含义说明

  类型    |                         描述
-------- | -----------------------------------------------------
feature     | 新增feature
fix      | 修复bug
docs     | 仅仅修改了文档，比如README, CHANGELOG, CONTRIBUTE等等
style    | 仅仅修改了空格、格式缩进、都好等等，不改变代码逻辑
refactor | 代码重构，没有加新功能或者修复bug
perf     | 优化相关，比如提升性能、体验
test     | 测试用例，包括单元测试、集成测试等
tips     | 增加一些提示信息，例如错误提示


# 2. 格式示例

格式： type [id] message

```
git commit -am "fix 2038 解决点击无反应的问题"
```

# 3. 小技巧

## 3.1. 使用单引号多行commit

注意： window下务必使用git bash。

```
git commit -am '
fix 2093 alsdfj laksd
asdflka sdflkasdf '
```




# 4. 参考
- [project-guidelines](https://github.com/wearehive/project-guidelines/blob/master/README-zh.md)
- [Commit message 和 Change log 编写指南](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)
- [cz-cli](https://github.com/commitizen/cz-cli)
- [Git commit message和工作流规范](https://ivweb.io/topic/58ba702bdb35a9135d42f83d)
