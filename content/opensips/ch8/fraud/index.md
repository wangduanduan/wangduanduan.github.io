---
title: "opensips-summit-fraud"
date: "2019-07-02 22:35:03"
draft: false
---

```bash
#
# $Id$
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

log_level=3
log_stderror=yes
log_facility=LOG_LOCAL0

children=4
memdump=-1

/* uncomment the following line to enable debugging */
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

listen=udp:127.0.0.1:5060   # CUSTOMIZE ME
listen=udp:10.0.2.8:5060   # CUSTOMIZE ME


####### Modules Section ########

#set module path
mpath="modules/"

loadmodule "proto_udp.so"

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
modparam("usrloc", "db_mode",   1)
modparam("usrloc", "db_url", "mysql://root:summit2017@127.0.0.1/opensips_2_3")

#### REGISTRAR module
loadmodule "registrar.so"

loadmodule "drouting.so"
modparam("drouting", "db_url", "mysql://root:summit2017@127.0.0.1/opensips_2_3")

loadmodule "fraud_detection.so"
modparam("fraud_detection", "db_url", "mysql://root:summit2017@127.0.0.1/opensips_2_3")

loadmodule "event_route.so"

loadmodule "cachedb_local.so"

#loadmodule "aaa_radius.so"
#modparam("aaa_radius","radius_config","modules/acc/etc/radius/radiusclient.conf")

#### ACCounting module
loadmodule "acc.so"
/* what special events should be accounted ? */
#modparam("acc", "aaa_url", "radius:modules/acc/etc/radius/radiusclient.conf")
modparam("acc", "early_media", 0)
modparam("acc", "report_cancels", 0)
/* by default we do not adjust the direct of the sequential requests.
   if you enable this parameter, be sure the enable "append_fromtag"
   in "rr" module */
modparam("acc", "detect_direction", 0)
#modparam("acc", "multi_leg_info", "text1=$avp(src);text2=$avp(dst)")
#modparam("acc", "multi_leg_bye_info", "text1=$avp(src);text2=$avp(dst)")
/* account triggers (flags) */


loadmodule "avpops.so"
modparam("avpops", "db_url", "1 mysql://root:summit2017@127.0.0.1/opensips_2_3")

loadmodule "db_mysql.so"
modparam("db_mysql", "exec_query_threshold", 500000)
loadmodule "cfgutils.so"

loadmodule "dialog.so"
loadmodule "rest_client.so"

loadmodule "dispatcher.so"
modparam("dispatcher", "db_url", "mysql://root:summit2017@127.0.0.1/opensips_2_3")

####### Routing Logic ########

# main request routing logic


route
{
	if (!mf_process_maxfwd_header("10")) {
		sl_send_reply("483","Too Many Hops");
		exit;
	}

	if (has_totag()) {
		# sequential requests within a dialog should
		# take the path determined by record-routing
		if (loose_route()) {
			if (is_method("INVITE")) {
				# even if in most of the cases is useless, do RR for
				# re-INVITEs alos, as some buggy clients do change route set
				# during the dialog.
				record_route();
			}

			# route it out to whatever destination was set by loose_route()
			# in $du (destination URI).
			route(relay);
		} else {
			
			if ( is_method("ACK") ) {
				if ( t_check_trans() ) {
					# non loose-route, but stateful ACK; must be an ACK after 
					# a 487 or e.g. 404 from upstream server
					t_relay();
					exit;
				} else {
					# ACK without matching transaction ->
					# ignore and discard
					exit;
				}
			}
			sl_send_reply("404","Not here");
		}
		exit;
	}

	if (is_method("REGISTER"))
	{
		if (!save("location"))
			sl_reply_error();

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
		if (from_uri==myself)
		{
		} else {
			# if caller is not local, then called number must be local
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

	# account only INVITEs
	if (is_method("INVITE")) {
		create_dialog();
		do_accounting("evi", "cdr|missed|failed");
	}

	if (!uri==myself) {
		append_hf("P-hint: outbound\r\n"); 
		route(relay);
	}

	# requests for my domain
	if (is_method("PUBLISH|SUBSCRIBE"))
	{
		sl_send_reply("503", "Service Unavailable");
		exit;
	}

	if ($rU==NULL) {
		# request with no Username in RURI
		sl_send_reply("484","Address Incomplete");
		exit;
	}

	if (!check_fraud("$fU", "$rU", "2")) {
		send_reply("403", "Forbidden");
		exit;
	}

	$du = "sip:10.0.2.8:7050";

	route(relay);
}


route [relay]
{
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

route [ds_route]
{
	xlog("foo\n");
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

event_route [E_FRD_WARNING]
{
	fetch_event_params("$var(param);$var(val);$var(thr);$var(user);$var(number);$var(ruleid)");
	xlog("E_FRD_WARNING: $var(param);$var(val);$var(thr);$var(user);$var(number);$var(ruleid)\n");

	if ($var(param) == "calls per minute") {
		xlog("e_frd_cpm++!\n");
		cache_add("local", "e_frd_cpm", 1, 0);
	} else if ($var(param) == "call_duration") {
		xlog("e_frd_cdur++!\n");
		cache_add("local", "e_frd_cdur", 1, 0);
	} else if ($var(param) == "total calls") {
		xlog("e_frd_tc++!\n");
		cache_add("local", "e_frd_tc", 1, 0);
	} else if ($var(param) == "concurrent calls") {
		xlog("e_frd_cc++!\n");
		cache_add("local", "e_frd_cc", 1, 0);
	} else if ($var(param) == "sequential calls") {
		xlog("e_frd_seq++!\n");
		cache_add("local", "e_frd_seq", 1, 0);
	}
}

event_route [E_FRD_CRITICAL]
{
	fetch_event_params("$var(param);$var(val);$var(thr);$var(user);$var(number);$var(ruleid)");
	xlog("E_FRD_CRITICAL: $var(param);$var(val);$var(thr);$var(user);$var(number);$var(ruleid)\n");

	if ($var(param) == "calls per minute") {
		xlog("e_frd_critcpm++\n");
		cache_add("local", "e_frd_critcpm", 1, 0);
	} else if ($var(param) == "call_duration") {
		xlog("e_frd_critcdur++\n");
		cache_add("local", "e_frd_critcdur", 1, 0);
	} else if ($var(param) == "total calls") {
		xlog("e_frd_crittc++!\n");
		cache_add("local", "e_frd_crittc", 1, 0);
	} else if ($var(param) == "concurrent calls") {
		xlog("e_frd_critcc++!\n");
		cache_add("local", "e_frd_critcc", 1, 0);
	} else if ($var(param) == "sequential calls") {
		xlog("e_frd_critseq++!\n");
		cache_add("local", "e_frd_critseq", 1, 0);
	}
}

route [store_influxdb]
{
	$var(body) = $param(2) + ",host=" + $param(3) + " value=" + $param(4);

	xlog("XXX posting: $var(body) ($param(1) / $param(2) / $param(4))\n");
	if (!rest_post("http://localhost:8086/write?db=$param(1)", "$var(body)", , "$var(body)")) {
		xlog("ERR in rest_post!\n");
		exit;
	}
}

timer_route [dump_fraud_cpm, 1]
{
	$var(cpm) = 0;
	$var(ccpm) = 0;

	cache_counter_fetch("local", "e_frd_cpm", $var(cpm));
	cache_counter_fetch("local", "e_frd_critcpm", $var(ccpm));
	cache_remove("local", "e_frd_cpm");
	cache_remove("local", "e_frd_critcpm");

	route(store_influxdb, "fraud_demo", "cpm", "serverA", $var(cpm));
	route(store_influxdb, "fraud_demo", "critcpm", "serverA", $var(ccpm));

	xlog("XXX stats: $var(cpm) / $var(ccpm)\n");
}

timer_route [dump_fraud_cdur, 1]
{
	$var(cdur) = 0;
	$var(ccdur) = 0;

	cache_counter_fetch("local", "e_frd_cdur", $var(cdur));
	cache_counter_fetch("local", "e_frd_critcdur", $var(ccdur));
	cache_remove("local", "e_frd_cdur");
	cache_remove("local", "e_frd_critcdur");

	route(store_influxdb, "fraud_demo", "cdur", "serverA", $var(cdur));
	route(store_influxdb, "fraud_demo", "critcdur", "serverA", $var(ccdur));

	xlog("XXX stats: $var(cdur) / $var(ccdur)\n");
}

timer_route [dump_fraud_tc, 1]
{
	$var(tc) = 0;
	$var(ctc) = 0;

	cache_counter_fetch("local", "e_frd_tc", $var(tc));
	cache_counter_fetch("local", "e_frd_crittc", $var(ctc));
	cache_remove("local", "e_frd_tc");
	cache_remove("local", "e_frd_crittc");

	route(store_influxdb, "fraud_demo", "tc", "serverA", $var(tc));
	route(store_influxdb, "fraud_demo", "crittc", "serverA", $var(ctc));

	xlog("XXX stats: $var(tc) / $var(ctc)\n");
}

timer_route [dump_fraud_cc, 1]
{
	$var(cc) = 0;
	$var(ccc) = 0;

	cache_counter_fetch("local", "e_frd_cc", $var(cc));
	cache_counter_fetch("local", "e_frd_critcc", $var(ccc));
	cache_remove("local", "e_frd_cc");
	cache_remove("local", "e_frd_critcc");

	route(store_influxdb, "fraud_demo", "cc", "serverA", $var(cc));
	route(store_influxdb, "fraud_demo", "critcc", "serverA", $var(ccc));

	xlog("XXX stats: $var(cc) / $var(ccc)\n");
}

timer_route [dump_fraud_seq, 1]
{
	$var(seq) = 0;
	$var(cseq) = 0;

	cache_counter_fetch("local", "e_frd_seq", $var(seq));
	cache_counter_fetch("local", "e_frd_critseq", $var(cseq));
	cache_remove("local", "e_frd_seq");
	cache_remove("local", "e_frd_critseq");

	route(store_influxdb, "fraud_demo", "seq", "serverA", $var(seq));
	route(store_influxdb, "fraud_demo", "critseq", "serverA", $var(cseq));

	xlog("XXX stats: $var(seq) / $var(cseq)\n");
}

```


