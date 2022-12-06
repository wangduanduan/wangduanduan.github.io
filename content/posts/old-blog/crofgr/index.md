---
title: "windows 上的命令行体验"
date: "2022-07-09 12:43:14"
draft: false
---
我已经有5年没有用过windows了，再次在windows上搞开发，发现了windows对于开发者来说，友好了不少。

首先是windows terminal,  这个终端做的还不错。

其次是一些常用的命令，比如说ssh, scp等，都已经默认附带了，不用再安装。

还有包管理工具scoop,  命令行提示工具 oh-my-posh,  以及powershell 7 加载一起，基本可以迁移80%左右的linux上的开发环境。

特别要说明一下scoop， 这个包管理工具，我安装了在linux上常用的一些软件。

包括有以下的软件，而且软件的版本都还蛮新的。

```
0ad           0.0.25b          games  
7zip          22.00            main  
curl          7.84.0_4         main  
curlie        1.6.9            main   
diff-so-fancy 1.4.3            main  
duf           0.8.1            main  
everything                            
gawk          5.1.1            main  
git           2.37.0.windows.1 main   
git-aliases   0.3.5            extras
git-chglog    0.15.1           main   
gzip          1.3.12           main  
hostctl       1.1.2            main  
hugo          0.101.0          main  
jq            1.6              main   
klogg         22.06.0.1289     extras 
make          4.3              main   
neofetch      7.1.0            main  
neovim        0.7.2            main  
netcat        1.12             main   
nodejs-lts    16.16.0          main   
ntop          0.3.4            main   
procs         0.12.3           main   
ripgrep       13.0.0           main  
sudo          0.2020.01.26     main   
tar           1.23             main  
```

另外一个就是powershell 7了，贴下我的profile配置。

智能提示，readline都有了

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

