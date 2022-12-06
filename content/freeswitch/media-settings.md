---
title: "FreeSWITCH 媒体相关操作"
date: 2022-05-28T14:50:55+08:00
draft: false
tags:
- FreeSWITCH
---

# 查看FS支持的编码

```
show codec
```

# 编码设置

vars.xml

```
global_codec_prefs=G722,PCMU,PCMA,GSM
outbound_codec_prefs=PCMU,PCMA,GSM
```

# 查看FS使用的编码

```
> sofia status profile internal
CODECS IN         ILBC,PCMU,PCMA,GSM
CODECS OUT        ILBC,PCMU,PCMA,GSM

> sofia status profile external
CODECS IN         ILBC,PCMU,PCMA,GSM
CODECS OUT        ILBC,PCMU,PCMA,GSM
```

# 使修改后的profile生效

```
> sofia profile internal rescan
> sofia profile external rescan
```
# 重启profile

```
> sofia profile internal restart
> sofia profile external restart
```



