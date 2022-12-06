---
title: "CANCEL请求和Reason头"
date: "2020-04-10 10:21:36"
draft: false
---
原文：[https://blog.opensips.org/2016/12/29/understanding-and-dimensioning-memory-in-opensips/](https://blog.opensips.org/2016/12/29/understanding-and-dimensioning-memory-in-opensips/)

> Call canceling may look like a trivial mechanism, but it plays an important role in complex scenarios like simultaneous ringing (parallel forking), call pickup, call redirect and many others.
> So, aside proper routing of CANCEL requests, reporting the right cancelling reason is equally important.



# 如何正确的处理cancel请求？

According to [RFC 3261](https://www.ietf.org/rfc/rfc3261.txt),** a CANCEL must be route to the exact same destination (IP, port, protocol) and with the same exact Request-URI as the INVITE it is canceling**. This is required in order to guarantee that the CANCEL will end up (via the same SIP route) in the same place as the INVITE.<br />So, **the CANCEL must follow up the INVITE.** But how to do and script this?

If you run **[OpenSIPS](http://www.opensips.org/)** in a **stateless mode**, there is no other way then taking care of this at script level – apply the same dialplan and routing decisions for the CANCEL as you did for the INVITE. As stateless proxies usually have simple logic, this is not something difficult to do.

But what if the routing logic is complex, involving factors that make it hard to reproduce when handling the CANCEL? For example, the INVITE routing may depend on time conditions or dynamic data (that may change at any time).

In such cases, you must rely on a **stateful routing** (SIP transaction based). **Basically the transaction engine in **[**OpenSIPS**](http://www.opensips.org/)** will store and remember the information on where and how the INVITE was routed,** so there is not need to “reproduce” that for the CANCEL request – you just fetch it from the transaction context. So, all the heavy lifting is done by the [TM (transaction) module](http://www.opensips.org/html/docs/modules/2.2.x/tm.html#id248922) – you just have to invoke it:

```bash
if ( is_method("CANCEL") ) {
    t_relay();
    exit;
}
```

As you can see, there is no need to do any explicit routing for CANCEL requests – you just ask TM module to do it for you – as soon as the module sees you try to route a CANCEL,** it will automatically fetch the needed information from the INVITE transaction and set the proper routing **– all this magic happens inside the [t_relay()](http://www.opensips.org/html/docs/modules/2.2.x/tm.html#id294569) function.

Now, **[OpenSIPS](http://www.opensips.org/)** is a multi-process application and INVITE requests may take time to be routed (due complex logic involving external queries or I/Os like DB, REST or others). So, you may end up with **[OpenSIPS](http://www.opensips.org/)** handing the INVITE request in one process (for some time) while the corresponding CANCEL request starts being handled in another process. This may lead to some race conditions – if the INVITE is not yet processed and routed out, how will **[OpenSIPS](http://www.opensips.org/)** know what to do with the CANCEL??

> 多进程模式下的INVITE和CANCEL可能会导致条件竞争


Well, if you cannot solve a race condition, better avoid it :). How? Postpone the CANCEL processing until the INVITE is done and routed. How? If there is no transaction created yet for the INVITE, avoid handling the CANCEL by simply dropping it – no worries, **we will not lose the CANCEL as by dropping it, we will force the caller device to resend it over again.**

So, we enhance our CANCEL scripting by checking for the INVITE transaction – this can be done via the [t_check_trans()](http://www.opensips.org/html/docs/modules/2.2.x/tm.html#id295027) function. If we do not find the INVITE transaction, simple exit to drop the CANCEL request:

```bash
if ( is_method("CANCEL") ) {
    if ( t_check_trans() )
        t_relay();
    exit;
}
```


# 如何控制CANCEL请求Reason头？

Propagating a correct Reason info in the CANCEL requests is equally important. For example, depending on the Reason for the canceled incoming call, a callee device may report it as a missed call (if the Reason header indicates a caller cancelling) or not (if the Reason header indicates that the call has established somewhere else, due to parallel forking).

So, you need to pay attention to propagating or inserting the Reason info into the CANCEL requests!<br />For CANCEL requests built by **[OpenSIPS](http://www.opensips.org/)** , the Reason header is inserted all the time, in order to reflect the reason for generating the CANCEL:

- _SIP;cause=480;text=”NO_ANSWER”_ – if the cancelling was a result of an INVITE timeout;
- _SIP;cause=200;text=”Call completed elsewhere”_ – if the cancelling was due to parallel forking (another branch of the call was answered);
- _SIP;cause=487;text=”ORIGINATOR_CANCEL”_ – if the cancelling was received from a previous SIP hop (due an incoming CANCEL).

So,** by default, **[**OpenSIPS**](http://www.opensips.org/)** will discard the Reason info for the CANCEL requests that are received and relayed further** (and force the “ORIGINATOR_CANCEL” reason). But there are many cases when you want to keep and propagate further the incoming Reason header. To do that, you need to set the _“0x08”_ flag when calling the [t_relay()](http://www.opensips.org/html/docs/modules/2.2.x/tm.html#id294569) function for the CANCEL:

```bash
if ( is_method("CANCEL") ) {
    if ( t_check_trans() )
        # preserve the received Reason header
        t_relay("8");
    exit;
}
```

If there is no Reason in the incoming CANCEL, the default one will be inserted by **[OpenSIPS](http://www.opensips.org/)** in the outgoing CANCEL.<br />Even more, starting with the 2.3 version, **[OpenSIPS](http://www.opensips.org/)** allows you to inject your own Reason header, by using the [t_add_cancel_reason()](http://www.opensips.org/html/docs/modules/2.3.x/tm.html#id295686) function:

```bash
if ( is_method("CANCEL") ) {
    if ( t_check_trans() ) {
        t_add_cancel_reason('Reason: SIP ;cause=200;text="Call completed elsewhere"\r\n');
        t_relay();
    }
    exit;
}
```



This function gives you full control over the Reason header and allows various implementation of complex scenarios, especially SBC and front-end like.


