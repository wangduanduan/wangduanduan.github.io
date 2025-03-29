---
title: "1.7 DNS 参数"
draft: false
tags:
- all
categories:
- all
---


Note: See also file doc/tutorials/dns.txt for details about Kamailio's
DNS client.

Kamailio has an internal DNS resolver with caching capabilities. If this
caching resolver is activated (default setting) then the system's stub
resolver won't be used. Thus, also local name resolution configuration
like /etc/hosts entries will not be used. If the DNS cache is
deactivated (use_dns_cache=no), then system's resolver will be used. The
DNS failover functionality in the tm module references directly records
in the DNS cache (which saves a lot of memory) and hence DNS based
failover only works if the internal DNS cache is enabled.

| DNS resolver comparison                  | internal resolver | system resolver |
|------------------------------------------|-------------------|-----------------|
| Caching of resolved records              | yes               | no\*            |
| NAPTR/SRV lookups with correct weighting | yes               | yes             |
| DNS based failover                       | yes               | no              |

\* Of course you can use the resolving name servers configured in
/etc/resolv.conf as caching nameservers.

If the internal resolver/cache is enabled you can add/remove records by
hand (using kamcmd or xmlrpc) using the DNS RPCs, e.g. dns.add_a,
dns.add_srv, dns.delete_a a.s.o. For more info on DNS RPCs see
<http://www.kamailio.org/docs/docbooks/devel/rpc_list/rpc_list.html#dns.add_a>

Note: During startup of Kamailio, before the internal resolver is
loaded, the system resolver will be used (it will be used for queries
done from module register functions or modparams fixups, but not for
queries done from mod_init() or normal fixups).

Note: The dns cache uses the DNS servers configured on your server
(/etc/resolv.conf), therefore even if you use the internal resolver you
should have a working DNS resolving configuration on your server.

Kamailio also allows you to finetune the DNS resolver settings.

The maximum time a dns request can take (before failing) is (if
dns_try_ipv6 is yes, multiply it again by 2; if SRV and NAPTR lookups
are enabled, it can take even longer!):

    (dns_retr_time*(dns_retr_no+1)*dns_servers_no)*(search_list_domains)

Note: During DNS lookups, the process which performs the DNS lookup
blocks. To minimize the blocked time the following parameters can be
used (max 2s):

    dns_try_ipv6=no
    dns_retr_time=1
    dns_retr_no=1
    dns_use_search_list=no

# 1. dns

This parameter controls if the SIP server will try doing a DNS lookup on
the address in the Via header of a received sip request to decide if
adding a received=\<src_ip> parameter to the Via is necessary. Note that
Vias containing DNS names (instead of IPs) should have received= added,
so turning dns to yes is not recommended.

Default is no.

# 2. rev_dns

This parameter controls if the SIP server will try doing a reverse DNS
lookup on the source IP of a sip request to decide if adding a
received=\<src_ip> parameter to the Via is necessary (if the Via
contains a DNS name instead of an IP address, the result of the reverse
dns on the source IP will be compared with the DNS name in the Via). See
also dns (the effect is cumulative, both can be turned on and in that
case if the DNS lookup test fails the reverse DNS test will be tried).
Note that Vias containing DNS names (instead of IPs) should have
received= added, so turning rev_dns to yes is not recommended.

Default is no.

# 3. dns_cache_del_nonexp

**Alias name:** **dns_cache_delete_nonexpired**

    dns_cache_del_nonexp = yes | no (default: no)
      allow deletion of non-expired records from the cache when there is no more space
      left for new ones. The last-recently used entries are deleted first.

# 4. dns_cache_rec_pref

    dns_cache_rec_pref = number (default 0)
      dns cache record preference, determines how new DNS records are stored internally in relation to existing entries.
      Possible values:
        0 - do not check duplicates
        1 - prefer old records
        2 - prefer new records
        3 - prefer records with longer lifetime

# 5. dns_cache_flags

    dns_cache_flags = number (default 0) -
      dns cache specific resolver flags, used for overriding the default behaviour (low level).
      Possible values:
        1 - ipv4 only: only DNS A requests are performed, even if Kamailio also listens on ipv6 addresses.
        2 - ipv6 only: only DNS AAAA requests are performed. Ignored if dns_try_ipv6 is off or Kamailio
            doesn't listen on any ipv6 address.
        4 - prefer ipv6: try first to resolve a host name to an ipv6 address (DNS AAAA request) and only
            if this fails try an ipv4 address (DNS A request). By default the ipv4 addresses are preferred.

