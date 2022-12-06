---
title: "ISUP SIP ISDN对照码表"
date: "2020-02-20 22:34:47"
draft: false
---

# ISUP to SIP

# <br />
| ISUP Cause Value | SIP Response |
| --- | --- |
| Normal event |  |
| 1 – unallocated number | 404 Not Found |
| 2 – no route to network | 404 Not Found |
| 3 – no route to destination | 404 Not Found |
| 16 – normal call clearing | --- (*) |
| 17 – user busy | 486 Busy here |
| 18 – no user responding | 408 Request Timeout |
| 19 – no answer from the user | 480 Temporarily unavailable |
| 20 – subscriber absent | 480 Temporarily unavailable |
| 21 – call rejected | 403 Forbidden (+) |
| 22 – number changed (s/o diagnostic) | 410 Gone |
| 23 – redirection to new destination | 410 Gone |
| 26 – non-selected user clearing | 404 Not Found (=) |
| 27 – destination out of order | 502 Bad Gateway |
| 28 – address incomplete | 484 Address incomplete |
| 29 – facility rejected | 510 Not implemented |
| 31 – normal unspecified | 480 Temporarily unavailable Resource unavailable |
| 34 – no circuit available | 503 Service unavailable |
| 38 – network out of order | 503 Service unavailable |
| 41 – temporary failure | 503 Service unavailable |
| 42 – switching equipment congestion | 503 Service unavailable |
| 47 – resource unavailable | 503 Service unavailable Service or option not available |
| 55 – incoming calls barred within CUG | 403 Forbidden |
| 57 – bearer capability not authorized | 403 Forbidden |
| 58 – bearer capability not presently available | 503 Service unavailable |
| 65 – bearer capability not implemented | 488 Not Acceptable here |
| 70 – Only restricted digital information bearer capability is available (National use) | 488 Not Acceptable here |
| 79 – service or option not implemented | 501 Not implemented |
| Invalid message |   |
| 87 – user not member of CUG | 403 Forbidden |
| 88 – incompatible destination | 503 Service unavailable |
|   |   |
| 102 – Call Setup Time-out Failure | 504 Gateway timeout |
| 111 – Protocol Error  Unspecified | 500 Server internal error Interworking |
| 127 – Internal Error - interworking unspecified | 500 Server internal error |

 <br />(*) ISDN Cause 16 will usually result in a BYE or CANCEL<br />(+) If the cause location is user then the 6xx code could be given rather than the 4xx code. the cause value received in the H.225.0 message is unknown in ISUP, the unspecified cause value of the class is sent.<br />(=) ANSI procedure<br /> 

# SIP to ISDN
Response received Cause value in the REL.

| SIP Status Code | ISDN Map |
| --- | --- |
| 400 - Bad Request | 41 – Temporary failure |
| 401 - Unauthorized | 21 – Call rejected (*) |
| 402 - Payment required | 21 – Call rejected |
| 403 - Forbidden | 21 – Call rejected |
| 404 - Not Found | 1 – Unallocated number |
| 405 - Method not allowed | 63 – Service or option unavailable |
| 406 - Not acceptable | 79 – Service/option not implemented (+) |
| 407 - Proxy authentication required | 21 – Call rejected (*) |
| 408 - Request timeout | 102 – Recovery on timer expiry |
| 410 - Gone | 22 – Number changed (w/o diagnostic) |
| 413 - Request Entity too long | 127 – Interworking (+) |
| 414 - Request –URI too long | 127 – Interworking (+) |
| 415 - Unsupported media type | 79 – Service/option not implemented (+) |
| 416 - Unsupported URI Scheme | 127 – Interworking (+) |
| 402 - Bad extension | 127 – Interworking (+) |
| 421 - Extension Required | 127 – Interworking (+) |
| 423 - Interval Too Brief | 127 – Interworking (+) |
| 480 - Temporarily unavailable | 18 – No user responding |
| 481 - Call/Transaction Does not Exist | 41 – Temporary Failure |
| 482 - Loop Detected | 25 – Exchange – routing error |
| 483 - Too many hops | 25 – Exchange – routing error |
| 484 - Address incomplete | 28 – Invalid Number Format (+) |
| 485 - Ambiguous | 1 – Unallocated number |
| 486 - Busy here   | 17 – User Busy |
| 487 - Request Terminated | --- (no mapping) |
| 488 - Not Acceptable here | --- by warning header |
| 500 - Server internal error | 41 – Temporary Failure |
| 501 - Not implemented | 79 – Not implemented, unspecified |
| 502 - Bad gateway | 38 – Network out of order |
| 503 - Service unavailable | 41 – Temporary Failure |
| 504 - Service time-out | 102 – Recovery on timer expiry |
| 505 - Version Not supported | 127 – Interworking (+) |
| 513 - Message Too Large | 127 – Interworking (+) |
| 600 - Busy everywhere | 17 – User busy |
| 603 - Decline | 21 – Call rejected |
| 604 - Does not exist anywhere | 1 – Unallocated number |
| 606 - Not acceptable | --- by warning header |

 

# 参考

- [https://www.dialogic.com/webhelp/BorderNet2020/1.1.0/WebHelp/cause_code_map_ss7_sip.htm](https://www.dialogic.com/webhelp/BorderNet2020/1.1.0/WebHelp/cause_code_map_ss7_sip.htm)

