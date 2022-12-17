---
title: "tar打包小技巧: 替换根目录"
date: "2020-10-27 11:23:48"
draft: false
---
环境mac

```bash
# 这个目录打包之后，内部的顶层目录是dist, 解压之后，有可能覆盖到以前的dist
tar -zcvf demo.tar.gz dist/

# 使用这个命令，顶层目录将会被修改成demo-0210
tar -s /^dist/demo-0210/ -zcvf demo.tar.gz dist/
```


