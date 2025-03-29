---
title: "1. 核心概念"
# date: "2025-03-28 23:07:02"
draft: false
# type: posts
tags:
- all
categories:
- all
---




## 1.16. Custom Global Parameters

These are parameters that can be defined by the writer of kamailio.cfg
in order to be used inside routing blocks. One of the important
properties for custom global parameters is that their value can be
changed at runtime via RPC commands, without restarting Kamailio.

The definition of a custom global parameter must follow the pattern:

    group.variable = value desc "description"

The value can be a quoted string or integer number.

Example:

``` c
pstn.gw_ip = "1.2.3.4" desc "PSTN GW Address"
```

The custom global parameter can be accessed inside a routing block via:

    $sel(cfg_get.group.variable)

Example:

``` c
$ru = "sip:" + $rU + "@" + $sel(cfg_get.pstn.gw_ip);
```

**Note:** Some words cannot be used as (part of) names for custom
variables or groups, and if they are used a syntax error is logged by
kamailio. These keywords are: "yes", "true", "on", "enable", "no",
"false", "off", "disable", "udp", "UDP", "tcp", "TCP", "tls", "TLS",
"sctp", "SCTP", "ws", "WS", "wss", "WSS", "inet", "INET", "inet6",
"INET6", "sslv23", "SSLv23", "SSLV23", "sslv2", "SSLv2", "SSLV2",
"sslv3", "SSLv3", "SSLV3", "tlsv1", "TLSv1", "TLSV1"

## 1.17. Routing Blocks

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

### 1.17.1. request_route

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

### 1.17.2. route

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

### 1.17.3. branch_route

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

### 1.17.4. failure_route

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

### 1.17.5. reply_route

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

### 1.17.6. onreply_route

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

### 1.17.7. onsend_route

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

### 1.17.8. event_route

Generic type of route executed when specific events happen.

Prototype: `event_route[groupid:eventid]`

- groupid - should be the name of the module that triggers the event
- eventid - some meaningful short text describing the event

#### 1.17.8.1. Core Event Routes

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

#### 1.17.8.2. Module Event Routes

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

## 1.18. Script Statements

### 1.18.1. if

IF-ELSE statement

Prototype:

        if(expr) {
           actions;
        } else {
           actions;
        }

The `expr` should be a valid logical expression.

The logical operators that can be used in `expr`:

- `==`:      equal
- `!=`:      not equal
- `=~`:      case-insensitive regular expression matching: Note: Posix regular expressions will be used, e.g. use `[[:digit:]]{3}` instead of `\d\d\d`
- `!~`:      regular expression not-matching (NOT PORTED from Kamailio 1.x, use `!(x =~ y)`)
- `>`:       greater
- `>=`:      greater or equal
- `<`:       less
- `<=`:      less or equal
- `&&`:      logical AND
- `||`:      logical OR
- `!`:       logical NOT

Example of usage:

      if(is_method("INVITE"))
      {
          log("this sip message is an invite\n");
      } else {
          log("this sip message is not an invite\n");
      }

See also the FAQ for how the function return code is evaluated:

- [How is the function code evaluated](../../tutorials/faq/main.md#how-is-the-function-return-code-evaluated)

### 1.18.2. switch

SWITCH statement - it can be used to test the value of a
pseudo-variable.

IMPORTANT NOTE: `break` can be used only to mark the end of a `case`
branch (as it is in shell scripts). If you are trying to use `break`
outside a `case` block the script will return error -- you must use
`return` there.

Example of usage:

        route {
            route(1);
            switch($retcode)
            {
                case -1:
                    log("process INVITE requests here\n");
                break;
                case 1:
                    log("process REGISTER requests here\n");
                break;
                case 2:
                case 3:
                    log("process SUBSCRIBE and NOTIFY requests here\n");
                break;
                default:
                    log("process other requests here\n");
           }

            # switch of R-URI username
            switch($rU)
            {
                case "101":
                    log("destination number is 101\n");
                break;
                case "102":
                    log("destination number is 102\n");
                break;
                case "103":
                case "104":
                    log("destination number is 103 or 104\n");
                break;
                default:
                    log("unknown destination number\n");
           }
        }

        route[1]{
            if(is_method("INVITE"))
            {
                return(-1);
            };
            if(is_method("REGISTER"))
                return(1);
            }
            if(is_method("SUBSCRIBE"))
                return(2);
            }
            if(is_method("NOTIFY"))
                return(3);
            }
            return(-2);
        }

NOTE: take care while using `return` - `return(0)` stops the execution
of the script.

### 1.18.3. while

while statement

Example of usage:

      $var(i) = 0;
      while($var(i) < 10)
      {
          xlog("counter: $var(i)\n");
          $var(i) = $var(i) + 1;
      }

## 1.19. Script Operations

Assignments together with string and arithmetic operations can be done
directly in configuration file.

### 1.19.1. Assignment

Assignments can be done like in C, via `=` (equal). The following
pseudo-variables can be used in left side of an assignment:

