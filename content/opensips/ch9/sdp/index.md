---
title: "sdp协议简介"
date: "2019-06-20 15:29:36"
draft: false
---

# sdp栗子

```bash
v=0
o=- 7158718066157017333 2 IN IP4 127.0.0.1
s=-
t=0 0
a=group:BUNDLE 0
a=msid-semantic: WMS byn72RFJBCUzdSPhnaBU4vSz7LFwfwNaF2Sy
m=audio 64030 UDP/TLS/RTP/SAVPF 111 103 104 9 0 8 106 105 13 110 112 113 126
c=IN IP4 192.168.2.180
```


# Session描述
**
```bash
v=  (protocol version number, currently only 0)
o=  (originator and session identifier : username, id, version number, network address)
s=  (session name : mandatory with at least one UTF-8-encoded character)
i=* (session title or short information)
u=* (URI of description)
e=* (zero or more email address with optional name of contacts)
p=* (zero or more phone number with optional name of contacts)
c=* (connection information—not required if included in all media)
b=* (zero or more bandwidth information lines)
One or more Time descriptions ("t=" and "r=" lines; see below)
z=* (time zone adjustments)
k=* (encryption key)
a=* (zero or more session attribute lines)
Zero or more Media descriptions (each one starting by an "m=" line; see below)
```


# 时间描述(必须)

```bash
t=  (time the session is active)
r=* (zero or more repeat times)
```


# 媒体描述(可选)

```bash
m=  (media name and transport address)
i=* (media title or information field)
c=* (connection information — optional if included at session level)
b=* (zero or more bandwidth information lines)
k=* (encryption key)
a=* (zero or more media attribute lines — overriding the Session attribute lines)
```


