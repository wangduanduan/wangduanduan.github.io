---
title: "sip消息分发之dispatcher模块"
date: "2019-06-18 10:51:15"
draft: false
---
dispatcher模块用来分发sip消息。


# dispatcher如何记录目的地状态

dispatcher会使用一张表。

需要关注两个字段destionations， state。

- destionations表示sip消息要发往的目的地
- state表示对目的地的状态检测结果
   - 0 可用
   - 1 不可用
   - 2 表示正在检测

opensips只会想可用的目的地转发sip消息

| id | setid | destionations | state |
| --- | --- | --- | --- |
| 1 | 1 | sip:p1:5060 | 0 |
| 2 | 1 | sip:p2:5060 | 1 |
| 3 | 1 | sip:p2:5061 | 2 |


# dispatcher如何检测目的地的状态

本地的opensips会周期性的向目的地发送options包，如果对方立即返回200ok, 就说明目的地可用。

![](https://cdn.nlark.com/yuque/__puml/98cd369b3c409e98c2ca3487fb756659.svg#lake_card_v2=eyJjb2RlIjoiQHN0YXJ0dW1sXG5sb2NhbGhvc3QgLT4gcDE6IE9QVElPTiByZXF1ZXN0XG5wMSAtLT4gbG9jYWxob3N0OiAyMDAgb2tcbkBlbmR1bWwiLCJ1cmwiOiJodHRwczovL2Nkbi5ubGFyay5jb20veXVxdWUvX19wdW1sLzk4Y2QzNjliM2M0MDllOThjMmNhMzQ4N2ZiNzU2NjU5LnN2ZyIsInR5cGUiOiJwdW1sIiwiaWQiOiI1ckl1SyIsImNhcmQiOiJkaWFncmFtIn0=)
在达到一定阈值后，目的地一直无响应，则opensips将其设置为不可用状态，或者正在检测状态。如下图所示

![](https://cdn.nlark.com/yuque/__puml/cdb38f9043b0ac503750d554af0a4668.svg#lake_card_v2=eyJjb2RlIjoiQHN0YXJ0dW1sXG5sb2NhbGhvc3QgLT4gcDI6IE9QVElPTiByZXF1ZXN0XG5sb2NhbGhvc3QgLT4gcDI6IE9QVElPTiByZXF1ZXN0XG5sb2NhbGhvc3QgLT4gcDI6IE9QVElPTiByZXF1ZXN0XG5sb2NhbGhvc3QgLT4gcDI6IE9QVElPTiByZXF1ZXN0XG5AZW5kdW1sIiwidXJsIjoiaHR0cHM6Ly9jZG4ubmxhcmsuY29tL3l1cXVlL19fcHVtbC9jZGIzOGY5MDQzYjBhYzUwMzc1MGQ1NTRhZjBhNDY2OC5zdmciLCJ0eXBlIjoicHVtbCIsImlkIjoiUnBhWGkiLCJjYXJkIjoiZGlhZ3JhbSJ9)


# 代码例子

ds_select_dst()函数会去选择可用的目的地，并且设置当前sip消息的转发地址。如果发现无用可转发地址，则进入504 服务不可用的逻辑。

如果sip终端注册时返回504，则可以从dispatcher模块，排查看看是不是所有的目的地都处于不可用状态。

```bash
if (!ds_select_dst("1", "0")) {
	send_reply("504","Service Unavailable");
  exit;
}
```


