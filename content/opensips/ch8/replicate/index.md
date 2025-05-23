---
title: "replicate"
date: "2020-05-28 10:01:28"
draft: false
---
```makefile
#
# demo script showing how to set-up usrloc replication
#

# ----------- global configuration parameters ------------------------

log_level=3      # logging level (cmd line: -dddddddddd)
log_stderror=yes # (cmd line: -E)

# ------------------ module loading ----------------------------------

#set module path
mpath="/usr/local/lib/opensips/modules/"

loadmodule "db_mysql.so"
loadmodule "sl.so"
loadmodule "tm.so"
loadmodule "maxfwd.so"
loadmodule "usrloc.so"
loadmodule "registrar.so"
loadmodule "auth.so"
loadmodule "auth_db.so"

# ----------------- setting module-specific parameters ---------------

# digest generation secret; use the same in backup server;
# also, make sure that the backup server has sync'ed time
modparam("auth", "secret", "alsdkhglaksdhfkloiwr")

# -------------------------  request routing logic -------------------

# main routing logic

route{

	# initial sanity checks -- messages with
	# max_forwars==0, or excessively long requests
	if (!mf_process_maxfwd_header("10")) {
		sl_send_reply("483","Too Many Hops");
		exit;
	};
	if ($ml >=  2048 ) {
		sl_send_reply("513", "Message too big");
		exit;
	};

	# if the request is for other domain use UsrLoc
	# (in case, it does not work, use the following command
	# with proper names and addresses in it)
	if (is_myself("$rd")) {

		if ($rm=="REGISTER") {

			# verify credentials
			if (!www_authorize("foo.bar", "subscriber")) {
				www_challenge("foo.bar", "0");
				exit;
			};

			# if ok, update contacts and ...
			save("location");
			# ... if this REGISTER is not a replica from our
			# peer server, replicate to the peer server
			$var(backup_ip) = "backup.foo.bar" {ip.resolve};
			if (!$si==$var(backup_ip)) {
				t_replicate("sip:backup.foo.bar:5060");
			};
			exit;
		};
		# do whatever else appropriate for your domain
		log("non-REGISTER\n");
	};
}


```

