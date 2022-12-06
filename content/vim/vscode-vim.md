---
title: "vscode vim插件自定义快捷键"
date: 2022-05-28T11:20:30+08:00
draft: false
---

我承认，vscode很香，但是vim的开发方式也让我无法割舍。

vscode中有个vim插件，基本上可以满足大部分vim的功能。

这里我定义了我在vim常用的leader快捷键。


# 设置,为默认的leader

```
"vim.leader": ",",
```

# 在Normal模式能comand+c复制

```
    "vim.handleKeys": {
        "<C-c>": false,
        "<C-v>": false
    },
```

# leader快捷键
- 在插入模式安jj会跳出插入模式
- ,a:  跳到行尾部，并进入插入模式
- ,c: 关闭当前标签页
- ,C: 关闭其他标签页
- ,j: 跳转到左边标签页
- ,k: 跳转到右边标签页
- ,w: 保存文件
- ,t: 给出提示框
- ,b: 显示或者隐藏文件树窗口

# 完整的配置

```
    "vim.leader": ",",
    "vim.insertModeKeyBindings": [
        {
            "before": [ "j", "j" ],
            "after": [ "<Esc>" ]
        }
    ],
    "vim.handleKeys": {
        "<C-c>": false,
        "<C-v>": false
    },
    "vim.normalModeKeyBindingsNonRecursive": [
        {
            "before": [ "<leader>", "a" ],
            "after": [ "A" ]
        },
        {
            "before": [ "<leader>", "c" ],
            "commands": [ "workbench.action.closeActiveEditor" ]
        },
        {
            "before": [ "<leader>", "C" ],
            "commands": [ "workbench.action.closeOtherEditors" ]
        },
        {
            "before": [ "<leader>", "j" ],
            "commands": [ "workbench.action.previousEditor" ]
        },
        {
            "before": [ "<leader>", "k" ],
            "commands": [ "workbench.action.nextEditor" ]
        },
        {
            "before": [ "<leader>", "w" ],
            "commands": [ "workbench.action.files.save" ]
        },
        {
            "before": [ "<leader>", "t" ],
            "commands": [ "editor.action.showHover" ]
        },
        {
            "before": [ "<leader>", "b" ],
            "commands": [ "workbench.action.toggleSidebarVisibility" ]
        },
    ]
```
