---
title: "SIP bridging over multiple interfaces"
date: "2020-07-16 14:20:50"
draft: false
---
There are scenarios where you need OpenSIPS to route SIP traffic across more than one IP interface. Such a typical scenario is where OpenSIPS is required to perform bridging. The bridging may be between different IP networks (like public versus private, IPv4 versus IPv6) or between different transport protocols for SIP (like UDP versus TCP versus TLS).<br />So, how do we switch to a different outbound interface in OpenSIPS ?


# Auto detection

OpenSIPS has a built in automatic way of picking up the right outbound interface, the so called “Multi homed” support or shortly “mhomed”, controlled by the mhomed  core parameter.<br />The auto detection is done based on the destination IP of the SIP message. OpenSIPS will ‘query’ the kernel routing table to see which interface (on the server) is able to route to the needed destination IP.

# 

## Example

If we have an OpenSIPS listening on 1.2.3.4 public interface and 10.0.0.4 private interface and we need to send the SIP message to 10.0.0.100, the kernel will indicate that 10.0.0.100 is reachable/routable only via 10.0.0.4, so OpenSIPS will use that listener.


## Advantages

This a very easy way to achieve multi-interface routing, without any extra scripting logic. You just have to switch a single option and it simply works.


## Disadvantages

First of all there is performance penalty here as each time a SIP message is sent out OpenSIPS will have to query the kernel for the right outbound interface.<br />Also there are some limitation – as this auto detection is based on the kernel routing table, this approach can be used only when routing between different types of networks like private versus public or IPv4 versus IPv6. It cannot be used for switching between different SIP transport protocols.<br />Even more, there is another limitation here – you need to correlate the kernel IP routing table with the listeners you have in OpenSIPS, otherwise you may end up in a situation where the kernel indicates as outbound interface an IP that it is not configured as listener in OpenSIPS!


# Manual selection

An alternative is to explicitly indicate to OpenSIPS what the outbound interface should be, based on the logic from the routing script. Like if my routing logic says that the call is to be sent to an end-point and I know that all my end-points are on the public network, then I can manually indicate OpenSIPS to use the listener on the public network. Or if my routing logic says that the call goes to a media server located in a private network, then I will instruct OpenSIPS to use the private listener.<br />How do you do this? You can indicate the outbound interface/socket by “forcing the send socket” with the $fs variable.<br />As the send socket description also contains indication for the transport protocol, this approach can be used for switching between different SIP transport protocols:

```bash
# switch from TCP to UDP, preserving the IP

if ($proto == "TCP") $fs = "udp:" + $Ri + ":5060";

```
Manually setting the outbound interface is usually done only for the initial requests (without the To header “;tag=” parameter). Why? As you have to anchor the dialog into your OpenSIPS (otherwise the sequential requests will not be routed in bridging mode), you will do either record_route(), either topology_hiding(). These two ways of anchoring dialogs in OpenSIPS guarantees that all sequential requests will follow the same interface switching / bridging as the initial request. Like if you do the interface switch at INVITE time, there is no need for additional scripting for in-dialog requests (ACK, re-INVITE, BYE, etc.). Shortly, any custom interface handling is to be done only for the initial requests.

## Example

Assuming the end-points are in the public interface and the media servers are in the private network, let’s see how the logic should be.<br />But first, an useful hint : if your routing is based on lookup(“location”), there is no need to do manual setting of the outbound interface as the lookup() function will do this for you – it will automatically force as outbound interface the interface the corresponding REGISTER was received on ;).

```bash
# is it a call to a media service (format *33xxxxx) ?
if ($rU=~"^*33[0-9]+$")) {
	$fs = "udp:10.0.0.100:5060";
	route(to_media);
	exit;
}
```


## Advantages

This is a very rigorous way of controlling the interface switching in your OpenSIPS script, being able to cover all cases of network or protocol switching.<br />Also, this adds zero performance penalty!

## Disadvantages

You need to do some extra scripting and to correlate your  SIP routing logic with the IP/transport switching logic. Nevertheless, it is very easy to do – just set a variable, so it will not pollute your script.

# 

# Conclusions

Each approach has some clear advantages – if the auto-detection is very very simple to use for some simple scenarios, the manual selection is more powerful and complex but needs some extra scripting and SIP understanding.<br />If you want to learn more, join us for the upcoming OpenSIPS Bootcamp training session and become a skillful OpenSIPS user! :).


原文地址：[https://blog.opensips.org/2018/09/04/sip-bridging-over-multiple-interfaces/](https://blog.opensips.org/2018/09/04/sip-bridging-over-multiple-interfaces/)

