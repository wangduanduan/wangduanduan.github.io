---
title: "1.12 黑名单参数"
draft: false
tags:
- all
categories:
- all
---




# 1. dst_blocklist_expire

**Alias name:** **dst_blocklist_ttl**

How much time a blocklisted destination will be kept in the blocklist
(w/o any update).

    dst_blocklist_expire = time in s (default 60 s)

# 2. dst_blocklist_gc_interval

How often the garbage collection will run (eliminating old, expired
entries).

    dst_blocklist_gc_interval = time in s (default 60 s)

# 3. dst_blocklist_init

If off, the blocklist is not initialized at startup and cannot be
enabled at runtime, this saves some memory.

    dst_blocklist_init = on | off (default on)

# 4. dst_blocklist_mem

Maximum shared memory amount used for keeping the blocklisted
destinations.

    dst_blocklist_mem = size in Kb (default 250 Kb)

# 5. use_dst_blocklist

Enable the destination blocklist: Each failed send attempt will cause
the destination to be added to the blocklist. Before any send, this
blocklist will be checked and if a match is found, the send is no longer
attempted (an error is returned immediately).

Note: using the blocklist incurs a small performance penalty.

See also doc/dst_blocklist.txt.

    use_dst_blocklist = on | off (default off)