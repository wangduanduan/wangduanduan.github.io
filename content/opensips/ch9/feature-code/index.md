---
title: "SIP feature codes SIP功能码"
date: "2021-03-17 10:57:45"
draft: false
---

# 功能描述
用户可以拨打一个特殊的号码，用来触发特定的功能。<br />常见的功能码一般以 `*` 开头，例如

- `*1` 组内代接
- `*1(EXT)` 代接指定的分机
- `*2` 呼叫转移
- `**87` 请勿打扰
- ...

上面的栗子，具体的功能码，对应的业务逻辑是可配置的。


# 场景举例
我的分机是8001，我看到8008的分机正在振铃，此时我需要把电话接起来。但是我不能走到8008的工位上去接电话，我必须要在自己的工位上接电话。

那么我在自己的分机上输入<br />`*18008`  这时SIP服务端就知道你想代8008接听正在振铃的电话。

说起来功能码就是一种使用话机上按键的一组暗号。

话机上一般只有0-9*#，一共12个按键。没法办用其他的编码告诉服务端自己想做什么，所以只能用功能码。



# 参考

- [https://www.ipcomms.net/support/myoffice-pbx/feature-codes](https://www.ipcomms.net/support/myoffice-pbx/feature-codes)
- [https://www.cisco.com/c/en/us/td/docs/voice_ip_comm/cucme/admin/configuration/manual/cmeadm/cmefacs.pdf](https://www.cisco.com/c/en/us/td/docs/voice_ip_comm/cucme/admin/configuration/manual/cmeadm/cmefacs.pdf)
- [https://help.yeastar.com/en/s-series/topic/feature_code.html?hl=feature%2Ccode&_ga=2.76562834.622619423.1615949948-1155631884.1615949948](https://help.yeastar.com/en/s-series/topic/feature_code.html?hl=feature%2Ccode&_ga=2.76562834.622619423.1615949948-1155631884.1615949948)

