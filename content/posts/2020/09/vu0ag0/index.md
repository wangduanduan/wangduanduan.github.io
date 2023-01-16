---
title: "使用commitlint检查git提交信息是否合规"
date: "2020-09-23 09:29:01"
draft: false
---
建议先看下前提知识：[https://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html](https://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)


# 提交信息规范

通用类型的头字段

- build 构建
- ci 持续继承工具
- chore 构建过程或辅助工具的变动
- docs 文档（documentation）
- feat 新功能（feature）
- fix 修补bug
- perf 性能优化
- refactor 重构（即不是新增功能，也不是修改bug的代码变动）
- revert
- style 格式（不影响代码运行的变动）
- test 增加测试

```bash
git commit -m "fix: xxxxxx"
git commit -m "feat: xxxxxx"

```


# 安装

## 安装依赖
```bash
yarn add -D @commitlint/config-conventional @commitlint/cli husky
```


## 修改package.json

在package.json中加入

```bash
  "husky": {
    "hooks": {
      "commit-msg": "commitlint -E HUSKY_GIT_PARAMS"
    }
  }
```


## 新增配置

文件名：commitlint.config.js
```bash
module.exports = {extends: ['@commitlint/config-conventional']}
```


# 测试

如果你的提交不符合规范，提交将会失败。
```bash
➜  git commit -am "00"
warning ../package.json: No license field
husky > commit-msg (node v12.18.3)
⧗   input: 00
✖   subject may not be empty [subject-empty]
✖   type may not be empty [type-empty]

✖   found 2 problems, 0 warnings
ⓘ   Get help: https://github.com/conventional-changelog/commitlint/#what-is-commitlint
```


# 根据commitlog生成changelog
下面命令中的1.5.5 1.5.10可以是两个tag, 也可以是两个分支。

git log 可以提取两个点之间的commitlog, 使用...
```bash
git log --pretty=format:"[%h] %s (%an)" 1.5.5...1.5.10 | sort -k2,2 > changelog.md
```


# 参考

- [https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-angular](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-angular)
- [https://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html](https://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)


