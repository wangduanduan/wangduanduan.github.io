---
title: "httpd"
date: "2020-05-28 09:59:25"
draft: false
---
```makefile
#
# $Id$
#
# this example shows use of opensips's provisioning interface
#

# ------------------ module loading ----------------------------------

#set module path
mpath="/usr/local/lib64/opensips/modules/"

loadmodule "db_mysql.so"
loadmodule "httpd.so"
  modparam("httpd", "port", 8888)
loadmodule "mi_http.so"
loadmodule "pi_http.so"
  modparam("pi_http", "framework", "/usr/local/src/opensips/examples/pi_framework.xml")
loadmodule "mi_xmlrpc_ng.so"

# -------------------------  request routing logic -------------------

# main routing logic

route{
	exit;
}


```

