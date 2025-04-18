---
title: "读到无法解析的TCP包后, kamailio如何处理？"
date: "2025-04-18 23:05:15"
draft: false
type: posts
tags:
- all
categories:
- all
---

```c {linenos=inline hl_lines=[5]}
int receive_msg(char *buf, unsigned int len, receive_info_t *rcv_info) {
	if(parse_msg(buf, len, msg) != 0) {
		errsipmsg = 1;
		evp.data = (void *)msg;

        // note: 这里尝试查找并执行nosip模块的 event_route[nosip:msg]事件路由
        // 一般情况下，如果没有找到，那么ret的值是-1
        // 那么这里的if内部不会执行
		if((ret = sr_event_exec(SREV_RCV_NOSIP, &evp)) < NONSIP_MSG_DROP) {
			LM_DBG("attempt of nonsip message processing failed\n");
		} else if(ret == NONSIP_MSG_DROP) {
            // 这里也不会执行
			LM_DBG("nonsip message processing completed\n");
			goto end;
		}
	}

    // 由于在上面的判断里errsipmsg被设置成1，所以这里的if条件成立
    if(errsipmsg == 1) {
        // 打印报错信息，并执行核心错误处理
		LOG(cfg_get(core, core_cfg, sip_parser_log),
				"core parsing of SIP message failed (%s:%d/%d)\n",
				ip_addr2a(&msg->rcv.src_ip), (int)msg->rcv.src_port,
				(int)msg->rcv.proto);
		sr_core_ert_run(msg, SR_CORE_ERT_RECEIVE_PARSE_ERROR);

        // 跳转到error02标签，执行后续的清理工作
		goto error02;
	}

// 跳转到error02标签，执行后续的清理工作
error02:
	free_sip_msg(msg);
	pkg_free(msg);
error00:
	ksr_msg_env_reset();
	/* reset log prefix */
	log_prefix_set(NULL);

    // 返回-1，表示出错
	return -1;
}
```

- 如果调用receive_msg返回负数，那么从调用栈向上查找receive_tcp_msg函数也会返回负数
  - int receive_tcp_msg(char *tcpbuf, unsigned int len,struct receive_info *rcv_info, struct tcp_connection *con)
- receive_tcp_msg函数返回负数，那么向上查找，tcp_read_req也会返回负数
  - int tcp_read_req(struct tcp_connection *con, int *bytes_read,rd_conn_flags_t *read_flags)
- tcp_read_req返回负数
  - inline static int handle_io(struct fd_map *fm, short events, int idx)在这个函数内部


```c
		if(unlikely(bytes < 0)) {
			LOG(cfg_get(core, core_cfg, corelog),
					"ERROR: tcp_read_req: error reading - c: %p r: %p (%d)\n",
					con, req, bytes);
			resp = CONN_ERROR;
			goto end_req;
		}

        resp = tcp_read_req(con, &n, &read_flags);
			if(unlikely(resp < 0)) {
				/* some error occurred, but on the new fd, not on the tcp
				 * main fd, so keep the ret value */
				if(unlikely(resp != CONN_EOF))
					con->state = S_CONN_BAD;
				release_tcpconn(con, resp, tcpmain_sock);
				break;
        }
```

整个调用链条是这样的：
handle_io -> tcp_read_req -> receive_tcp_msg -> receive_msg


也就是说，如果没有设置事件路由event_route[nosip:msg]。很大可能基于TCP的链接会主动被kamailio关闭。这样做是安全考量，因为如果kamailio无法解析SIP包，那么它可能不是一个合法的SIP消息。这个行为可以防止恶意用户发送非SIP消息来占用服务器资源。