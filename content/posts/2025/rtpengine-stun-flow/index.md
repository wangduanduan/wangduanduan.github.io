---
title: "RTPEngine STUN包处理流程"
date: "2025-07-03 22:26:35"
draft: true
type: posts
tags:
- all
categories:
- all
---

# STUN 请求处理

```mermaid
flowchart TD

__wildcard_endpoint_map-->__assign_stream_fds
monologue_offer_answer-->__assign_stream_fds
monologue_publish-->__assign_stream_fds
monologue_subscribe_request1-->__assign_stream_fds
call_make_transform_media-->__assign_stream_fds

__wildcard_endpoint_map -->__get_endpoint_map
monologue_offer_answer -->__get_endpoint_map
monologue_publish -->__get_endpoint_map
monologue_subscribe_request1 -->__get_endpoint_map
call_make_transform_media -->__get_endpoint_map

__assign_stream_fds --> stream_fd_new
__get_endpoint_map --> stream_fd_new

stream_fd_new --> stream_fd_recv

stream_fd_new-->stream_fd_readable
stream_fd_readable-->__stream_fd_readable
stream_fd_recv-->
__stream_fd_readable-->
stream_packet-->
media_demux_protocols --> 
stun --> __stun_request --> ice_request
```

从SDP Offer之后，stream_fd_new 函数里做了几个事件订阅， 当对应的的媒体端口收到包之后，这个包可能是好几种协议，例如RTP, DTLS, STUN等。

在media_demux_protocols() 中决定了这个包是以上包的哪一种， 如果是STUN包，则进入stun()中处理。

STUN包也分为请求和响应，当消息是响应时，进入ice_request().

```c {linenos=inline hl_lines=["12-14"]}
int ice_request(stream_fd *sfd, const endpoint_t *src,
		struct stun_attrs *attrs)
{
	struct packet_stream *ps = sfd->stream;
	struct call_media *media = ps->media;
	struct ice_agent *ag;
	const char *err;
	struct ice_candidate *cand;
	struct ice_candidate_pair *pair;
	int ret;

	ilogs(ice, LOG_DEBUG, "Received ICE/STUN request from %s on %s",
			endpoint_print_buf(src),
			endpoint_print_buf(&sfd->socket.local));

```

```mermaid
flowchart TD
ice_update-->__do_ice_checks
ice_agents_timer_run-->__do_ice_checks

__do_ice_checks --> __do_ice_check
```