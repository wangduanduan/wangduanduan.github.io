---
title: "1.14 核心函数"
draft: false
tags:
- all
categories:
- all
---

Functions exported by core that can be used in route blocks.

# 1. add_local_rport ⭐️

Add **rport** parameter to local generated Via header -- see RFC3581. In
effect for forwarded SIP requests.

Example of usage:

``` c
add_local_rport();
```

# 2. avpflags

# 3. break

'break' statement can be used to end a 'case' block in a 'switch'
statement or exit from a 'while' statement.

# 4. drop ⭐️

Stop the execution of the configuration script and alter the implicit
action which is done afterwards.

If the function is called in a 'branch_route' then the branch is
discarded (implicit action for 'branch_route' is to forward the
request).

If the function is called in the default 'onreply_route' then you can
drop any response. If the function is called in a named 'onreply_route'
(transaction stateful) then any provisional reply is discarded.
(Implicit action for 'onreply_route' is to send the reply upstream
according to Via header.)

Example of usage:

      onreply_route {
          if(status=="200") {
              drop(); # this works
          }
      }

      onreply_route[FOOBAR] {
          if(status=="200") {
              drop(); # this is ignored
          }
      }

# 5. exit ⭐️

Stop the execution of the configuration script -- it has the same
behaviour as return(0). It does not affect the implicit action to be
taken after script execution.

    route {
      if (route(2)) {
        xlog("L_NOTICE","method $rm is INVITE\n");
      } else {
        xlog("L_NOTICE","method is $rm\n");
      };
    }

    route[2] {
      if (is_method("INVITE")) {
        return(1);
      } else if (is_method("REGISTER")) {
        return(-1);
      } else if (is_method("MESSAGE")) {
        sl_send_reply("403","IM not allowed");
        exit;
      };
    }

# 6. error

# 7. exec

# 8. force_rport ⭐️

Force_rport() adds the rport parameter to the first Via header of the
received message. Thus, Kamailio will add the received port to the top
most Via header in the SIP message, even if the client does not indicate
support for rport. This enables subsequent SIP messages to return to the
proper port later on in a SIP transaction.

This is useful for NAT traversal, to enforce symmetric response
signaling.

The rport parameter is defined in RFC 3581.

Note: there is also a force_rport parameter which changes the global
behavior of the SIP proxy.

Example of usage:

      force_rport();

# 9. add_rport ⭐️

Alias for force_rport();

# 10. force_send_socket

Force to send the message from the specified socket (it \_must\_ be one
of the sockets specified with the "listen" directive). If the protocol
doesn't match (e.g. UDP message "forced" to a TCP socket) the closest
socket of the same protocol is used.

This function does not support pseudo-variables, use the set_send_socket
function from the corex module instead.

Example of usage:

        force_send_socket(10.10.10.10:5060);
        force_send_socket(udp:10.10.10.10:5060);

# 11. force_tcp_alias

**Alias name:** **add_tcp_alias**

force_tcp_alias(port)

