---
title: "统一入口Makefile"
date: "2020-08-22 11:41:32"
draft: false
---
```bash
Makefile
---src
   |___Makefile
   |___main.c
```

如何编写顶层的Makefiel, 使其进入到src中，执行src中的Makefile?

```bash
run:
	$(MAKE) -C src target a=1 b=2
```


