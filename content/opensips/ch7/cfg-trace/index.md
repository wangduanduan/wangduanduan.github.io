---
title: "script_trace 打印opensips的脚本执行过程"
date: "2020-05-27 16:54:47"
draft: false
---
script_trace是核心函数，不需要引入模块。

```makefile
script_trace([log_level, pv_format_string[, info_string]])
```

```makefile
This function start the script tracing - this helps to better understand the flow of execution in the OpenSIPS script, like what function is executed, what line it is, etc. Moreover, you can also trace the values of pseudo-variables, as script execution progresses.

The blocks of the script where script tracing is enabled will print a line for each individual action that is done (e.g. assignments, conditional tests, module functions, core functions, etc.). Multiple pseudo-variables can be monitored by specifying a pv_format_string (e.g. "$ru---$avp(var1)").

The logs produced by multiple/different traced regions of your script can be differentiated (tagged) by specifying an additional plain string - info_string - as the 3rd parameter.

To disable script tracing, just do script_trace(). Otherwise, the tracing will automatically stop at the end the end of the top route.

Example of usage:

    script_trace( 1, "$rm from $si, ruri=$ru", "me");
will produce:
```

```makefile
[line 578][me][module consume_credentials] -> (INVITE from 127.0.0.1 , ruri=sip:111211@opensips.org)
[line 581][me][core setsflag] -> (INVITE from 127.0.0.1 , ruri=sip:111211@opensips.org)
[line 583][me][assign equal] -> (INVITE from 127.0.0.1 , ruri=sip:111211@opensips.org)
[line 592][me][core if] -> (INVITE from 127.0.0.1 , ruri=sip:tester@opensips.org)
[line 585][me][module is_avp_set] -> (INVITE from 127.0.0.1 , ruri=sip:tester@opensips.org)
[line 589][me][core if] -> (INVITE from 127.0.0.1 , ruri=sip:tester@opensips.org)
[line 586][me][module is_method] -> (INVITE from 127.0.0.1 , ruri=sip:tester@opensips.org)
[line 587][me][module trace_dialog] -> (INVITE 127.0.0.1 , ruri=sip:tester@opensips.org)
[line 590][me][core setflag] -> (INVITE from 127.0.0.1 , ruri=sip:tester@opensips.org) 
```

