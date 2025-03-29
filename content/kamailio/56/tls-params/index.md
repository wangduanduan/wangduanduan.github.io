---
title: "1.9 TLS参数"
draft: false
tags:
- all
categories:
- all
---



Most of TLS layer attributes can be configured via TLS module
parameters.

# 1. tls_port_no

The port the SIP server listens to for TLS connections.

Default value is 5061.

Example of usage:

      tls_port_no=6061

# 2. tls_max_connections

Maximum number of TLS connections (if the number is exceeded no new TLS
connections will be accepted). It cannot exceed tcp_max_connections.

Default value is 2048.

Example of usage:

      tls_max_connections=4096