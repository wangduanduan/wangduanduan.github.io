---
title: "freeswitch-dtmf-language"
date: "2019-07-02 22:34:27"
draft: false
---

```bash
#
# OpenSIPS residential configuration script
#     by OpenSIPS Solutions <team@opensips-solutions.com>
#
# This script was generated via "make menuconfig", from
#   the "Residential" scenario.
# You can enable / disable more features / functionalities by
#   re-generating the scenario with different options.#
#
# Please refer to the Core CookBook at:
#      http://www.opensips.org/Resources/DocsCookbooks
# for a explanation of possible statements, functions and parameters.
#


####### Global Parameters #########

log_level=4
log_stderror=no
log_facility=LOG_LOCAL0

children=4

/* uncomment the following lines to enable debugging */
#debug_mode=yes

/* uncomment the next line to enable the auto temporary blacklisting of 
   not available destinations (default disabled) */
#disable_dns_blacklist=no

/* uncomment the next line to enable IPv6 lookup after IPv4 dns 
   lookup failures (default disabled) */
#dns_try_ipv6=yes

/* comment the next line to enable the auto discovery of local aliases
   based on revers DNS on IPs */
auto_aliases=no


listen = udp:10.0.0.10:5060


####### Modules Section ########

#set module path
mpath="/usr/local/lib/opensips/modules/"

#### SIGNALING module
loadmodule "signaling.so"

#### StateLess module
loadmodule "sl.so"

#### Transaction Module
loadmodule "tm.so"
modparam("tm", "fr_timeout", 5)
modparam("tm", "fr_inv_timeout", 30)
modparam("tm", "restart_fr_on_each_reply", 0)
modparam("tm", "onreply_avp_mode", 1)

#### Record Route Module
loadmodule "rr.so"
/* do not append from tag to the RR (no need for this script) */
modparam("rr", "append_fromtag", 0)

#### MAX ForWarD module
loadmodule "maxfwd.so"

#### SIP MSG OPerationS module
loadmodule "sipmsgops.so"

#### FIFO Management Interface
loadmodule "mi_fifo.so"
modparam("mi_fifo", "fifo_name", "/tmp/opensips_fifo")
modparam("mi_fifo", "fifo_mode", 0666)

#### URI module
loadmodule "uri.so"
modparam("uri", "use_uri_table", 0)

#### USeR LOCation module
loadmodule "usrloc.so"
modparam("usrloc", "nat_bflag", "NAT")
modparam("usrloc", "db_mode",   0)

#### REGISTRAR module
loadmodule "registrar.so"
modparam("registrar", "tcp_persistent_flag", "TCP_PERSISTENT")
/* uncomment the next line not to allow more than 10 contacts per AOR */
#modparam("registrar", "max_contacts", 10)

#### ACCounting module
loadmodule "acc.so"
/* what special events should be accounted ? */
modparam("acc", "early_media", 0)
modparam("acc", "report_cancels", 0)
/* by default we do not adjust the direct of the sequential requests.
   if you enable this parameter, be sure the enable "append_fromtag"
   in "rr" module */
modparam("acc", "detect_direction", 0)

loadmodule "cachedb_local.so"

loadmodule "freeswitch.so"

loadmodule "freeswitch_scripting.so"
modparam("freeswitch_scripting", "fs_subscribe", "fs://:ClueCon@10.0.0.246:8021/database?DTMF,CHANNEL_STATE,CHANNEL_ANSWER,HEARTBEAT")

loadmodule "db_mysql.so"
loadmodule "cfgutils.so"

loadmodule "drouting.so"
modparam("drouting", "db_url", "mysql://root:liviusmysqlpassword@localhost/opensips")

loadmodule "event_route.so"
loadmodule "json.so"

loadmodule "proto_udp.so"

####### Routing Logic ########

# main request routing logic

# $param(1) - 1 if the R-URI IP:port should be rewritten
route [goes_to_support] {
	if ($param(1) == 1)
		$var(flags) = "";
	else
		$var(flags) = "C";

	if (do_routing("0", "$var(flags)"))
		return(1);

	return(-1);
}

route [FREESWITCH_XFER_BY_DTMF_LANG] {
	# this call has already been transferred
	if (cache_fetch("local", "DTMF-$json(body/Unique-ID)", $var(_)))
		return;

	switch ($json(body/DTMF-Digit)) {
	case "1":
		xlog("transferring to English support line\n");
		freeswitch_esl("bgapi uuid_transfer $json(body/Unique-ID) -aleg 1001",
		               "$var(fs_box)", "$var(output)");
		break;
	case "2":
		xlog("transferring to Spanish support line\n");
		freeswitch_esl("bgapi uuid_transfer $json(body/Unique-ID) -aleg 1002",
		               "$var(fs_box)", "$var(output)");
		break;
	default:
		xlog("DEFAULT: transferring to English support line\n");
		freeswitch_esl("bgapi uuid_transfer $json(body/Unique-ID) -aleg 1001",
		               "$var(fs_box)", "$var(output)");
	}

	xlog("ran FS uuid_transfer, output: $var(output)\n");

	cache_store("local", "DTMF-$json(body/Unique-ID)", "OK", 600);
}

event_route [E_FREESWITCH] {
	fetch_event_params("$var(event_name);$var(fs_box);$var(event_body)");
	xlog("FreeSWITCH event $var(event_name) from $var(fs_box), with $var(event_body)\n");

	$json(body) := $var(event_body);

	if ($var(event_name) == "DTMF") {
		$rU = $json(body/Caller-Destination-Number);
		if (!$rU) {
			xlog("SCRIPT:DTMF:ERR: missing body/Caller-Destination-Number field!\n");
			return;
		}

		if (route(goes_to_support, 0))
			route(FREESWITCH_XFER_BY_DTMF_LANG);
	}
}

route {
	if (!mf_process_maxfwd_header("10")) {
		sl_send_reply("483","Too Many Hops");
		exit;
	}

	if (has_totag()) {

		# handle hop-by-hop ACK (no routing required)
		if ( is_method("ACK") && t_check_trans() ) {
			t_relay();
			exit;
		}

		# sequential request within a dialog should
		# take the path determined by record-routing
		if ( !loose_route() ) {
			# we do record-routing for all our traffic, so we should not
			# receive any sequential requests without Route hdr.
			sl_send_reply("404","Not here");
			exit;
		}

		if (is_method("BYE")) {
			# do accounting even if the transaction fails
			do_accounting("log","failed");
		}

		# route it out to whatever destination was set by loose_route()
		# in $du (destination URI).
		route(relay);
		exit;
	}

	# CANCEL processing
	if (is_method("CANCEL"))
	{
		if (t_check_trans())
			t_relay();
		exit;
	}

	t_check_trans();

	if ( !(is_method("REGISTER")  ) ) {
		if (is_myself("$fd"))
		{
		} else {
			# if caller is not local, then called number must be local
			if (!is_myself("$rd")) {
				send_reply("403","Rely forbidden");
				exit;
			}
		}
	}

	# preloaded route checking
	if (loose_route()) {
		xlog("L_ERR",
		"Attempt to route with preloaded Route's [$fu/$tu/$ru/$ci]");
		if (!is_method("ACK"))
			sl_send_reply("403","Preload Route denied");
		exit;
	}

	# record routing
	if (!is_method("REGISTER|MESSAGE"))
		record_route();

	# requests for my domain
	if (is_method("PUBLISH|SUBSCRIBE"))
	{
		sl_send_reply("503", "Service Unavailable");
		exit;
	}

	if (is_method("REGISTER"))
	{
		if (!save("location"))
			sl_reply_error();
		exit;
	}

	if (!is_method("INVITE")) {
		sl_send_reply("405", "Method Not Allowed");
		exit;
	}

	do_accounting("log");

	if (!is_myself("$rd")) {
		append_hf("P-hint: outbound\r\n"); 
		route(relay);
	}

	if ($rU==NULL) {
		# request with no Username in RURI
		sl_send_reply("484","Address Incomplete");
		exit;
	}

	# do lookup with method filtering
	if (!lookup("location","m")) {
		t_reply("404", "Not Found");
		exit;
	}

	# when routing via usrloc, log the missed calls also
	do_accounting("log","missed");
	route(relay);
}

route[relay] {
	# for INVITEs enable some additional helper routes
	if (is_method("INVITE")) {
		t_on_branch("per_branch_ops");
		t_on_reply("handle_nat");
		t_on_failure("missed_call");
	}

	if (!t_relay()) {
		send_reply("500","Internal Error");
	};
	exit;
}


branch_route[per_branch_ops] {
	xlog("new branch at $ru\n");
}


onreply_route[handle_nat] {
	xlog("incoming reply\n");
}


failure_route[missed_call] {
	if (t_was_cancelled()) {
		exit;
	}

	# uncomment the following lines if you want to block client 
	# redirect based on 3xx replies.
	##if (t_check_status("3[0-9][0-9]")) {
	##t_reply("404","Not found");
	##	exit;
	##}
}
```


