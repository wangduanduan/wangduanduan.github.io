---
title: "exec"
date: "2020-05-28 09:58:09"
draft: false
---
```makefile
#
# $Id$
#
# simple quick-start config script
#

# ----------- global configuration parameters ------------------------

#set module path
mpath="/usr/local/lib/opensips/modules/"
loadmodule "sl.so"
loadmodule "tm.so"
loadmodule "usrloc.so"
loadmodule "registrar.so"
loadmodule "exec.so"

# ----------------- setting module-specific parameters ---------------

route{
	# uri for my domain ?
	if (is_myself("$rd")) {

		if ($rm=="REGISTER") {
			save("location");
			return;
		};

		# native SIP destinations are handled using our USRLOC DB
		if (!lookup("location")) {
			# proceed to email notification
			if ($rm=="INVITE") route(1)
			else sl_send_reply("404", "Not Found");
			exit;
		};
	};
	# user found, forward to his current uri now
	if (!t_relay()) {
		sl_reply_error();
	};
}

/* handling of missed calls */
route[1] {
	# don't continue if it is a retransmission
	if ( !t_newtran()) {
		sl_reply_error();
		exit;
	};
	# external script: lookup user, if user exists, send 
	# an email notification to him
	if (!exec_msg('
		QUERY="select email_address from subscriber 
			where user=\"$$SIP_OUSER\"";
		EMAIL=`mysql  -Bsuser -pheslo -e "$$QUERY" ser`;
		if [ -z "$$EMAIL" ] ; then exit 1; fi ;
		echo "SIP request received from $$SIP_HF_FROM for $$SIP_OUSER" |
		mail -s "request for you" $$EMAIL ')) 
	{
		# exec returned error ... user does not exist
		# send a stateful reply
		t_reply("404", "User does not exist");
	} else {
		t_reply("600", "No messages for this user");
	};
	exit;
}

```

