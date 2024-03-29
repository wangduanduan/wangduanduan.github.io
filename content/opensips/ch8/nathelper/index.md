---
title: "nathelper"
date: "2020-05-28 10:00:24"
draft: false
---
```makefile
#
# simple quick-start config script including nathelper support

# This default script includes nathelper support. To make it work
# you will also have to install Maxim's RTP proxy. The proxy is enforced
# if one of the parties is behind a NAT.
#
# If you have an endpoing in the public internet which is known to
# support symmetric RTP (Cisco PSTN gateway or voicemail, for example),
# then you don't have to force RTP proxy. If you don't want to enforce
# RTP proxy for some destinations than simply use t_relay() instead of
# route(1)
#
# Sections marked with !! Nathelper contain modifications for nathelper
#
# NOTE !! This config is EXPERIMENTAL !
#
# ----------- global configuration parameters ------------------------

log_level=3      # logging level (cmd line: -dddddddddd)
log_stderror=no  # (cmd line: -E)

/* Uncomment these lines to enter debugging mode */
#debug_mode=yes

check_via=no	# (cmd. line: -v)
dns=no           # (cmd. line: -r)
rev_dns=no      # (cmd. line: -R)
port=5060
children=4

# ------------------ module loading ----------------------------------

#set module path
mpath="/usr/local/lib/opensips/modules/"

# Uncomment this if you want to use SQL database
#loadmodule "db_mysql.so"

loadmodule "sl.so"
loadmodule "tm.so"
loadmodule "signaling.so"
loadmodule "rr.so"
loadmodule "maxfwd.so"
loadmodule "usrloc.so"
loadmodule "registrar.so"
loadmodule "textops.so"
loadmodule "mi_fifo.so"

# Uncomment this if you want digest authentication
# db_mysql.so must be loaded !
#loadmodule "auth.so"
#loadmodule "auth_db.so"

# !! Nathelper
loadmodule "nathelper.so"
loadmodule "rtpproxy.so"

# ----------------- setting module-specific parameters ---------------

# -- mi_fifo params --
modparam("mi_fifo", "fifo_name", "/tmp/opensips_fifo")

# -- usrloc params --
modparam("usrloc", "db_mode",   0)

# Uncomment this if you want to use SQL database 
# for persistent storage and comment the previous line
#modparam("usrloc", "db_mode", 2)

# -- auth params --
# Uncomment if you are using auth module
#modparam("auth_db", "calculate_ha1", yes)
#
# If you set "calculate_ha1" parameter to yes (which true in this config), 
# uncomment also the following parameter)
#modparam("auth_db", "password_column", "password")

# !! Nathelper
modparam("usrloc","nat_bflag",6)
modparam("nathelper","sipping_bflag",8)
modparam("nathelper", "ping_nated_only", 1)   # Ping only clients behind NAT

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

	# !! Nathelper
	# Special handling for NATed clients; first, NAT test is
	# executed: it looks for via!=received and RFC1918 addresses
	# in Contact (may fail if line-folding is used); also,
	# the received test should, if completed, should check all
	# vias for rpesence of received
	if (nat_uac_test("3")) {
		# Allow RR-ed requests, as these may indicate that
		# a NAT-enabled proxy takes care of it; unless it is
		# a REGISTER

		if (is_method("REGISTER") || !is_present_hf("Record-Route")) {
			log("LOG:Someone trying to register from private IP, rewriting\n");
			# This will work only for user agents that support symmetric
			# communication. We tested quite many of them and majority is
			# smart enough to be symmetric. In some phones it takes a 
			# configuration option. With Cisco 7960, it is called 
			# NAT_Enable=Yes, with kphone it is called "symmetric media" and 
			# "symmetric signalling".

			# Rewrite contact with source IP of signalling
			fix_nated_contact();
			if ( is_method("INVITE") ) {
				fix_nated_sdp("1"); # Add direction=active to SDP
			};
			force_rport(); # Add rport parameter to topmost Via
			setbflag(6);    # Mark as NATed

			# if you want sip nat pinging
			# setbflag(8);
		};
	};

	# subsequent messages withing a dialog should take the
	# path determined by record-routing
	if (loose_route()) {
		# mark routing logic in request
		append_hf("P-hint: rr-enforced\r\n"); 
		route(1);
		exit;
	};

	# we record-route all messages -- to make sure that
	# subsequent messages will go through our proxy; that's
	# particularly good if upstream and downstream entities
	# use different transport protocol
	if (!is_method("REGISTER"))
		record_route();

	if (!is_myself("$rd")) {
		# mark routing logic in request
		append_hf("P-hint: outbound\r\n"); 
		route(1);
		exit;
	};

	# if the request is for other domain use UsrLoc
	# (in case, it does not work, use the following command
	# with proper names and addresses in it)
	if (is_myself("$rd")) {

		if (is_method("REGISTER")) {

			# Uncomment this if you want to use digest authentication
			#if (!www_authorize("siphub.org", "subscriber")) {
			#	www_challenge("siphub.org", "0");
			#	return;
			#};

			save("location");
			exit;
		};

		lookup("aliases");
		if (!is_myself("$rd")) {
			append_hf("P-hint: outbound alias\r\n"); 
			route(1);
			exit;
		};

		# native SIP destinations are handled using our USRLOC DB
		if (!lookup("location")) {
			sl_send_reply("404", "Not Found");
			exit;
		};
	};
	append_hf("P-hint: usrloc applied\r\n"); 
	route(1);
}

route[1] 
{
	# !! Nathelper
	if ($ru=~"[@:](192\.168\.|10\.|172\.(1[6-9]|2[0-9]|3[0-1])\.)" && !search("^Route:")){
		sl_send_reply("479", "We don't forward to private IP addresses");
		exit;
	};

	# if client or server know to be behind a NAT, enable relay
	if (isbflagset(6)) {
		rtpproxy_offer();
	};

	# NAT processing of replies; apply to all transactions (for example,
	# re-INVITEs from public to private UA are hard to identify as
	# NATed at the moment of request processing); look at replies
	t_on_reply("1");

	# send it out now; use stateful forwarding as it works reliably
	# even for UDP2TCP
	if (!t_relay()) {
		sl_reply_error();
	};
}

# !! Nathelper
onreply_route[1] {
	# NATed transaction ?
	if (isbflagset(6) && $rs =~ "(183)|2[0-9][0-9]") {
		fix_nated_contact();
		rtpproxy_answer();
	# otherwise, is it a transaction behind a NAT and we did not
	# know at time of request processing ? (RFC1918 contacts)
	} else if (nat_uac_test("1")) {
		fix_nated_contact();
	};
}


```

