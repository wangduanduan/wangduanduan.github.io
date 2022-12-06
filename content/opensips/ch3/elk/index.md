---
title: "opensips日志写入elasticsearch"
date: "2019-09-19 09:01:40"
draft: false
---

# 构造json

```bash
$json(body) := "{}";
$json(body/time) = $time(%F %T-0300);
$json(body/sipRequest) = “INVITE”;
$json(body/ipIntruder) = $si;
$json(body/destNum) = $rU;
$json(body/userAgent) = $ua;
$json(body/country)=$var(city);
$json(body/location)=$var(latlon);
$json(body/ipHost) = $Ri;
```


# 使用async rest_post写数据

- async好像存在于2.1版本及其以上， 异步的好处是不会阻止脚本的继续执行

```bash
async(rest_post("http://user:password@w.x.y.z:9200/opensips/1", "$json(body)", "$var(ctype)",
"$var(ct)", "$var(rcode)"),resume)
```


