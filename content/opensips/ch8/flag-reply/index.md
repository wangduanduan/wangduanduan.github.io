---
title: "flag_reply"
date: "2020-05-28 09:58:33"
draft: false
---
```makefile
#
# simple quick-start config script
#

# ----------- global configuration parameters ------------------------

log_level=3      # logging level (cmd line: -dddddddddd)
log_stderror=no  # (cmd line: -E)

check_via=no	# (cmd. line: -v)
dns=no           # (cmd. line: -r)
rev_dns=no      # (cmd. line: -R)
children=4

port=5060

# ------------------ module loading ----------------------------------

#set module path
mpath="/usr/local/lib/opensips/modules/"


# Uncomment this if you want to use SQL database
#loadmodule "db_mysql.so"

loadmodule "sl.so"
loadmodule "tm.so"
loadmodule "rr.so"
loadmodule "maxfwd.so"
loadmodule "usrloc.so"
loadmodule "registrar.so"
loadmodule "textops.so"
loadmodule "mi_fifo.so"

# Uncomment this if you want digest authentication
# mysql.so must be loaded !
#loadmodule "auth.so"
#loadmodule "auth_db.so"

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
#
#modparam("auth_db", "calculate_ha1", yes)
#
# If you set "calculate_ha1" parameter to yes (which true in this config), 
# uncomment also the following parameter)
#
#modparam("auth_db", "password_column", "password")

# -------------------------  request routing logic -------------------

# main routing logic

route{
	setflag(1);
	t_on_failure("1");
	t_on_reply("1");
	log(1, "message received\n");
	t_relay("udp:opensips.org:5060");
}

onreply_route[1]
{
	if (isflagset(1)) {
		log(1, "onreply: flag set\n");
	} else {
		log(1, "onreply: flag unset\n");
	};
}

failure_route[1] 
{
	if (isflagset(1)) {
		log(1, "failure: flag set\n");
	} else {
		log(1, "failure: flag unset\n");
	};
}


```

