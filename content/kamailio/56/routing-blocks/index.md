---
title: "1.16 路由块 - 请求路由、响应路由、分支路由、失败路由等"
draft: false
tags:
- all
categories:
- all
---


#  1. Routing Blocks

The routing blocks are the parts of the configuration file executed by
kamailio at runtime. They can be seen as blocks of actions similar to
functions (or procedures) from common programming languages.

A routing block is identified by a specific token, followed by a name in
between square brackets and actions in between curly braces.

``` c
route_block_id[NAME] {
  ACTIONS
}
```

The name can be any alphanumeric string, with specific routing blocks
enforcing a particular format.

🔥**IMPORTANT**: Note: `route(number)` is equivalent to `route("number")`.

Route blocks can be executed on network events (e.g., receiving a SIP
message), timer events (e.g., retransmission timeout) or particular
events specific to modules.

There can be so called sub-route blocks, which can be invoked from
another route blocks, like a function. Invocation is done with `route`
followed by the name of sub-route to execute, enclosed in between
parentheses.

Example:

``` c
  request_route{
    ...
    route("test");
    ...
  }

  route["test"]{
    ...
  }
```

# 2. request_route

Request routing block - is executed for each SIP request.

It contains a set of actions to be executed for SIP requests received
from the network. It is the equivalent of `main()` function for
handling the SIP requests.

🔥**IMPORTANT**: For backward compatibility reasons, the main request
`route` block can be identified by `route{...}` or
`route[0]{...}`'.

The implicit action after execution of the main route block is to drop
the SIP request. To send a reply or forward the request, explicit
actions (e.g., sl_send_reply(), forward(), t_relay()) must be called
inside the route block.

Example of usage:

``` c
    request_route {
         if(is_method("OPTIONS")) {
            # send reply for each options request
            sl_send_reply("200", "ok");
            exit();
         }
         route(FWD);
    }
    route[FWD] {
         # forward according to uri
         forward();
    }
```

# 3. route

This block is used to define 'sub-routes' - group of actions that can be
executed from another routing block. Originally targeted as being
executed from 'request_route', it can be executed now from all the other
blocks. Be sure you put there the actions valid for the root routing
block executing the sub-route.

The definition of the sub-route block follows the general rules, with a
name in between square brackets and actions between curly braces. A
sub-route can return an integer value back to the routing block that
executed it. The return code can be retrieved via $rc variables.

Evaluation of the return of a subroute is done with following rules:

- negative value is evaluated as false
- 0 - is interpreted as **exit**
- positive value is evaluated as true

``` c
request_route {
  if(route(POSITIVE)) {
    xlog("return number is positive\n");
  }
  if( ! route(NEGATIVE)) {
    xlog("return number is negative\n");
  }
  if( route(ZERO)) {
    xlog("this log message does not appear\n");
  }
}

route[POSITIVE] {
  return 10;
}

route[NEGATIVE] {
  return -8;
}

route[ZERO] {
  return 0;
}
```

A sub-route can execute another sub-route. There is a limit to the
number of recursive levels, avoiding ending up in infinite loops -- see
**max_recursive_level** global parameter.

The sub-route blocks allow to make the configuration file modular,
simplifying the logic and helping to avoid duplication of actions.

If no `return` is at the end of the routing block, the return code is the value
of the last executed action, therefore it is highly recommended to return an
explicit value (e.g., `return(1)`) to avoid unexpected config execution.

# 4. branch_route

Request's branch routing block. It contains a set of actions to be taken
for each branch of a SIP request. It is executed only by TM module after
it was armed via `t_on_branch("branch_route_index")`.

Example of usage:

``` c
    request_route {
        lookup("location");
        t_on_branch("OUT");
        if(!t_relay()) {
            sl_send_reply("500", "relaying failed");
        }
    }
    branch_route[OUT] {
        if(uri=~"10\.10\.10\.10") {
            # discard branches that go to 10.10.10.10
            drop();
        }
    }
```