adds a tcp port alias for the current connection (if tcp). Useful if you
want to send all the traffic to port_alias through the same connection
this request came from \[it could help for firewall or nat traversal\].
With no parameters adds the port from the message via as the alias. When
the "aliased" connection is closed (e.g. it's idle for too much time),
all the port aliases are removed.

# 12. forward

Forward the SIP request to destination stored in $du in stateless mode.

Example of usage:

      $du = "sip:10.0.0.10:5060;transport=tcp";
      forward();

# 13. isavpflagset

# 14. isflagset ⭐️

Test if a flag is set for current processed message (if the flag value
is 1). The value of the parameter can be in range of 0..31.

For more see:
- [Kamailio - Flag Operations](../../tutorials/kamailio-flag-operations.md)

Example of usage:

      if(isflagset(3)) {
          log("flag 3 is set\n");
      };

Kamailio also supports named flags. They have to be declared at the
beginning of the config file with:

     flags  flag1_name[:position],  flag2_name ...

Example:

         flags test, a:1, b:2 ;
         route{
                setflag(test);
                if (isflagset(a)){ # equiv. to isflagset(1)
                  ....
                }
                resetflag(b);  # equiv. to resetflag(2)

# 15. is_int ⭐️

Checks if a pseudo variable argument contains integer value.

    if(is_int("$avp(foobar)")) {
      log("foobar contains an integer\n");
    }

# 16. log

Write text message to standard error terminal or syslog. You can specify
the log level as first parameter.

For more see:
<http://www.kamailio.org/dokuwiki/doku.php/tutorials:debug-syslog-messages>

Example of usage:

      log("just some text message\n");

# 17. prefix

Add the string parameter in front of username in R-URI.

Example of usage:

      prefix("00");

# 18. resetavpflag

# 19. resetflag

# 20. return ⭐️

The return() function allows you to return any integer value from a
called route() block. You can test the value returned by a route using
[`$retcode`](pseudovariables.md#$rc) or `$?` variable.

`return(0)` is same as [`exit()`](#exit);

In bool expressions:

- Negative is FALSE
- Positive is TRUE

If no value is specified, it returns 1. If return is used in the top level route
is equivalent with exit `[val]`. If no `return` is at the end of the routing block,
the return code is the value of the last executed action, therefore it is highly
recommended to return an explicit value (e.g., `return(1)`) to avoid unexpected
config execution.

Example usage:

    route {
      if (route(2)) {
        xlog("L_NOTICE","method $rm is INVITE\n");
      } else {
        xlog("L_NOTICE","method $rm is REGISTER\n");
      };
    }

    route[2] {
      if (is_method("INVITE")) {
        return(1);
      } else if (is_method("REGISTER")) {
        return(-1);
      } else {
        return(0);
      };
    }

See also the FAQ for how the function return code is evaluated:

- [Frequently Asked Questions](../tutorials/../../tutorials/faq/main.md#how-is-the-function-return-code-evaluated)

# 21. revert_uri ⭐️

Set the R-URI to the value of the R-URI as it was when the request was
received by server (undo all changes of R-URI).

Example of usage:

      revert_uri();

# 22. rewritehostport ⭐️

**Alias name:** **sethostport, sethp**

Rewrite the domain part and port of the R-URI with the value of
function's parameter. Other parts of the R-URI like username and URI
parameters remain unchanged.

Example of usage:

      rewritehostport("1.2.3.4:5080");

# 23. rewritehostporttrans ⭐️

**Alias name:** **sethostporttrans, sethpt**

Rewrite the domain part and port of the R-URI with the value of
function's parameter. Also allows to specify the transport parameter.
Other parts of the R-URI like username and URI parameters remain
unchanged.

Example of usage:

      rewritehostporttrans("1.2.3.4:5080");

# 24. rewritehost ⭐️

**Alias name:** **sethost, seth**

Rewrite the domain part of the R-URI with the value of function's
parameter. Other parts of the R-URI like username, port and URI
parameters remain unchanged.

Example of usage:

      rewritehost("1.2.3.4");

# 25. rewriteport ⭐️

**Alias name:** **setport, setp**

Rewrites/sets the port part of the R-URI with the value of function's
parameter.

Example of usage:

      rewriteport("5070");

# 26. rewriteuri ⭐️

**Alias name:** **seturi**

Rewrite the request URI.

Example of usage:

      rewriteuri("sip:test@kamailio.org");

# 27. rewriteuserpass ⭐️

**Alias name:** **setuserpass, setup**

Rewrite the password part of the R-URI with the value of function's
parameter.

Example of usage:

      rewriteuserpass("my_secret_passwd");

# 28. rewriteuser ⭐️

**Alias name:** **setuser, setu**

Rewrite the user part of the R-URI with the value of function's
parameter.

Example of usage:

      rewriteuser("newuser");

# 29. route ⭐️

Execute route block given in parameter. Parameter may be name of the
block or a string valued expression.

Examples of usage:

      route(REGISTER_REQUEST);
      route(@received.proto + "_proto_" + $var(route_set));

# 30. selval ⭐️

Select a value based on conditional expression.

Prototype:

``` c
selval(evalexpr, valexp1, valexpr2)
```

This is a core statement that return the 2nd parameter if the 1st
parameter is evaluated to true, or 3rd parameter if the 1st parameter is
evaluated to false. It can be considered a core function that is
equivalent of ternary condition/operator

Example:

``` c
$var(x) = selval($Ts mod 2, "true/" + $ru, "false/" + $rd);
```

The first parameter is a conditional expression, like those used for IF,
the 2nd and 3rd parameters can be expressions like those used in the
right side of assignments.

# 31. set_advertised_address ⭐️

Same as `advertised_address` but it affects only the current message. It
has priority if `advertised_address` is also set.

Example of usage:

      set_advertised_address("kamailio.org");

# 32. set_advertised_port ⭐️

Same as `advertised_port` but it affects only the current message. It
has priority over `advertised_port`.

Example of usage:

      set_advertised_port(5080);

# 33. set_forward_no_connect

The message will be forwarded only if there is already an existing
connection to the destination. It applies only to connection oriented
protocols like TCP and TLS (TODO: SCTP), for UDP it will be ignored. The
behavior depends in which route block the function is called:

- normal request route: affects stateless forwards and tm. For tm it
    affects all the branches and the possible retransmissions (in fact
    there are no retransmission for TCP/TLS).

<!-- -->

- `onreply_route[0]` (stateless): equivalent to `set_reply_*()` (it's
    better to use `set_reply_*` though)

<!-- -->

- `onreply_route[!=0]` (tm): ignored

<!-- -->

- branch_route: affects the current branch only (all messages sent on
    this branch, like possible retransmissions and CANCELs).

<!-- -->

- onsend_route: like branch route

Example of usage:

      route {
        ...
        if (lookup()) {
          //requests to local users. They are usually behind NAT so it does not make sense to try
          //to establish a new TCP connection
          set_forward_no_connect();
          t_relay();
        }
        ...
      }

# 34. set_forward_close

Try to close the connection (the one on which the message is sent out)
after forwarding the current message. Can be used in same route blocks
as `set_forward_no_connect()`.

Note: Use with care as you might not receive the replies anymore as the
connection is closed.

# 35. set_reply_no_connect

Like `set_forward_no_connect()`, but for replies to the current message
(local generated replies and replies forwarded by tm). The behavior
depends in which route block the function is called:

- normal request route: affects all replies sent back on the
    transaction (either local or forwarded) and all local stateless
    replies (`sl_reply()`).

<!-- -->

- `onreply_route`: affects the current reply (so the send_flags set in
    the `onreply_route` will be used if the reply for which they were set
    is the winning final reply or it's a provisional reply that is
    forwarded)

<!-- -->

- branch_route: ignored.

<!-- -->

- onsend_route: ignored

Example of usage:

      route[4] {
        //requests from local users. There are usually behind NAT so it does not make sense to try
        //to establish a new TCP connection for the replies
        set_reply_no_connect();
        // do authentication and call routing
        ...
      }

# 36. set_reply_close

Like `set_reply_no_connect`, but closes the TCP connection after sending.
Can be used in same route blocks as `set_reply_no_connect`.

Example of usage:

      route {
        ...
        if (...caller-is-not-registered...) {
          // reject unregistered client
          // if request was received via TCP/TLS close the connection, as
          // this may trigger re-registration of the client.
          set_reply_close();
          sl_send_reply("403","REGISTER first");
          exit;
        }
        ...
      }

# 37. setavpflag

# 38. setflag ⭐️

Set a flag for current processed message. The value of the parameter can
be in range of 0..31. The flags are used to mark the message for special
processing (e.g., accounting) or to keep some state (e.g., message
authenticated).

For more see:
- [Kamailio - Flag Operations](../../tutorials/kamailio-flag-operations.md)

Example of usage:

      setflag(3);

# 39. strip ⭐️

Strip the first N-th characters from username of R-URI (N is the value
of the parameter).

Example of usage:

      strip(3);

# 40. strip_tail

Strip the last N-th characters from username of R-URI (N is the value of
the parameter).

Example of usage:

    strip_tail(3);

# 41. udp_mtu_try_proto(proto)

- proto - `TCP|TLS|SCTP|UDP` - like `udp_mtu_try_proto` global
    parameter but works on a per packet basis and not globally.

Example:

    if($rd=="10.10.10.10")
        udp_mtu_try_proto(SCTP);

# 42. userphone

Add "user=phone" parameter to R-URI.