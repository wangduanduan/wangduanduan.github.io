---
title: "redirect"
date: "2020-05-28 10:01:07"
draft: false
---
```makefile
#
# $Id$
#
# this example shows use of ser as stateless redirect server
#

# ------------------ module loading ----------------------------------

#set module path
mpath="/usr/local/lib/opensips/modules/"

loadmodule "sl.so"


# -------------------------  request routing logic -------------------

# main routing logic

route{
	# for testing purposes, simply okay all REGISTERs
	if ($rm=="REGISTER") {
		log("REGISTER");
		sl_send_reply("200", "ok");
		return;
	};
	# rewrite current URI, which is always part of destination ser
	rewriteuri("sip:parallel@siphub.net:9");
	# append one more URI to the destination ser
	append_branch("sip:redirect@siphub.net:9");
	# redirect now
	sl_send_reply("300", "Redirect");
}


```

