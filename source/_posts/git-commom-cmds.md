---
title: gitbash生存指南 之 git常用命令与oh-my-zsh常用缩写
date: 2018-01-31 16:19:38
tags:
- git
- oh-my-zsh
---

`如果命令行可以解决的问题，就绝对不要用GUI工具。快点试用Git bash吧， 别再用TortoiseGit了。`

# 1. 必会8个命令

下面的操作都是经常使用的，有些只需要做一次，有些是经常操作的

git命令虽然多，但是经常使用的不超过8个。

命令 | 执行次数 | 说明
--- | --- | ---
`git clone http://sdfjslf.git` | 每个项目只需要执行一次 | //克隆一个项目 
`git fetch origin round-2` | 每个分支只需要执行一次 |  //round-2分支在本地不存在，首先要创建一个分支
`git checkout round-2` | 多次 | // 切换到round-2分支
`git branch --set-upstream-to=origin/round-2` | 每个分支只需要执行一次 | // 将本地round-2分支关联远程round-2分支
`git add -A` | 每次增加文件都要执行 |  // 在round-2下创建了一个文件, 使用-A可以添加所有文件到暂存区
`git commit -am "我增加了一个文件"` | 每次提交都要执行 | // commit
`git push` | 每次推送都要执行 | //最好是在push之前，使用git pull拉去远程代码到本地，否则有可能被拒绝
`git pull` | 每次拉去都要执行 | 拉去远程分支代码到本地并合并到当前分支


# 2. 常用的git命令

`假设你在master分支上`

```
// 将本地修改后的文件推送到本地仓库
git commit -am '修改了一个问题'

// 将本地仓库推送到远程仓库
git push 
```
## 2.1. 状态管理
### 2.1.1. 状态查看
查看当前仓库状态
```
git status
```

## 2.2. 分支管理

### 2.2.1. 分支新建
基于当前分支，创建test分支
```
// 创建dev分支
git checkout dev

// 创建dev分支后，切换到dev分支
git checkout -b dev 

// 以某个commitId为起点创建分支
git checkout -b new-branch-name commit-id
```

### 2.2.2. 分支查看
查看远程分支： git branch -r

```
// 查看本地分支
git branch

// 查看远程分支
git branch -r

// 查看所有分支
git branch -a
```

### 2.2.3. 分支切换
切换到某个分支: git checkout 0.10.7
```
> git checkout 0.10.7
Branch 0.10.7 set up to track remote branch 0.10.7 from origin.
Switched to a new branch '0.10.7'
```

### 2.2.4. 分支合并

将master分支合并到0.10.7分支: git merge
```
> git merge master
Merge made by the 'recursive' strategy.
 public/javascripts/app-qc.js      |  83 +++++++++++++++++++++++++--
 views/menu.html                   |   1 +
 views/qc-template-show-modal.html | 114 ++++++++++++++++++++++++++++++++++++++
 views/qc-template.html            |   7 ++-
 4 files changed, 198 insertions(+), 7 deletions(-)
 create mode 100644 views/qc-template-show-modal.html


// 有时候只想合并某次commit到当前分支，而不是合并整个分支，可以使用 cherry-pick 合并
git cherry-pick commmitId
```

### 2.2.5. 分支删除 
```
// 删除远程dev分支
git push --delete origin dev

// 删除本地dev分支
git branch -D dev
```

### 2.2.6. 拉取本地不存在的远程分支

```
// 假设现在在master分支， 我需要拉去远程的dev分支到本地

// 拉取远程分支到本地
git fetch origin dev

// 切换到dev分支
git checkout dev

// 本地dev分支关联远程dev分支, 如果不把本地dev分支关联远程dev分支，则执行git pull和git push命令时会报错
git branch --set-upstream-to=origin/dev

// 然后你就可以在dev分支上编辑了
```

## 2.3. 版本对比
```
// 查看尚未暂存的文件更新了哪些部分
git diff

// 查看某两个版本之间的差异
git diff commitID1 commitID2 

// 查看某两个版本的某个文件之间的差异
git diff commitID1:filename1 commitID2:filename2
```

## 2.4. 日志查看
```
git log 
git short-log 
```

# 3. oh-my-zsh中常用的git缩写

```
alias ga='git add'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gcam='git commit -a -m'
alias gcb='git checkout -b'
alias gco='git checkout'
alias gcm='git checkout master'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gfo='git fetch origin'
alias ggpush='git push origin $(git_current_branch)'
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias glgp='git log --stat -p'
alias gm='git merge'
alias gp='git push'
alias gst='git status'
alias gsta='git stash save'
alias gstp='git stash pop'
alias gl='git pull'
alias glg='git log --stat'
alias glgp='git log --stat -p'
```

[oh-my-zsh git命令缩写完整版](https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/git/git.plugin.zsh)



# 4. 参考文献
- [git 命令参考](https://git-scm.com/docs)
- [《Pro Git 中文版》](https://git-scm.com/book/zh/v2)
- [廖雪峰 git教程](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)
- [猴子都能懂的GIT入门](https://backlog.com/git-tutorial/cn/)