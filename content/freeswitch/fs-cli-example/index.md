---
title: "fs_cli 例子"
date: "2020-04-07 17:40:16"
draft: false
---
<a name="7QGeh"></a>
# 1. 设置日志级别
每个快捷键对应一个功能，具体配置位于 /conf/autoload_configs/switch.conf.xml

```bash
F1. help
F2. status
F3. show channels
F4. show calls
F5. sofia status
F6. reloadxml
F7. console loglevel 0
F8. console loglevel 7
F9. sofia status profile internal
F10. sofia profile intrenal siptrace on
F11. sofia profile internal siptrace off
F12. version
```


<a name="3wsZh"></a>
# 2. 发起呼叫相关
下面的命令都是同步的命令，可以在所有命令前加bgapi命令，让originate命令后台异步执行。

<a name="5ugfl"></a>
## 2.1 回音测试
```bash
originate user/1000 &echo
```

<a name="793VC"></a>
## 2.2 停泊

```bash
originate user/1000 &park  # 停泊
```

<a name="g8jAF"></a>
## 2.3 保持
```bash
originate user/1000 &hold # 保持
```

<a name="3I1Rz"></a>
## 2.4 播放放音
```bash
originate user/1000 &playback(/root/welclome.wav) # 播放音乐
```

<a name="EbAyG"></a>
## 2.5 呼叫并录音
```bash
originate user/1000 &record(/tmp/vocie_of_alice.wav) # 呼叫并录音
```

<a name="SDfP3"></a>
## 2.6 同振与顺振
```bash
#经过特定的SIP服务器发起外呼，下面的命令会将INVITE先发送到192.168.2.4:5060上
bgapi originate sofia/external/8005@001.com;fs_path=sip:192.168.2.4:5060 &echo 
```

<a name="WAMAl"></a>
## 2.7 经过特定SIP服务器
```bash
#经过特定的SIP服务器发起外呼，下面的命令会将INVITE先发送到192.168.2.4:5060上
bgapi originate sofia/external/8005@001.com;fs_path=sip:192.168.2.4:5060 &echo 
```

<a name="rCFgs"></a>
## 2.8 忽略early media
```bash
originate {ignore_early_media=true}user/1000 &echo
```

<a name="MFYuO"></a>
## 2.9 播放假的early media

```bash
originate {transfer_ringback=local_stream://moh}user/1000 &echo
```

<a name="ezad4"></a>
## 2.10 立即播放early media
```bash
originate {instant_ringback=true}{transfer_ringback=local_stream://moh}user/1000 &echo
```

<a name="EIVG9"></a>
## 2.11 设置外显号码

```bash
originate {origination_callee_id_name=7777}user/1000
```

通道变量将影响呼叫的行为。fs的通道变量非常多，就不再一一列举。具体可以参考。下面的链接

- [https://freeswitch.org/confluence/display/FREESWITCH/Channel+Variables#app-switcher](https://freeswitch.org/confluence/display/FREESWITCH/Channel+Variables#app-switcher)
- [https://freeswitch.org/confluence/display/FREESWITCH/Channel+Variables+Catalog](https://freeswitch.org/confluence/display/FREESWITCH/Channel+Variables+Catalog)

