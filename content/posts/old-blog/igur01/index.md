---
title: "powershell oh-my-posh 加载数据太慢"
date: "2022-07-09 12:31:09"
draft: false
---

每次打开新的标签页，Powershell 都会输出下面的代码

```
Loading personal and system profiles took 3566ms.
```

时间不固定，有时1s到10s都可能有，时间不固定。 这个加载速度是非常慢的。

然后我打开一个非oh-my-posh的窗口，输入

```
oh-my-posh debug
```

看到其中几行日志：

```
2022/07/09 12:20:23 error: HTTPRequest
Get "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/v8.15.0/themes/default.omp.json": context deadline exceeded
2022/07/09 12:20:23 HTTPRequest duration: 5.0072715s, args: https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/v8.15.0/themes/default.omp.json
2022/07/09 12:20:23 downloadConfig duration: 5.0072715s, args: https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/v8.15.0/themes/default.omp.json
2022/07/09 12:20:23 resolveConfigPath duration: 5.0072715s, args:
2022/07/09 12:20:23 Init duration: 5.0072715s, args:
```

好家伙，原来每次启动，oh-my-posh还去github上下载了一个文件。

因为下载文件而拖慢了整个启动过程。

然后在github issue上倒找：[https://github.com/JanDeDobbeleer/oh-my-posh/issues/2251](https://github.com/JanDeDobbeleer/oh-my-posh/issues/2251)

> oh-my-posh init pwsh --config ~/default.omp.json


其中关键一点是启动oh-my-posh的时候，如果不用--config配置默认的文件，oh-my-posh就回去下载默认的配置文件。

所以问题就好解决了。

首先下载[https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/v8.15.0/themes/default.omp.json](https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/v8.15.0/themes/default.omp.json) 这个文件，然后再保存到用户的家目录里面。

然后打开terminal,  输入： code $profile

前提是你的电脑上要装过vscode,  然后给默认的profile加上--config参数，试了一下，问题解决。

```
oh-my-posh init pwsh --config ~/default.omp.json | Invoke-Expression
Import-Module PSReadLine
New-Alias -Name ll -Value ls

if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
    Set-PSReadLineOption -EditMode Emacs
}
```

