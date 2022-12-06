---
title: "cluecon-fslb"
date: "2019-07-02 22:34:43"
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

log_level=3
memdump=1
log_stderror=yes
log_facility=LOG_LOCAL0

children=10

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


listen=udp:192.168.56.1:5070   # CUSTOMIZE ME


####### Modules Section ########

#set module path
mpath="modules/"

loadmodule "httpd.so"
modparam("httpd", "port", 8081)

loadmodule "mi_json.so"

#### SIGNALING module
loadmodule "signaling.so"

#### StateLess module
loadmodule "sl.so"

#### Transaction Module
loadmodule "tm.so"
modparam("tm", "fr_timeout", 2)
modparam("tm", "fr_inv_timeout", 30)
modparam("tm", "restart_fr_on_each_reply", 0)
modparam("tm", "onreply_avp_mode", 1)

loadmodule "cachedb_local.so"
loadmodule "mathops.so"
modparam("mathops", "decimal_digits", 12)

loadmodule "rest_client.so"

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
modparam("mi_fifo", "fifo_name", "/tmp/opensips_fifo_2")
modparam("mi_fifo", "fifo_mode", 0666)

#### URI module
loadmodule "uri.so"
modparam("uri", "use_uri_table", 0)

loadmodule "cfgutils.so"

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

loadmodule "proto_udp.so"

loadmodule "dialog.so"
loadmodule "statistics.so"

loadmodule "load_balancer.so"
modparam("load_balancer", "db_url", "mysql://opensips:opensipsrw@192.168.56.128/opensips")
modparam("load_balancer", "initial_freeswitch_load", 15)
modparam("load_balancer", "fetch_freeswitch_stats", 1)

loadmodule "freeswitch.so"

loadmodule "db_mysql.so"

####### Routing Logic ########

# main request routing logic

startup_route {
	$stat(neg_replies) = 0;
}

route {
	if ($stat(neg_replies) == "<null>")
		$stat(neg_replies) = 0;

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

	# account only INVITEs
	if (is_method("INVITE")) {
		create_dialog();
		$dlg_val(start_ts) = $Ts;
		$dlg_val(start_tsm) = $Tsm;
		$dlg_val(pdd_pen) = "0";
		t_on_reply("invite_reply");

		do_accounting("log");
	}

	if (!is_myself("$rd")) {
		append_hf("P-hint: outbound\r\n"); 
		route(relay);
	}

	# requests for my domain
	if (is_method("PUBLISH|SUBSCRIBE"))
	{
		sl_send_reply("501", "Not Implemented");
		exit;
	}

	if (is_method("REGISTER"))
	{
		if (!save("location"))
			sl_reply_error();
		exit;
	}

	if ($rU==NULL) {
		# request with no Username in RURI
		sl_send_reply("484","Address Incomplete");
		exit;
	}

	if (!load_balance("2", "call")) {
		xlog("no available destinations!\n");
		send_reply("503", "No available dsts");
		exit;
	}

	# when routing via usrloc, log the missed calls also
	do_accounting("log","missed");
	route(relay);
}

onreply_route [invite_reply] {
	if ($rs == 180) {
		if ($Ts == $(dlg_val(start_ts){s.int})) {
			$var(diff_sec) = 0;
			$var(diff_usec) = $Tsm - $(dlg_val(start_tsm){s.int});
		} else if ($Tsm > $(dlg_val(start_tsm){s.int})) {
			$var(diff_sec) = $Ts - $(dlg_val(start_ts){s.int});
			$var(diff_usec) = $Tsm - $(dlg_val(start_tsm){s.int});
		} else {
			$var(diff_sec) = $Ts - $(dlg_val(start_ts){s.int}) - 1;
			$var(diff_usec) = 1000000 + $Tsm - $(dlg_val(start_tsm){s.int});
		}

		$var(diff_usec) = $var(diff_usec) + $dlg_val(pdd_pen);

		cache_add("local", "tot_sec", $var(diff_sec), 0, $var(nsv));
		cache_add("local", "tot_usec", $var(diff_usec), 0, $var(nmsv));
		cache_add("local", "tot", 1, 0);

		xlog("XXXX: $var(diff_sec) s, $var(diff_usec) us | $var(nsv) | $var(nmsv)\n");
	}
}

route[relay] {
	# for INVITEs enable some additional helper routes
	if (is_method("INVITE")) {
		t_on_branch("per_branch_ops");
		t_on_failure("missed_call");
	}

	if (!t_relay()) {
		send_reply("500","Internal Error");
	}

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

	if (!math_eval("$dlg_val(pdd_pen) + 10000", "$dlg_val(pdd_pen)")) {
		xlog("math eval error $rc\n");
	}

	cache_add("local", "neg_replies", 1, 0);

	if (t_check_status("(5|6)[0-9][0-9]") ||
		(t_check_status("408") && t_local_replied("all"))) {
		xlog("ERROR: FS GW error, status=$rs\n");
		if (!lb_next()) {
			xlog("ERROR: all FS are down!\n");
			send_reply("503", "No available destination");
			exit;
		}
	}

	xlog("rerouting to $ru / $du\n");

	t_on_reply("invite_reply");
	t_on_failure("missed_call");
	t_relay();
	exit;

	# uncomment the following lines if you want to block client 
	# redirect based on 3xx replies.
	##if (t_check_status("3[0-9][0-9]")) {
	##t_reply("404","Not found");
	##	exit;
	##}
}

timer_route [dump_pdd, 1]
{
	$var(out) = 0;
	$var(out_us) = 0;
	$var(tot) = 0;
	$var(result) = 0;

	cache_counter_fetch("local", "tot_sec", $var(out));
	cache_counter_fetch("local", "tot_usec", $var(out_us));
	cache_counter_fetch("local", "tot", $var(tot));

	cache_remove("local", "tot_sec");
	cache_remove("local", "tot_usec");
	cache_remove("local", "tot");

	if ($var(tot) > 0) {
		if (!math_eval("($var(out) + ($var(out_us) / 1000000)) / $var(tot)",
		    "$var(result)")) {
			xlog("math eval error $rc\n");
		}

		route(store_influxdb, "fsdemo", "pdd", "serverB", $var(result));
	}
}

#route [lb_route]
#{
#	xlog("foo: $(avp(lb_loads)[*])\n");
#	route(store_influxdb, "fsdemo", "bal", "serverA", $(avp(lb_loads)[0]));
#	if ($(avp(lb_loads)[1]) != NULL) {
#		route(store_influxdb, "fsdemo", "bal", "serverB", $(avp(lb_loads)[1]));
#	}
#}

route [store_influxdb]
{
	$var(body) = $param(2) + ",host=" + $param(3) + " value=" + $param(4);

	xlog("XXX posting: $var(body) ($param(1) / $param(2) / $param(4))\n");
	if (!rest_post("http://localhost:8086/write?db=$param(1)", "$var(body)", , "$var(body)")) {
		xlog("ERR in rest_post!\n");
		exit;
	}
}

timer_route [dump_reply_stats, 1]
{
	$var(nr) = 0;

	cache_counter_fetch("local", "neg_replies", $var(nr));
	cache_remove("local", "neg_replies");

	route(store_influxdb, "fsdemo", "neg", "serverB", $var(nr));
	route(store_influxdb, "fsdemo", "rpl", "serverB", $stat(rcv_replies));

	xlog("XXX stats: $var(nr)\n");
}

```


