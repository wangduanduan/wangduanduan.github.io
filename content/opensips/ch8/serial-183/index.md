---
title: "serial_183"
date: "2020-05-28 10:01:57"
draft: false
---
```makefile
#
# this example shows how to use forking on failure
#

log_level=3
log_stderror=1

listen=192.168.2.16
# ------------------ module loading ----------------------------------

#set module path
mpath="/usr/local/lib/opensips/modules/"

# Uncomment this if you want to use SQL database
loadmodule "tm.so"
loadmodule "sl.so"
loadmodule "maxfwd.so"
# -------------------------  request routing logic -------------------

# main routing logic

route{

	# initial sanity checks -- messages with
	# max_forwards==0, or excessively long requests
	if (!mf_process_maxfwd_header("10")) {
		sl_send_reply("483","Too Many Hops");
		exit;
	};
	if ($ml >=  2048 ) {
		sl_send_reply("513", "Message too big");
		exit;
	};

	# skip register for testing purposes
	if (is_methos("REGISTER")) {
		sl_send_reply("200", "ok");
		exit;
	};

	if (is_method("INVITE")) {
		seturi("sip:xxx@192.168.2.16:5064");
		# if transaction broken, try other an alternative route
		t_on_failure("1");
		# if a provisional came, stop alternating
		t_on_reply("1");
	};
	t_relay();
}

failure_route[1] {
	log(1, "trying at alternate destination\n");
	seturi("sip:yyy@192.168.2.16:5064");
	t_relay();
}

onreply_route[1] {
	log(1, "reply came in\n");
	if ($rs=~"18[0-9]")  {
		log(1, "provisional -- resetting negative failure\n");
		t_on_failure("0");
	};
}

```

