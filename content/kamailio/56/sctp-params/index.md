---
title: "1.10 SCTP参数"
draft: false
tags:
- all
categories:
- all
---



# 1. disable_sctp

Global parameter to disable SCTP support in the SIP server. see
enable_sctp

Default value is 'auto'.

Example of usage:

      disable_sctp=yes

# 2. enable_sctp

    enable_sctp = 0/1/2  - SCTP disabled (0)/ SCTP enabled (1)/auto (2),
                           default auto (2)

# 3. sctp_children

sctp children no (similar to udp children)

    sctp_children = number

# 4. sctp_socket_rcvbuf

Size for the sctp socket receive buffer

**Alias name:** **sctp_socket_receive_buffer**

    sctp_socket_rcvbuf = number

# 5. sctp_socket_sndbuf

Size for the sctp socket send buffer

**Alias name:** **sctp_socket_send_buffer**

    sctp_socket_sndbuf = number

# 6. sctp_autoclose

Number of seconds before autoclosing an idle association (default: 180
s). Can be changed at runtime, but it will affect only new associations.
E.g.:

    $ kamcmd cfg.set_now_int sctp autoclose 120

    sctp_autoclose = seconds

# 7. sctp_send_ttl

Number of milliseconds before an unsent message/chunk is dropped
(default: 32000 ms or 32 s). Can be changed at runtime, e.g.:

    $ kamcmd cfg.set_now_int sctp send_ttl 180000

    sctp_send_ttl = milliseconds - n

# 8. sctp_send_retries

How many times to attempt re-sending a message on a re-opened
association, if the sctp stack did give up sending it (it's not related
to sctp protocol level retransmission). Useful to improve reliability
with peers that reboot/restart or fail over to another machine.

WARNING: use with care and low values (e.g. 1-3) to avoid "multiplying"
traffic to unresponding hosts (default: 0). Can be changed at runtime.

    sctp_send_retries = 1

# 9. sctp_assoc_tracking

Controls whether or not sctp associations are tracked inside Kamailio.
Turning it off would result in less memory being used and slightly
better performance, but it will also disable some other features that
depend on it (e.g. sctp_assoc_reuse). Default: yes.

Can be changed at runtime ("kamcmd sctp assoc_tracking 0"), but changes
will be allowed only if all the other features that depend on it are
turned off (for example it can be turned off only if first
sctp_assoc_reuse was turned off).

Note: turning sctp_assoc_tracking on/off will delete all the tracking
information for all the currently tracked associations and might
introduce a small temporary delay in the sctp processing if lots of
associations were tracked.

Config options depending on sctp_assoc_tracking being on:
sctp_assoc_reuse.

    sctp_assoc_tracking = yes/no

# 10. sctp_assoc_reuse

Controls sctp association reuse. For now only association reuse for
replies is affected by it. Default: yes. Depends on sctp_assoc_tracking
being on.

Note that even if turned off, if the port in via corresponds to the
source port of the association the request was sent on or if rport is
turned on (force_rport() or via containing a rport option), the
association will be automatically reused by the sctp stack. Can be
changed at runtime (sctp assoc_reuse), but it can be turned on only if
sctp_assoc_tracking is on.

    sctp_assoc_reuse = yes/no

# 11. sctp_max_assocs

Maximum number of allowed open sctp associations. -1 means maximum
allowed by the OS. Default: -1. Can be changed at runtime (e.g.: "kamcmd
cfg.set_now_int sctp max_assocs 10"). When the maximum associations
number is exceeded and a new associations is opened by a remote host,
the association will be immediately closed. However it is possible that
some SIP packets get through (especially if they are sent early, as part
of the 4-way handshake).

When Kamailio tries to open a new association and the max_assocs is
exceeded the exact behaviour depends on whether or not
sctp_assoc_tracking is on. If on, the send triggering the active open
will gracefully fail, before actually opening the new association and no
packet will be sent. However if sctp_assoc_tracking is off, the
association will first be opened and then immediately closed. In general
this means that the initial sip packet will be sent (as part of the
4-way handshake).

    sctp_max_assocs = number

# 12. sctp_srto_initial

Initial value of the retr. timeout, used in RTO calculations (default:
OS specific).

Can be changed at runtime (sctp srto_initial) but it will affect only
new associations.

    sctp_srto_initial = milliseconds

# 13. sctp_srto_max

Maximum value of the retransmission timeout (RTO) (default: OS
specific).

WARNING: values lower than the sctp sack_delay will cause lots of
retransmissions and connection instability (see sctp_srto_min for more
details).

Can be changed at runtime (sctp srto_max) but it will affect only new
associations.

    sctp_srto_max = milliseconds

# 14. sctp_srto_min

Minimum value of the retransmission timeout (RTO) (default: OS
specific).

WARNING: values lower than the sctp sack_delay of any peer might cause
retransmissions and possible interoperability problems. According to the
standard the sack_delay should be between 200 and 500 ms, so avoid
trying values lower than 500 ms unless you control all the possible sctp
peers and you do make sure their sack_delay is higher or their sack_freq
is 1.

Can be changed at runtime (sctp srto_min) but it will affect only new
associations.

    sctp_srto_min = milliseconds

# 15. sctp_asocmaxrxt

Maximum retransmissions attempts per association (default: OS specific).
It should be set to sctp_pathmaxrxt \* no. of expected paths.

Can be changed at runtime (sctp asocmaxrxt) but it will affect only new
associations.

    sctp_asocmaxrxt   = number

# 16. sctp_init_max_attempts

Maximum INIT retransmission attempts (default: OS specific).

Can be changed at runtime (sctp init_max_attempts).

    sctp_init_max_attempts = number

# 17. sctp_init_max_timeo

Maximum INIT retransmission timeout (RTO max for INIT). Default: OS
specific.

Can be changed at runtime (sctp init_max_timeo).

    sctp_init_max_timeo = milliseconds

# 18. sctp_hbinterval

sctp heartbeat interval. Setting it to -1 will disable the heartbeats.
Default: OS specific.

Can be changed at runtime (sctp hbinterval) but it will affect only new
associations.

    sctp_hbinterval = milliseconds

# 19. sctp_pathmaxrxt

Maximum retransmission attempts per path (see also sctp_asocmaxrxt).
Default: OS specific.

Can be changed at runtime (sctp pathmaxrxt) but it will affect only new
associations.

    sctp_pathmaxrxt = number

# 20. sctp_sack_delay

Delay until an ACK is generated after receiving a packet. Default: OS
specific.

WARNING: a value higher than srto_min can cause a lot of retransmissions
(and strange problems). A value higher than srto_max will result in very
high connections instability. According to the standard the sack_delay
value should be between 200 and 500 ms.

Can be changed at runtime (sctp sack_delay) but it will affect only new
associations.

    sctp_sack_delay = milliseconds

# 21. sctp_sack_freq

Number of packets received before an ACK is sent (without waiting for
the sack_delay to expire). Default: OS specific.

Note: on linux with lksctp up to and including 1.0.9 is not possible to
set this value (having it in the config will produce a warning on
startup).

Can be changed at runtime (sctp sack_freq) but it will affect only new
associations.

    sctp_sack_freq = number

# 22. sctp_max_burst

Maximum burst of packets that can be emitted by an association. Default:
OS specific.

Can be changed at runtime (sctp max_burst) but it will affect only new
associations.

    sctp_max_burst = number