---
title: "acc-mysql"
date: "2020-05-28 09:57:04"
draft: false
---
```makefile
#
# Sample config for MySQL accouting with OpenSIPS 
#
# - db_mysql module must be compiled and installed
#
# - new columns have to be added since by default only few are recorded
# - here are full SQL statements to create acc and missed_calls tables
#
# CREATE TABLE `acc` (
#   `id` int(10) unsigned NOT NULL auto_increment,
#   `method` varchar(16) NOT NULL default '',
#   `from_tag` varchar(64) NOT NULL default '',
#   `to_tag` varchar(64) NOT NULL default '',
#   `callid` varchar(128) NOT NULL default '',
#   `sip_code` char(3) NOT NULL default '',
#   `sip_reason` varchar(32) NOT NULL default '',
#   `time` datetime NOT NULL default '0000-00-00 00:00:00',
#   `src_ip` varchar(64) NOT NULL default '',
#   `dst_user` varchar(64) NOT NULL default '',
#   `dst_domain` varchar(128) NOT NULL default '',
#   `src_user` varchar(64) NOT NULL default '',
#   `src_domain` varchar(128) NOT NULL default '',
#   INDEX acc_callid (`callid`),
#   PRIMARY KEY  (`id`)
# );
#
# CREATE TABLE `missed_calls` (
#   `id` int(10) unsigned NOT NULL auto_increment,
#   `method` varchar(16) NOT NULL default '',
#   `from_tag` varchar(64) NOT NULL default '',
#   `to_tag` varchar(64) NOT NULL default '',
#   `callid` varchar(128) NOT NULL default '',
#   `sip_code` char(3) NOT NULL default '',
#   `sip_reason` varchar(32) NOT NULL default '',
#   `time` datetime NOT NULL default '0000-00-00 00:00:00',
#   `src_ip` varchar(64) NOT NULL default '',
#   `dst_user` varchar(64) NOT NULL default '',
#   `dst_domain` varchar(128) NOT NULL default '',
#   `src_user` varchar(64) NOT NULL default '',
#   `src_domain` varchar(128) NOT NULL default '',
#   INDEX acc_callid (`callid`),
#   PRIMARY KEY  (`id`)
# );
#
#

# ----------- global configuration parameters ------------------------

log_level=3            # debug level (cmd line: -dddddddddd)
log_stderror=no    # (cmd line: -E)

/* Uncomment these lines to enter debugging mode */
#debug_mode=yes

check_via=no	# (cmd. line: -v)
dns=no          # (cmd. line: -r)
rev_dns=no      # (cmd. line: -R)
port=5060
children=4

#
# uncomment the following lines for TLS support
#disable_tls = 0
#listen = tls:your_IP:5061
#tls_verify_server = 1
#tls_verify_client = 1
#tls_require_client_certificate = 0
#tls_method = TLSv1
#tls_certificate = "/usr/local/etc/opensips/tls/user/user-cert.pem"
#tls_private_key = "/usr/local/etc/opensips/tls/user/user-privkey.pem"
#tls_ca_list = "/usr/local/etc/opensips/tls/user/user-calist.pem"

# ------------------ module loading ----------------------------------

# set module path
mpath="/usr/local/lib/opensips/modules/"

# Uncomment this if you want to use SQL database
# - MySQL loaded for accounting as well
loadmodule "db_mysql.so"

loadmodule "sl.so"
loadmodule "tm.so"
loadmodule "rr.so"
loadmodule "maxfwd.so"
loadmodule "usrloc.so"
loadmodule "registrar.so"
loadmodule "textops.so"
loadmodule "acc.so"
loadmodule "mi_fifo.so"

# Uncomment this if you want digest authentication
# db_mysql.so must be loaded !
#loadmodule "auth.so"
#loadmodule "auth_db.so"

# ----------------- setting module-specific parameters ---------------

# -- mi_fifo params --

modparam("mi_fifo", "fifo_name", "/tmp/opensips_fifo")

# -- usrloc params --

#modparam("usrloc", "db_mode",   0)

# Uncomment this if you want to use SQL database 
# for persistent storage and comment the previous line
modparam("usrloc", "db_mode", 2)

# -- auth params --
# Uncomment if you are using auth module
#
#modparam("auth_db", "calculate_ha1", yes)
#
# If you set "calculate_ha1" parameter to yes (which true in this config), 
# uncomment also the following parameter)
#
#modparam("auth_db", "password_column", "password")

# -- acc params --
modparam("acc", "db_url", "mysql://opensips:opensipsrw@localhost/opensips")
# flag to record to db
modparam("acc", "db_flag", 1)
modparam("acc", "db_missed_flag", 2)
# flag to log to syslog
modparam("acc", "log_flag", 1)
modparam("acc", "log_missed_flag", 2)
# use extra accounting to record caller and callee username/domain
# - take them from From URI and R-URI
modparam("acc", "log_extra",
	"src_user=$fU;src_domain=$fd;dst_user=$rU;dst_domain=$rd")
modparam("acc", "db_extra",
	"src_user=$fU;src_domain=$fd;dst_user=$rU;dst_domain=$rd")

# -------------------------  request routing logic -------------------

# main routing logic

route{

	# initial sanity checks -- messages with
	# max_forwards==0, or excessively long requests
	if (!mf_process_maxfwd_header("10")) {
		sl_send_reply("483","Too Many Hops");
		exit;
	};

	# subsequent messages withing a dialog should take the
	# path determined by record-routing
	if (loose_route()) {
		# mark routing logic in request
		append_hf("P-hint: rr-enforced\r\n");
		if(is_method("BYE")) {
			# account BYE for STOP record
			setflag(1);
		}
		route(1);
	};

	# we record-route all messages -- to make sure that
	# subsequent messages will go through our proxy; that's
	# particularly good if upstream and downstream entities
	# use different transport protocol
	if (!is_method("REGISTER"))
		record_route();

	# account all calls
	if(is_method("INVITE")) {
		# set accounting on for INVITE (success or missed call)
		setflag(1);
		setflag(2);
	}

	if (!is_myself("$rd")) {
		# mark routing logic in request
		append_hf("P-hint: outbound\r\n"); 
		# if you have some interdomain connections via TLS
		#if($ru=~"@tls_domain1.net") {
		#	t_relay("tls:domain1.net");
		#	exit;
		#} else if($ru=~"@tls_domain2.net") {
		#	t_relay("tls:domain2.net");
		#	exit;
		#}
		route(1);
	};

	# if the request is for other domain use UsrLoc
	# (in case, it does not work, use the following command
	# with proper names and addresses in it)
	if (is_myself("$rd")) {

		if (is_method("REGISTER")) {

			# Uncomment this if you want to use digest authentication
			#if (!www_authorize("opensips.org", "subscriber")) {
			#	www_challenge("opensips.org", "0");
			#	exit;
			#};

			save("location");
			exit;
		};

		if (!is_myself("$rd")) {
			append_hf("P-hint: outbound alias\r\n"); 
			route(1);
		};

		# native SIP destinations are handled using our USRLOC DB
		if (!lookup("location")) {
			sl_send_reply("404", "Not Found");
			exit;
		};
		append_hf("P-hint: usrloc applied\r\n"); 
	};

	route(1);
}


route[1] {
	# send it out now; use stateful forwarding as it works reliably
	# even for UDP2TCP
	if (!t_relay()) {
		sl_reply_error();
	};
	exit;
}


```

