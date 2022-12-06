---
title: "msilo"
date: "2020-05-28 10:00:04"
draft: false
---
```makefile
#
# MSILO usage example
#
# $ID: daniel $
#



children=2
check_via=no      # (cmd. line: -v)
dns=off           # (cmd. line: -r)
rev_dns=off       # (cmd. line: -R)


# ------------------ module loading ----------------------------------
#set module path
mpath="/usr/local/lib/opensips/modules/"
loadmodule "textops.so"
loadmodule "sl.so"
loadmodule "db_mysql.so"
loadmodule "maxfwd.so"
loadmodule "tm.so"
loadmodule "usrloc.so"
loadmodule "registrar.so"
loadmodule "msilo.so"

# ----------------- setting module-specific parameters ---------------

# -- registrar params --
modparam("registrar", "default_expires", 120)

# -- usrloc params --
modparam("usrloc", "db_mode", 0)

# -- msilo params --
modparam("msilo", "db_url", "mysql://opensips:opensipsrw@localhost/opensips")

# -- tm params --
modparam("tm", "fr_timer", 10 )
modparam("tm", "fr_inv_timer", 15 )
modparam("tm", "wt_timer", 10 )


route{
	if ( !mf_process_maxfwd_header("10") ) {
		sl_send_reply("483","To Many Hops");
		exit;
	};

	if (is_myself("$rd")) {
		# for testing purposes, simply okay all REGISTERs
		# is_method("XYZ") is faster than ($rm=="XYZ")
		#  but requires textops module
		if (is_method("REGISTER")) {
			save("location");
			log("REGISTER received -> dumping messages with MSILO\n");

			# MSILO - dumping user's offline messages
			if (m_dump()) {
				log("MSILO: offline messages dumped - if they were\n");
			} else {
				log("MSILO: no offline messages dumped\n");
			};
			exit;
		};

		# backup r-uri for m_dump() in case of delivery failure
		$avp(11) = $ru;

		# domestic SIP destinations are handled using our USRLOC DB

		if(!lookup("location")) {
			if (! t_newtran()) {
				sl_reply_error();
				exit;
			};
			# we do not care about anything else but MESSAGEs
			if (!is_method("MESSAGE")) {
				if (!t_reply("404", "Not found")) {
					sl_reply_error();
				};
				exit;
			};
			log("MESSAGE received -> storing using MSILO\n");
			# MSILO - storing as offline message
			if (m_store("$ru")) {
				log("MSILO: offline message stored\n");
				if (!t_reply("202", "Accepted"))  {
					sl_reply_error();
				};
			}else{
				log("MSILO: offline message NOT stored\n");
				if (!t_reply("503", "Service Unavailable")) {
					sl_reply_error();
				};
			};
			exit;
		};
		# if the downstream UA does not support MESSAGE requests
		# go to failure_route[1]
		t_on_failure("1");
		t_relay();
		exit;
	};

	# forward anything else
	t_relay();
}

failure_route[1] {
	# forwarding failed -- check if the request was a MESSAGE 
	if (!is_method("MESSAGE"))
		exit;

	log(1,"MSILO: the downstream UA does not support MESSAGE requests ...\n");
	# we have changed the R-URI with the contact address -- ignore it now
	if (m_store("$avp(11)")) {
		log("MSILO: offline message stored\n");
		t_reply("202", "Accepted"); 
	}else{
		log("MSILO: offline message NOT stored\n");
		t_reply("503", "Service Unavailable");
	};
}



```