# 5. failure_route

Failed transaction routing block. It contains a set of actions to be
taken each transaction that received only negative replies (`>=300`) for
all branches. The `failure_route` is executed only by TM module after it
was armed via `t_on_failure("failure_route_index")`.

Note that in `failure_route` is processed the request that initiated the
transaction, not the reply .

Example of usage:

``` c
    request_route {
        lookup("location");
        t_on_failure("TOVOICEMAIL");
        if(!t_relay()) {
            sl_send_reply("500", "relaying failed");
        }
    }
    failure_route[TOVOICEMAIL] {
        if(is_method("INVITE")) {
             # call failed - relay to voice mail
             t_relay_to_udp("voicemail.server.com","5060");
        }
    }
```

# 6. reply_route

Main SIP response (reply) handling block - it contains a set of actions
to be executed for SIP replies. It is executed for all replies received
from the network.

It does not have a name and it is executed by the core, before any other
module handling the SIP reply. It is triggered only by SIP replies
received on the network.

There is no network route that can be enforced for a SIP reply - it is
sent based on Via header, according to SIP RFC3261 - therefore no
dedicated actions for forwarding the reply must be used in this block.

This routing block is optional, if missing, the SIP reply is sent to the
address in 2nd Via header.

One can decide to drop a SIP reply by using **drop** action.

Example:

``` c
reply_route {
  if(status=="128") {
    drop;
  }
}
```

🔥**IMPORTANT**: Note: for backward compatibility reasons, the main `reply`
routing block can be also identified by `onreply_route {...}` or
`onreply_route[0] {...}`.

# 7. onreply_route

SIP reply routing block executed by **tm** module. It contains a set of
actions to be taken for SIP replies in the context of an active
transaction.

The `onreply_route` must be armed for the SIP requests whose replies
should be processed within it, via `t_on_reply`("`onreply_route_index`").

Core 'reply_route' block is executed before a possible **tm**
'onreply_route' block.

``` c
  request_route {
      lookup("location");
      t_on_reply("LOGRPL");
      if(!t_relay()) {
          sl_send_reply("500", "relaying failed");
      }
  }

  reply_route {
      if(!t_check_trans()) {
          drop;
      }
  }

  onreply_route[LOGRPL] {
      if(status=~"1[0-9][0-9]") {
           log("provisional response\n");
      }
  }
```

# 8. onsend_route

The route is executed in when a SIP request is sent out. Only a limited
number of commands are allowed (`drop`, `if` + all the checks, msg flag
manipulations, `send()`, `log()`, `textops::search()`).

In this route the final destination of the message is available and can
be checked (with `snd_ip`, `snd_port`, `to_ip`, `to_port`, `snd_proto`, `snd_af`).

This route is executed only when forwarding requests - it is not
executed for replies, retransmissions, or locally generated messages
(e.g. via fifo uac).

Example:

``` c
  onsend_route {
    if(to_ip==1.2.3.4 && !isflagset(12)){
      log(1, "message blocked\n");
      drop;
    }
  }
```

- snd_ip, snd_port - behave like src_ip/src_port, but contain the
    ip/port Kamailio will use to send the message
- to_ip, to_port - like above, but contain the ip/port the message
    will be sent to (not to be confused with dst_ip/dst_port, which are
    the destination of the original received request: Kamailio's ip and
    port on which the message was received)
- snd_proto, snd_af - behave like proto/af but contain the
    protocol/address family that Kamailio will use to send the message
- msg:len - when used in an onsend_route, msg:len will contain the
    length of the message on the wire (after all the changes in the
    script are applied, Vias are added a.s.o) and not the lentgh of the
    original message.

# 9. event_route

Generic type of route executed when specific events happen.

Prototype: `event_route[groupid:eventid]`

- groupid - should be the name of the module that triggers the event
- eventid - some meaningful short text describing the event