# 6. dns_cache_gc_interval

Interval in seconds after which the dns cache is garbage collected
(default: 120 s)

    dns_cache_gc_interval = number

# 7. dns_cache_init

If off, the dns cache is not initialized at startup and cannot be
enabled at runtime, this saves some memory.

    dns_cache_init = on | off (default on)

# 8. dns_cache_max_ttl

    dns_cache_max_ttl = time in seconds (default MAXINT)

# 9. dns_cache_mem

Maximum memory used for the dns cache in KB (default 500 K)

    dns_cache_mem = number

# 10. dns_cache_min_ttl

    dns_cache_min_ttl = time in seconds (default 0)

# 11. dns_cache_negative_ttl

Tells how long to keep negative DNS responses in cache. If set to 0,
disables caching of negative responses. Default is 60 (seconds).

# 12. dns_naptr_ignore_rfc

If the DNS lookup should ignore the remote side's protocol preferences,
as indicated by the Order field in the NAPTR records and mandated by RFC
2915.

      dns_naptr_ignore_rfc = yes | no (default yes)

# 13. dns_retr_no

Number of dns retransmissions before giving up. Default value is system
specific, depends also on the '/etc/resolv.conf' content (usually 4).

Example of usage:

      dns_retr_no=3

# 14. dns_retr_time

Time in seconds before retrying a dns request. Default value is system
specific, depends also on the '/etc/resolv.conf' content (usually 5s).

Example of usage:

      dns_retr_time=3

# 15. dns_search_full_match

When name was resolved using dns search list, check the domain added in
the answer matches with one from the search list (small performance hit,
but more safe)

    dns_search_full_match = yes | no (default yes)

# 16. dns_servers_no

How many dns servers from the ones defined in '/etc/resolv.conf' will be
used. Default value is to use all of them.

Example of usage:

      dns_servers_no=2

# 17. dns_srv_lb

**Alias name:** **dns_srv_loadbalancing**

Enable dns srv weight based load balancing (see doc/tutorials/dns.txt)

    dns_srv_lb = yes | no (default no)

# 18. dns_try_ipv6

Can be 'yes' or 'no'. If it is set to 'yes' and a DNS lookup fails, it
will retry it for ipv6 (AAAA record). Default value is 'no'.

Note: If dns_try_ipv6 is off, no hostname resolving that would result in
an ipv6 address would succeed - it doesn't matter if an actual DNS
lookup is to be performed or the host is already an ip address. Thus, if
the proxy should forward requests to IPv6 targets, this option must be
turned on!

Example of usage:

      dns_try_ipv6=yes

# 19. dns_try_naptr

Enable NAPTR support according to RFC 3263 (see doc/tutorials/dns.txt
for more info)

    dns_try_naptr = yes | no (default no)

# 20. dns_sctp_pref, dns_tcp_pref, dns_tls_pref, dns_udp_pref

**Alias name:** **dns_sctp_preference, dns_tcp_preference,
dns_tls_preference, dns_udp_preference**

Set preference for each protocol when doing naptr lookups. By default
dns_udp_pref=30, dns_tcp_pref=20, dns_tls_pref=10 and dns_sctp_pref=20.
To use the remote site preferences set all dns\_\*\_pref to the same
positive value (e.g. dns_udp_pref=1, dns_tcp_pref=1, dns_tls_pref=1,
dns_sctp_pref=1). To completely ignore NAPTR records for a specific
protocol, set the corresponding protocol preference to -1 (or any other
negative number). (see doc/tutorials/dns.txt for more info)

    dns_{udp,tcp,tls,sctp}_pref = number

# 21. dns_use_search_list

Can be 'yes' or 'no'. If set to 'no', the search list in
'/etc/resolv.conf' will be ignored (=> fewer lookups => gives up
faster). Default value is 'yes'.

HINT: even if you don't have a search list defined, setting this option
to 'no' will still be "faster", because an empty search list is in fact
search "" (so even if the search list is empty/missing there will still
be 2 dns queries, eg. foo+'.' and foo+""+'.')

Example of usage:

      dns_use_search_list=no

# 22. use_dns_cache

Tells if DNS responses are cached - this means that the internal DNS
resolver (instead of the system's stub resolver) will be used. If set to
"off", disables caching of DNS responses and, as side effect, DNS
failover. Default is "on". Settings can be changed also during runtime
(switch from internal to system resolver and back).

# 23. use_dns_failover

use_dns_failover = on \| off (default off)