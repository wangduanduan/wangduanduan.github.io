---
title: "acc"
date: "2020-05-28 09:57:46"
draft: false
---
```makefile
#
# $Id$
#
# example: accounting calls to nummerical destinations
#

# ------------------ module loading ----------------------------------

#set module path
mpath="/usr/local/lib/opensips/modules/"

loadmodule "tm.so"
loadmodule "acc.so"
loadmodule "sl.so"
loadmodule "maxfwd.so"
loadmodule "rr.so"

# ----------------- setting module-specific parameters ---------------

# -- acc params --
# set the reporting log level
modparam("acc", "log_level", 1)
# number of flag, which will be used for accounting; if a message is
# labeled with this flag, its completion status will be reported
modparam("acc", "log_flag", 1 )

# -------------------------  request routing logic -------------------

# main routing logic

route{

	/* ********* ROUTINE CHECKS  ********************************** */

	# filter too old messages
	if (!mf_process_maxfwd_header("10")) {
		log("LOG: Too many hops\n");
		sl_send_reply("483","Too Many Hops");
		exit;
	};
	if ($ml >=  2048 ) {
		sl_send_reply("513", "Message too big");
		exit;
	};

	#  Process record-routing
	if (loose_route()) { 
		# label BYEs for accounting
		if (is_method("BYE"))
			setflag(1);
		t_relay();
		exit;
	};


	# labeled all transaction for accounting
	setflag(1);

	# record-route INVITES to make sure BYEs will visit our server too
	if (is_method("INVITE"))
		record_route();

	# forward the request statefuly now; (we need *stateful* forwarding,
	# because the stateful mode correlates requests with replies and
	# drops retranmissions; otherwise, we would have to report on
	# every single message received)
	if (!t_relay()) {
		sl_reply_error(); 
		exit; 
	};

}

```

