---
title: git常用配置与操作整理
date: 2018-02-08 13:49:29
tags:
- git
---

# 常用配置

```
git config --global user.name "wddd"   
git config --global user.email "rwerewrsdfds" 
  
git config --global color.ui true

git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.br branch
git config --global alias.mg merge
git config --global alias.cp cherry-pick
git config --global push.default current

git config --global core.editor "mate -w"    # 设置Editor使用textmate
git config -l  # 列举所有配置
```

# 提交与查看状态
```
// 提交
git ci -am "fix a bug"
git push

// 查看状态
git st

// 切换到某个分支
git st // 先看看当前分支有没有没有提交的代码，如果有，要先提交，然后再切换到其他分支
git co test// 切换到test分支

// 查看当前一共有多少分支
git br -a

// pull远程分支代码到本地分支
git pull
```

# 分支推送与拉取
```
// 基于本地maste分支，新建一个dev分支
git chheckout master // 切换到master分支
git checkout -b dev // 基于master,新建dev分支, 并切换到dev分支
git push origin dev // 将dev分支，推送到远程仓库

git fetch origin test // 拉去远程test分支到本地
```

# git 仅仅合并某次提交

```
git checkout master
git cherry-pick commit-id1 commit-id2  // 把指定commit合并到当前分支
```