- Unordered List Item AVPs - to set the value of an AVP
- script variables `($var(...))` - to set the value of a script variable
- shared variables (`$shv(...)`)
- `$ru` - to set R-URI
- `$rd` - to set domain part of R-URI
- `$rU` - to set user part of R-URI
- `$rp` - to set the port of R-URI
- `$du` - to set dst URI
- `$fs` - to set send socket
- `$br` - to set branch
- `$mf` - to set message flags value
- `$sf` - to set script flags value
- `$bf` - to set branch flags value

<!-- -->

    $var(a) = 123;

For avp's there a way to remove all values and assign a single value in
one statement (in other words, delete existing AVPs with same name, add
a new one with the right side value). This replaces the `:=` assignment
operator from kamailio `< 3.0`.

    $(avp(i:3)[*]) = 123;
    $(avp(i:3)[*]) = $null;

### 1.19.2. String Operations

For strings, `+` is available to concatenate.

    $var(a) = "test";
    $var(b) = "sip:" + $var(a) + "@" + $fd;

### 1.19.3. Arithmetic Operations

For numbers, one can use:

- `+` : plus
- `-` : minus
- `/` : divide
- `*` : multiply
- `%` : modulo (Kamailio uses `mod` instead of `%`)
- `|` : bitwise OR
- `&` : bitwise AND
- `^` : bitwise XOR
- `~` : bitwise NOT
- `<<` : bitwise left shift
- `>>` : bitwise right shift

Example:

    $var(a) = 4 + ( 7 & ( ~2 ) );

NOTE: to ensure the priority of operands in expression evaluations do
use <u>parenthesis</u>.

Arithmetic expressions can be used in condition expressions.

    if( $var(a) & 4 )
        log("var a has third bit set\n");

## 1.20. Operators

1. type casts operators: `(int)`, `(str)`.
2. string comparison: `eq`, `ne`
3. integer comparison: `ieq`, `ine`

Note: The names are not yet final (use them at your own risk). Future
version might use `==`/`!=` only for ints (`ieq/ine`) and `eq/ne` for strings
(under debate). They are almost equivalent to `==` or `!=`, but they force
the conversion of their operands (`eq` to string and `ieq` to int), allowing
among other things better type checking on startup and more
optimizations.

Non equiv. examples:

`0 == ""` (true) is not equivalent to `0 eq ""` (false: it evaluates to `"0" eq ""`).

`"a" ieq "b"` (true: `(int)"a" is 0` and `(int)"b" is 0`) is not equivalent to `"a" == "b"` (false).

Note: internally `==` and `!=` are converted on startup to `eq/ne/ieq/ine`
whenever possible (both operand types can be safely determined at start
time and they are the same).

1. Kamailio tries to guess what the user wanted when operators that
    support multiple types are used on different typed operands. In
    general convert the right operand to the type of the left operand
    and then perform the operation. Exception: the left operand is
    undef. This applies to the following operators: `+`, `==` and `!=`.

<!-- -->

       Special case: undef as left operand:
       For +: undef + expr -> undef is converted to string => "" + expr.
       For == and !=:   undef == expr -> undef is converted to type_of expr.
       If expr is undef, then undef == undef is true (internally is converted
       to string).

1. expression evaluation changes: Kamailio will auto-convert to integer
    or string in function of the operators:

<!-- -->

         int(undef)==0,  int("")==0, int("123")==123, int("abc")==0
         str(undef)=="", str(123)=="123".

1. script operators for dealing with empty/undefined variables

<!-- -->

        defined expr - returns true if expr is defined, and false if not.
                       Note: only a standalone avp or pvar can be
                       undefined, everything else is defined.
        strlen(expr) - returns the lenght of expr evaluated as string.
        strempty(expr) - returns true if expr evaluates to the empty
                         string (equivalent to expr=="").
        Example: if (defined $v && !strempty($v)) $len=strlen($v);

## 1.21. Command Line Parameters

Kamailio can be started with a set of command line parameters, providing
more flexibility to control what is doing at runtime. Some of them can
be quite useful when running on containerised environments.

