---
title: "解决 VsCode pwsh终端环境变量不生效问题"
date: "2023-11-16 08:08:39"
draft: false
type: posts
tags:
- all
categories:
- all
---


我在系统的环境变量设置里，用户和系统中，都加入了`ELECTRON_MIRROR=https://npmmirror.com/mirrors/electron/`这个环境变量。

单独打开windows Terminal应用，使用 `env | grep ELE` 是能搜到我设置的环境变量的。但是在vscode中，这个环境变量不存在。

我尝试了以下几个方法

1. 重启电脑，无效
2. 配置`"terminal.integrated.persistentSessionReviveProcess": "never"`, 然后重启电脑，无效
3. 在终端直接执行`code .`, 在终端打开vscode, 依然无效


因此，我想起了之前配置的pwsh的配置文件。 可以使用`code $PROFILE`, 打开pwsh的配置文件。

然后再配置文件中设置环境变量， 之后重启vscode, 环境变量就正常能读取到了。

```
# 文件名 Microsoft.PowerShell_profile.ps1
$env:ELECTRON_MIRROR="https://npmmirror.com/mirrors/electron/"
```


# 参考
- https://www.zhihu.com/question/266858097