---
title: "python:3.7-alpine镜像安装pycrypto报错"
date: "2020-07-03 10:11:25"
draft: false
---

# 报错内容
```
 checking for gcc... gcc
    checking whether the C compiler works... no
    configure: error: in `/tmp/pip-install-cxvq7zto/pycrypto':
    configure: error: C compiler cannot create executables
```


# 解决方案

```
apk add gcc g++ make libffi-dev openssl-dev
```

然后 pip install pycrypto



# 参考资料

- [https://stackoverflow.com/questions/35397295/pycrypto-for-python3-in-alpine](https://stackoverflow.com/questions/35397295/pycrypto-for-python3-in-alpine)

