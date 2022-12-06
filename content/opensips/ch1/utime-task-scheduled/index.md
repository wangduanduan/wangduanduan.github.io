---
title: "utimer task <tm-utimer> already scheduled"
date: "2022-10-25 12:06:54"
draft: false
---

- 可能和avp_db_query有关 
   - [https://opensips.org/pipermail/users/2018-October/040157.html](https://opensips.org/pipermail/users/2018-October/040157.html)
> _What we found is that the warning go away if we comment out the single avp_db_query that is being used in our config._
> >_ The avp_db_query is not executed at the start, but only when specific header is present. Yet the fooding start immediately after opensips start. The mere presence of the avp_db_query function in config without execution is enough to have the issue._


- 可能和openssl库有关
   - [https://github.com/OpenSIPS/opensips/issues/1771#issuecomment-517744489](https://github.com/OpenSIPS/opensips/issues/1771#issuecomment-517744489)
> ere are your results. I'm attaching the full backtrace (looks about the same) and the logs containing the memory debug. Please let me know if you need additional info.


- 这个讨论很有价值 感觉和curl超时有关
   - [https://github.com/OpenSIPS/opensips/issues/929](https://github.com/OpenSIPS/opensips/issues/929)
> I checked with a tcpdump, and that http request was answered after 40ms, but opensips missed it.
> Another strange thing is that despite of the use of async, opensips does not process any other SIP request while waiting for this missing answer, I see because with default params, with 20s timeout, opensips didn't process REGISTER request and SIP endpoints unregistered, this is the reason because I changed connection timeout to 1s.


> I've discovered that this issue occured only if http keepalive (tcp persistent connection) is enabled.
> I've simply added "KeepAlive Off" directive in httpd configuration and the problem stopped.

> I hope this info will be useful for debugging.


- 使用opensipsctl trap 可以产生调用栈文件
> WARNING:core:utimer_ticker: utimer task <tm-utimer> already scheduled for 8723371990 ms (now 8723387850 ms), it may overlap.



# 参考资料

- [https://github.com/OpenSIPS/opensips/issues/1767](https://github.com/OpenSIPS/opensips/issues/1767)
- [https://opensips.org/pipermail/users/2018-October/040151.html](https://opensips.org/pipermail/users/2018-October/040151.html)
- [https://github.com/OpenSIPS/opensips/issues/2183](https://github.com/OpenSIPS/opensips/issues/2183)
- [https://github.com/OpenSIPS/opensips/issues/1858](https://github.com/OpenSIPS/opensips/issues/1858)
- [https://opensips.org/pipermail/users/2019-August/041454.html](https://opensips.org/pipermail/users/2019-August/041454.html)
- [https://opensips.org/pipermail/users/2017-October/038209.html](https://opensips.org/pipermail/users/2017-October/038209.html)