---
title: "loggin"
date: "2020-05-28 09:59:45"
draft: false
---
```makefile
#
# logging example
#

# ------------------ module loading ----------------------------------

port=5060
log_stderror=yes
log_level=3


# -------------------------  request routing logic -------------------

# main routing logic

route{
	# for testing purposes, simply okay all REGISTERs
	if (is_method("REGISTER")) {
		log(1, "REGISTER received\n");
	} else {
		log(1, "non-REGISTER received\n");
	};
	if ($ru=~"sip:.*[@:]siphub.net") {
		xlog("request for siphub.net received\n");
	} else {
		xlog("request for other domain [$rd] received\n");
	};
}

```

