---
title: "pstn"
date: "2020-05-28 10:00:46"
draft: false
---
```makefile
#
# $Id$
#
# example: ser configured as PSTN gateway guard; PSTN gateway is located
# at 192.168.0.10
#

# ------------------ module loading ----------------------------------

#set module path
mpath="/usr/local/lib/opensips/modules/"

loadmodule "sl.so"
loadmodule "tm.so"
loadmodule "acc.so"
loadmodule "rr.so"
loadmodule "maxfwd.so"
loadmodule "db_mysql.so"
loadmodule "auth.so"
loadmodule "auth_db.so"
loadmodule "group.so"
loadmodule "uri.so"

# ----------------- setting module-specific parameters ---------------

modparam("auth_db", "db_url","mysql://opensips:opensipsrw@localhost/opensips")
modparam("auth_db", "calculate_ha1", yes)
modparam("auth_db", "password_column", "password")

# -- acc params --
modparam("acc", "log_level", 1)
# that is the flag for which we will account -- don't forget to
# set the same one :-)
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

	/* ********* RR ********************************** */

	/* grant Route routing if route headers present */
	if (loose_route()) { t_relay(); exit; };
	
	/* record-route INVITEs -- all subsequent requests must visit us */
	if ($rm=="INVITE") {
		record_route();
	};

	# now check if it really is a PSTN destination which should be handled
	# by our gateway; if not, and the request is an invitation, drop it --
	# we cannot terminate it in PSTN; relay non-INVITE requests -- it may
	# be for example BYEs sent by gateway to call originator
	if (!$ru=~"sip:\+?[0-9]+@.*") {
		if ($rm=="INVITE") {
			sl_send_reply("403", "Call cannot be served here");
		} else {
			forward();
		};
		exit;
	}; 

	# account completed transactions via syslog
	setflag(1);

	# free call destinations ... no authentication needed
	if ( is_user_in("Request-URI", "free-pstn")  /* free destinations */
			||  $ru=~"sip:[79][0-9][0-9][0-9]@.*"  /* local PBX */
			|| $ru=~"sip:98[0-9][0-9][0-9][0-9]") {
		log("free call");
	} else if ($si==192.168.0.10) {
		# our gateway doesn't support digest authentication;
		# verify that a request is coming from it by source
		# address
		log("gateway-originated request");
	} else {
		# in all other cases, we need to check the request against
		# access control lists; first of all, verify request
		# originator's identity

		if (!proxy_authorize(	"gateway" /* realm */,
				"subscriber" /* table name */))  {
			proxy_challenge( "gateway" /* realm */, "0" /* no qop */ );
			exit;
		};

		# authorize only for INVITEs -- RR/Contact may result in weird
		# things showing up in d-uri that would break our logic; our
		# major concern is INVITE which causes PSTN costs 

		if ($rm=="INVITE") {

			# does the authenticated user have a permission for local
			# calls (destinations beginning with a single zero)? 
			# (i.e., is he in the "local" group?)
			if ($ru=~"sip:0[1-9][0-9]+@.*") {
				if (!is_user_in("credentials", "local")) {
					sl_send_reply("403", "No permission for local calls"); 
					exit;
				};
			# the same for long-distance (destinations begin with two zeros")
			} else if ($ru=~"sip:00[1-9][0-9]+@.*") {
				if (!is_user_in("credentials", "ld")) {
					sl_send_reply("403", " no permission for LD ");
					exit;
				};
			# the same for international calls (three zeros)
			} else if ($ru=~"sip:000[1-9][0-9]+@.*") {
				if (!is_user_in("credentials", "int")) {
					sl_send_reply("403", "International permissions needed");
					exit;
				};
			# everything else (e.g., interplanetary calls) is denied
			} else {
				sl_send_reply("403", "Forbidden");
				exit;
			};

		}; # INVITE to authorized PSTN

	}; # authorized PSTN

	# if you have passed through all the checks, let your call go to GW!

	rewritehostport("192.168.0.10:5060");

	# forward the request now
	if (!t_relay()) {
		sl_reply_error(); 
		exit; 
	};

}

```

