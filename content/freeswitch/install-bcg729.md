---
title: "安装bcg729模块"
date: 2022-05-28T17:34:13+08:00
---

g729编码的占用带宽是g711的1/8，使用g729编码，可以极大的降低带宽的费用。fs原生的mod_g927模块是需要按并发数收费的，但是我们可以使用开源的bcg729模块。

这里需要准备两个仓库，为了加快clone速度，我将这两个模块导入到gitee上。

- https://gitee.com/wangduanduan/mod_bcg729
- https://gitee.com/wangduanduan/bcg729

安装前提
已经安装好了freeswitch, 编译mod_bcg729模块，需要指定freeswitch头文件的位置

# step0: 切换到工作目录
```
cd /usr/local/src/
```

# step1: clone mod_bcg729

```
git clone https://gitee.com/wangduanduan/mod_bcg729.git
```

# step2: clone bcg729
mod_bcg729模块在编辑的时候，会检查当前目录下有没有bcg729的目录。
如果没有这个目录，就会从github上clone bcg729的项目。
所以我们可以在编译之前，先把bcg729 clone到mob_bcg729目录下

```
cd mod_bcg729
git clone https://gitee.com/wangduanduan/bcg729.git
```

# step3: 编辑mod_bcg729
编译mod_bcg729需要指定fs头文件switch.h的位置。
在Makefile项目里有FS_INCLUDES这个变量用来定义fs头文件的位置

```
FS_INCLUDES=/usr/include/freeswitch
FS_MODULES=/usr/lib/freeswitch/mod
```

如果你的源码头文件路径不是/usr/include/freeswitch， 则需要在执行make命令时通过参数指定， 例如下面编译的时候。

```
make FS_INCLUDES=/usr/local/freeswitch/include/freeswitch
```

{{< notice tip >}}
如何找到头文件的目录？
头文件一般在fs安装目录的include/freeswitch目录下
如果还是找不到，则可以使用 find /usr -name switch.h -type f  搜索对应的头文件
{{< /notice >}}

# step4: 复制so文件
mod_bcg729编译之后，可以把生成的mod_bcg729.so拷贝到fs安装目录的mod目录下

# step5: 加载模块
命令行加载

```
load mod_bcg729
```

配置文件加载
命令行加载重启后就失效了，可以将加载的模块写入到配置文件中。
在modules.conf.xml中加入

```
<load module="mod_bcg729"/>
```

# step5: vars.xml修改

```
 <X-PRE-PROCESS cmd="set" data="global_codec_prefs=PCMU,PCMA,G729" />
 <X-PRE-PROCESS cmd="set" data="outbound_codec_prefs=PCMU,PCMA,G729"/>
 <X-PRE-PROCESScmd="set"data="media_mix_inbound_outbound_codecs=true"/>
```

# step6: sip profile修改
开启转码

```
<param name="disable-transcoding" value="false"/>
```

然后重启fs, 进入到fs_cli中，输入: show codec, 看看有没有显示729编码。然后就是找话机，测试g729编码了。
