---
title: "1.19 日志引擎"
draft: false
tags:
- all
categories:
- all
---

# Log Engine CLI Parameter

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
