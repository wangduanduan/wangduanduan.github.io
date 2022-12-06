---
title: "Fatal process OOM in insufficient memory to create an Isolate"
date: "2021-05-21 12:01:00"
draft: false
---

环境： ARM64
```bash

<--- Last few GCs --->


<--- JS stacktrace --->


#
# Fatal process OOM in insufficient memory to create an Isolate
#

```

在Dockerfile上设置**max-old-space-size**的node.js启动参数， 亲测有效。

```bash
CMD node --report-on-fatalerror --max-old-space-size=1536 dist/index.js
```

> Currently, by default v8 has a memory limit of 512mb on 32-bit and 1gb on 64-bit systems. You can raise the limit by setting --max-old-space-size to a maximum of ~1gb for 32-bit and ~1.7gb for 64-bit systems. But it is recommended to split your single process into several workers if you are hitting memory limits.

# 参考

- [https://nodejs.org/api/cli.html#cli_max_old_space_size_size_in_megabytes](https://nodejs.org/api/cli.html#cli_max_old_space_size_size_in_megabytes)
- [https://stackoverflow.com/questions/54919258/ng-commands-throws-insufficient-memory-error-fatal-process-oom-in-insufficient](https://stackoverflow.com/questions/54919258/ng-commands-throws-insufficient-memory-error-fatal-process-oom-in-insufficient)
- [https://medium.com/@vuongtran/how-to-solve-process-out-of-memory-in-node-js-5f0de8f8464c](https://medium.com/@vuongtran/how-to-solve-process-out-of-memory-in-node-js-5f0de8f8464c)


