---
title: "有状态和无状态路由"
date: "2019-06-19 23:40:08"
draft: false
---

| 操作 | 无状态 | 有状态 |
| --- | --- | --- |
| SIP forward | forward() | t_relay() |
| SIP replying | sl_send_reply() | t_reply() |
| Create transaction |  | t_newtran() |
| Match transcation |  | t_check_trans() |