## 9.1. Core Event Routes

Implementations:

- `event_route[core:worker-one-init]` - executed by core after the
    first udp sip worker process executed the child_init() for all
    modules, before starting to process sip traffic
  - note that due to forking, other sip workers can get faster to
        listening for sip traffic

``` c
event_route[core:worker-one-init] {
        xlog("L_INFO","Hello world\n");
}
```

- `event_route[core:msg-received]` - executed when a message is
    received from the network. It runs with a faked request and makes
    available the $rcv(key) variables to access what was received and
    related attribtues.
  - it has to be enabled with received_route_mode global parameter.
        For usage via Kemi, set kemi.received_route_callback global
        parameter.
  - if drop is executed, the received message is no longer processed

``` c
event_route[core:msg-received] {
  xlog("rcv on $rcv(af)/$rcv(proto): ($rcv(len)) [$rcv(buf)] from [$rcv(srcip):$rcv(srcport)] to [$rcv(rcvip):$rcv(rcvport)]\n");
  if($rcv(srcip) == "1.2.3.4") {
    drop;
  }
}
```

- `event_route[core:pre-routing]` - executed by core on receiving
    SIP traffic before running request_route or reply_route.
  - if drop is used, then the message is not processed further with
        request_route or reply_route in the same process. This can be
        useful together with sworker module which can delegate the
        processing to another worker.

``` c
async_workers_group="name=reg;workers=4"
...
event_route[core:pre-routing] {
    xinfo("pre-routing rules\n");
    if(is_method("REGISTER")) {
        # delegate processing of REGISTERs to a special group of workers
        if(sworker_task("reg")) {
            drop;
        }
    }
}
```

- `event_route[core:receive-parse-error]` - executed by core
    on receiving a broken SIP message that can not be parsed.
  - note that the SIP message is broken in this case, but it gets
        access to source and local socket addresses (ip, port, proto,
        af) as well as the whole message buffer and its size

``` c
event_route[core:receive-parse-error] {
        xlog("got a parsing error from $si:$sp, message $mb\n");
}

```

## 9.2. Module Event Routes

Here are only a few examples, to see if a module exports event_route
blocks and when they are executed, check the readme of the module.

- `event_route[htable:mod-init]` - executed by **htable** module
    after all modules have been initialised. Good for initialising
    values in hash tables.

``` c
modparam("htable", "htable", "a=>size=4;")

event_route[htable:mod-init] {
  $sht(a=>calls-to::10.10.10.10) = 0;
  $sht(a=>max-calls-to::10.10.10.10) = 100;
}

request_route {
  if(is_method("INVITE") && !has_totag())
  {
    switch($rd) {
      case "10.10.10.10":
        lock("calls-to::10.10.10.10");
        $sht(a=>calls-to::10.10.10.10) =
            $sht(a=>calls-to::10.10.10.10) + 1;
        unlock("calls-to::10.10.10.10");
        if($sht(a=>calls-to::10.10.10.10)>$sht(a=>max-calls-to::10.10.10.10))
        {
           sl_send_reply("500", "To many calls to .10");
           exit;
        }
      break;
      ...
    }
  }
}
```

- `event_route[tm:local-request]` - executed on locally generated
    requests.

``` c
event_route [tm:local-request] { # Handle locally generated requests
  xlog("L_INFO", "Routing locally generated $rm to <$ru>\n");
  t_set_fr(10000, 10000);
}
```

- `event_route[tm:branch-failure]` - executed on all failure
    responses.

``` c
request_route {
    ...
    t_on_branch_failure("myroute");
    t_relay();
}

event_route[tm:branch-failure:myroute] {
  xlog("L_INFO", "Handling $T_reply_code response to $rm to <$ru>\n");
  if (t_check_status("430")) { # Outbound flow failed
    unregister("location", "$tu", "$T_reply_ruid");
    if (t_next_contact_flow()) {
      t_relay();
    }
  }
}

```