To see the the available command line parameters, run **kamailio -h**:

    # kamailio -h

    version: kamailio 5.4.0-dev4 (x86_64/darwin) 8c1864
    Usage: kamailio [options]
    Options:
        -a mode      Auto aliases mode: enable with yes or on,
                      disable with no or off
        --alias=val  Add an alias, the value has to be '[proto:]hostname[:port]'
                      (like for 'alias' global parameter)
        -A define    Add config pre-processor define (e.g., -A WITH_AUTH,
                      -A 'FLT_ACC=1', -A 'DEFVAL="str-val"')
        -b nr        Maximum receive buffer size which will not be exceeded by
                      auto-probing procedure even if  OS allows
        -c           Check configuration file for syntax errors
        -d           Debugging mode (multiple -d increase the level)
        -D           Control how daemonize is done:
                      -D..do not fork (almost) anyway;
                      -DD..do not daemonize creator;
                      -DDD..daemonize (default)
        -e           Log messages printed in terminal colors (requires -E)
        -E           Log to stderr
        -f file      Configuration file (default: /usr/local/etc/kamailio/kamailio.cfg)
        -g gid       Change gid (group id)
        -G file      Create a pgid file
        -h           This help message
        --help       Long option for `-h`
        -I           Print more internal compile flags and options
        -K           Turn on "via:" host checking when forwarding replies
        -l address   Listen on the specified address/interface (multiple -l
                      mean listening on more addresses). The address format is
                      [proto:]addr_lst[:port][/advaddr],
                      where proto=udp|tcp|tls|sctp,
                      addr_lst= addr|(addr, addr_lst),
                      addr=host|ip_address|interface_name and
                      advaddr=addr[:port] (advertised address).
                      E.g: -l localhost, -l udp:127.0.0.1:5080, -l eth0:5062,
                      -l udp:127.0.0.1:5080/1.2.3.4:5060,
                      -l "sctp:(eth0)", -l "(eth0, eth1, 127.0.0.1):5065".
                      The default behaviour is to listen on all the interfaces.
        --loadmodule=name load the module specified by name
        --log-engine=log engine name and data
        -L path      Modules search path (default: /usr/local/lib64/kamailio/modules)
        -m nr        Size of shared memory allocated in Megabytes
        --modparam=modname:paramname:type:value set the module parameter
                      type has to be 's' for string value and 'i' for int value,
                      example: --modparam=corex:alias_subdomains:s:kamailio.org
        -M nr        Size of private memory allocated, in Megabytes
        -n processes Number of child processes to fork per interface
                      (default: 8)
        -N           Number of tcp child processes (default: equal to `-n')
        -O nr        Script optimization level (debugging option)
        -P file      Create a pid file
        -Q           Number of sctp child processes (default: equal to `-n')
        -r           Use dns to check if is necessary to add a "received="
                      field to a via
        -R           Same as `-r` but use reverse dns;
                      (to use both use `-rR`)
        --server-id=num set the value for server_id
        --subst=exp set a subst preprocessor directive
        --substdef=exp set a substdef preprocessor directive
        --substdefs=exp set a substdefs preprocessor directive
        -S           disable sctp
        -t dir       Chroot to "dir"
        -T           Disable tcp
        -u uid       Change uid (user id)
        -v           Version number
        --version    Long option for `-v`
        -V           Alternative for `-v`
        -x name      Specify internal manager for shared memory (shm)
                      - can be: fm, qm or tlsf
        -X name      Specify internal manager for private memory (pkg)
                      - if omitted, the one for shm is used
        -Y dir       Runtime dir path
        -w dir       Change the working directory to "dir" (default: "/")
        -W type      poll method (depending on support in OS, it can be: poll,
                      epoll_lt, epoll_et, sigio_rt, select, kqueue, /dev/poll)

### 1.21.1. Log Engine CLI Parameter

The **--log-engine** parameter allows to specify what logging engine to
be used, which is practically about the format of the log messages. If
not set at all, then Kamailio does the classic style of line-based plain
text log messages.

The value of this parameter can be **--log-engine=name** or
**--log-engine=name:data**.

The name of the log engine can be:

- **json** - write logs in structured JSON format
  - the **data** for **json** log engine can be a set of character
        flags:
    - **a** - add log prefix as a special field
    - **A** - do not add log prefix
    - **c** - add Call-ID (when available) as a dedicated JSON
            attribute
    - **j** - the log prefix and message fields are printed in
            JSON structure format, detecting if they are enclosed in
            between **{ }** or adding them as a **text** field
    - **M** - strip EOL ('\\n') from the value of the log message
            field
    - **N** - do not add EOL at the end of JSON document
    - **p** - the log prefix is printed as it is in the root json
            document, it has to start with comma (**,**) and be a valid
            set of json fields
    - **U** - CEE (Common Event Expression) schema format -
            <https://cee.mitre.org/language/1.0-beta1/core-profile.html>

Example of JSON logs when running Kamailio with
"**--log-engine=json:M**" :

    { "idx": 1, "pid": 18239, "level": "DEBUG", "module": "maxfwd", "file": "mf_funcs.c", "line": 74, "function": "is_maxfwd_present", "logprefix": "{1 1 OPTIONS 715678756@192.168.188.20} ", "message": "value = 70 " }

    { "idx": 1, "pid": 18239, "level": "DEBUG", "module": "core", "file": "core/socket_info.c", "line": 644, "function": "grep_sock_info", "logprefix": "{1 1 OPTIONS 715678756@192.168.188.20} ", "message": "checking if host==us: 9==9 && [127.0.0.1] == [127.0.0.1]" }

Example config for printing log message with **j** flag:

    xinfo("{ \"src_ip\": \"$si\", \"method\": \"$rm\", \"text\": \"request received\" }");

Example config for printing log messages with **p** flag:

    log_prefix=", \"src_ip\": \"$si\", \"tv\": $TV(Sn), \"mt\": $mt, \"ua\": \"$(ua{s.escape.common})\", \"cseq\": \"$hdr(CSeq)\""
