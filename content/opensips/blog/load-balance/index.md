---
title: "Load Balancing in OpenSIPS"
date: "2021-03-09 17:52:04"
draft: false
---
[https://opensips.org/Documentation/Tutorials-LoadBalancing-1-9](https://opensips.org/Documentation/Tutorials-LoadBalancing-1-9)

### 1.  Load Balancing in **OpenSIPS**
The "load-balancing" module comes to provide traffic routing based on load. Shortly, when **OpenSIPS** routes calls to a set of destinations, it is able to keep the load status (as number of ongoing calls) of each destination and to choose to route to the less loaded destination (at that moment). **OpenSIPS** is aware of the capacity of each destination - it is pre-configured with the maximum load accepted by the destinations. To be more precise, when routing, **OpenSIPS** will consider the less loaded destination not the destination with the smallest number of ongoing calls, but the destination with the largest available slot.

Also, the "load-balancing" (LB) module is able to receive feedback from the destinations (if they are capable of). This mechanism is used for notifying **OpenSIPS** when the maximum capacity of a destination changed (like a GW with more or less E1 cards).

The "load-balancing" functionality comes to enhance the "dispatcher" one. The difference comes in having or not load information about the destinations where you are routing to:

- **Dispatcher has no load information** - it just blindly forwards calls to the destinations based on a probabilistic dispersion logic. It gets no feedback about the load of the destination (like how many calls that were sent actually were established or how many are still going).
- **Load-balancer is load driven** - LB routing logic is based primary on the load information. The LB module is using the DIALOG module in order to keep trace of the load (ongoing calls).

---

### 2.  Load Balancing - how it works
When looking at the LB implementation in **OpenSIPS**, we have 3 aspects:

#### 2.1  Destination set
A destination is defined by its address (a SIP URI) and its description as capacity.

Form the LB module perspective, the **destinations are not homogeneous** - they are not alike; and not only from capacity point of view, but also from what kind of **services/resources** they offer. For example, you may have a set of Yate/Asterisk boxes for media-related services -some of them are doing transcoding, other voicemail or conference, other simple announcement , other PSTN termination. But you may have mixed boxes - one box may do PSTN and voicemail in the same time. So each destination from the set may offer a different set of services/resources.

So, for each destination, the LB module defines the offered resources, and for each resource, it defines the **capacity / maximum load** as number of concurrent calls the destination can handle for that resource.

Example:
4 destinations/boxes in the LB set

- 1) offers 30 channels for transcoding and 32 for PSTN
- 2) offers 100 voicemail channels and 10 for transcoding
- 3) offers 50 voicemail channels and 300 for conference
- 4) offers 10 voicemail, 10 conference, 10 transcoding and 32 PSTN

| id | group_id | dst_uri | resources |
|--- | --- | --- | --- |
|  1 | 1 | sip:yate1.mycluster.net | transc=30; pstn=32 |
|  2 | 1 | sip:yate2.mycluster.net | vm=100; transc=10  |
|  3 | 1 | sip:yate3.mycluster.net | vm=50; conf=300  |
|  4 | 1 | sip:yate4.mycluster.net | vm=10;conf=10;transc=10;pstn=32 |


For runtime, the LB module provides MI commands for:

- reloading the definition of destination sets
- changing the capacity for a resource for a destination

#### 2.2  Invoking Load-balancing
Using the LB functionality is very simple - you just have to pass to the LB module what kind of resources the call requires.

The resource detection is done in the **OpenSIPS** routing script, based on whatever information is appropriated. For example, looking at the RURI (dialed number) you can see if the call must go to PSTN or if it a voicemail or conference number; also, by looking at the codecs advertised in the SDP, you can figure out if transcoding is or not also required.

```bash
if (!load_balance("1","transc;pstn")) {
    sl_send_reply("500","Service full");
    exit;
}
```


The first parameter of the function identifies the LB set to be used (see the group_id column in the above DB snapshot). Second parameter is list of the required resource for the call. A third optional parameter my be passed to instruct the LB engine on how to estimate the load - in absolute value (how many channels are used) or in relative value (how many percentages are used).

The **load_balance()** will automatically create the dialog state for the call (in order to monitor it) and will also allocate the requested resources for it (from the selected box).

The function will set as destination URI ($du) the address of the selected destination/box.

The resources will be automatically released when the call terminates.The LB module provides an MI function that allows the admin to inspect the current load over the destinations.

#### 2.3  The LB logic

The logic used by the LB module to select the destination is:

1. gets the **destination set based on the group_id** (first parameter of the _load_balance()_ function)
2. selects from the set only the **destinations that are able to provide the requested resources** (second parameter of the _load_balance()_ function)
3. for the selected destinations, it **evaluated the current load** for each requested resource
4. the winning destination is the one with **the biggest value for the minimum available load** per resources.

Example:

4 destinations/boxes in the LB set
- 1) offers 30 channels for transcoding and 32 for PSTN
- 2) offers 100 voicemail channels and 10 for transcoding
- 3) offers 50 voicemail channels and 300 for conference
- 4) offers 10 voicemail, 10 conference, 10 transcoding and 32 PSTN

when calling load_balance("1","transc;pstn") ->

- 1) only boxes (1) and (4) will be selected at as they offer both transcoding and pstn

- 2) evaluating the load  :
    -  (1) transcoding - 10 channels used; PSTN - 18 used
    -  (4) transcoding - 9 channels used; PSTN - 16 used 

   evaluating available load (capacity-load) :
    - (1) transcoding - 20 channels used; PSTN - 14 used 
    - (4) transcoding - 1 channels used; PSTN - 16 used 

3) for each box, the minimum available load (through all resources)
    (1) 14 (PSTN)
    (2) 1 (transcoding) 

4) final selected box in (1) as it has the the biggest (=14) available load for the most loaded resource.


The selection algorithm tries to avoid the intensive usage of a resource per box.

#### 2.4  Disabling and Pinging
The Load Balancer modules provides couple of functionalities to help in dealing with failures of the destinations. The actual detection of a failed destination (based on the SIP traffic) is done in the OpenSIPS routing script by looking at the codes of the replies you receive back from the destinations (see the example at the end of tutorial).<br />Once a destination is detected at failed, in script, you can mark it as disabled via the **lb_disable()** function - once marked as disabled, the destination will not be used anymore in the LB process (it will not be considered a possible destination when routing calls).<br />For a destination to be set back as enabled, there are two options:

- use the MI command [lb_status](http://www.opensips.org/html/docs/modules/1.9.x/load_balancer.html#id248919) to do it manually, from outside OpenSIPS
- based on probing - the destination must have the SIP probing/pinging enabled - once the destination starts replying with 200 OK replies to the SIP pings (see the [probing_reply_codes](http://www.opensips.org/html/docs/modules/1.9.x/load_balancer.html#id250116) option.

To enable pinging, you need first to set [probing_interval](http://www.opensips.org/html/docs/modules/1.9.x/load_balancer.html#id249996) to a non zero value - how often the pinging should be done. The pinging will be done by periodically sending a **OPTIONS** SIP request to the destination - see [probing_method](http://www.opensips.org/html/docs/modules/1.9.x/load_balancer.html#id250037) option.<br />To control which and when a destination is pinged, there is the **probe_mode** column in the **load_balancer** table - see [table definition](http://www.opensips.org/html/docs/db/db-schema-1.9.x.html#AEN3971). Possible options are:

- **0** no pinging at any time
- **1** ping only if in disabled state (used for auto re-enabling of destinations)
- **2** ping all the time - it will disable destination if fails to answer to pings and enable it back when starts answering again.

#### 2.5  RealTime Control over the Load Balancer
The Load Balancer module provides several MI functions to allow you to do runtime changes and to get realtime information from it.<br />Pushing changes at runtime:

- **lb_reload** - force reloading the entire configuration data from DB - see [more..](http://www.opensips.org/html/docs/modules/1.9.x/load_balancer.html#id292737)
- **lb_resize** - change the capacity of a resource for a destination - see [more..](http://www.opensips.org/html/docs/modules/1.9.x/load_balancer.html#id292759)
- **lb_status** - change the status of a destination (enable/disable) - see [more..](http://www.opensips.org/html/docs/modules/1.9.x/load_balancer.html#id248919)

For fetching realtime information :

- **lb_list** - list the load on all destinations (per resource) - see [more..](http://www.opensips.org/html/docs/modules/1.9.x/load_balancer.html#id292782)
- **lb_status** - see the status of a destination (enable/disable) - see [more..](http://www.opensips.org/html/docs/modules/1.9.x/load_balancer.html#id248919)

---


### 3.  Study Case: routing the media gateways
Here is the full configuration and script for performing LB between media peers.


#### 3.1  Configuration

Let's consider the following case: a cluster of media servers providing voicemail service and PSTN (in and out) service. So the boxes will be able to receive calls for Voicemail or for PSTN termination, but they will be able to send back calls only for PSTN inbound.

We also want the destinations to be disabled from script (when a failure is detected); The re-enabling of the destinations will be done based on pinging - we do pinging only when the destination is in "failed" status.

4 destinations/boxes in the LB set
- 1) offers 50 channels for voicemail and 32 for PSTN
- 2) offers 100 voicemail channels
- 3) offers 50 voicemail channels
- 4) offers 10 voicemail and 64 PSTN

This translated into the following setup:

| id | group_id | dst_uri  | resources         | prob_mode |
| ---| --- | --- | --- | --- |
|  1 | 1   | sip:yate1.mycluster.net | vm=50; pstn=32    |         1 |
|  2 | 1   | sip:yate2.mycluster.net | vm=100            |         1 |
|  3 | 1   | sip:yate3.mycluster.net | vm=50             |         1 |
|  4 | 1   | sip:yate4.mycluster.net | vm=10;pstn=64     |         1 |

#### 3.2  OpenSIPS Scripting

```bash
debug=1
memlog=1
fork=yes
children=2
log_stderror=no
log_facility=LOG_LOCAL0
disable_tcp=yes
disable_dns_blacklist = yes
auto_aliases=no

check_via=no
dns=off
rev_dns=off

listen=udp:xxx.xxx.xxx.xxx:5060 # REPLACE here with right values 

loadmodule "modules/maxfwd/maxfwd.so"
loadmodule "modules/sl/sl.so"
loadmodule "modules/db_mysql/db_mysql.so"
loadmodule "modules/tm/tm.so"
loadmodule "modules/uri/uri.so"
loadmodule "modules/rr/rr.so"
loadmodule "modules/dialog/dialog.so"
loadmodule "modules/mi_fifo/mi_fifo.so"
loadmodule "modules/mi_xmlrpc/mi_xmlrpc.so"
loadmodule "modules/signaling/signaling.so"
loadmodule "modules/textops/textops.so"
loadmodule "modules/sipmsgops/sipmsgops.so"
loadmodule "modules/load_balancer/load_balancer.so"
modparam("mi_fifo", "fifo_name", "/tmp/opensips_fifo")

modparam("dialog", "db_mode", 1)
modparam("dialog", "db_url", "mysql://opensips:opensipsrw@localhost/opensips")
modparam("rr","enable_double_rr",1)
modparam("rr","append_fromtag",1)
modparam("load_balancer", "db_url","mysql://opensips:opensipsrw@localhost/opensips")
# ping every 30 secs the failed destinations
modparam("load_balancer", "probing_interval", 30)
modparam("load_balancer", "probing_from", "sip:pinger@LB_IP:LB_PORT")
# consider positive ping reply the 404 
modparam("load_balancer", "probing_reply_codes", "404")

route{
	if (!mf_process_maxfwd_header("3")) {
		send_reply("483","looping");
		exit;
	}


	if ( has_totag() ) {
		# sequential request -> obey Route indication
		loose_route();
                t_relay();
                exit;
        }

        # handle cancel and re-transmissions
	if ( is_method("CANCEL") ) {
		if ( t_check_trans() )
			t_relay();
		exit;
	}


        # from now on we have only the initial requests
        if (!is_method("INVITE")) {
                send_reply("405","Method Not Allowed");
                exit;
        }

        # initial request
	record_route();

        # not really necessary to create the dialog from script (as the
        # LB functions will do this for us automatically), but we do it
        # if we want to pass some flags to dialog (pinging, bye, etc)
        create_dialog("B");

        # check the direction of call
        if ( lb_is_destination("$si","$sp","1") ) {
                # call comes from our cluster, so it is an PSNT inbound call
                # mark it as load on the corresponding destination
                lb_count_call("$si","$sp","1", "pstn");
                # and route is to our main sip server to send call to end user
                $du = "sip:PROXY_IP:PORXY_PORT"; # REPLACE here with right values 
                t_relay();
                exit;
        }

        # detect resources and store in an AVP
        if ( $rU=~"^VM_" ) {
                # looks like a VoiceMail call
                $avp(lb_res) = "vm";
        } else if ( $rU=~"^[0-9]+$" ) {
                # PSTN call
                $avp(lb_res) = "pstn";
        } else {
                send_reply("404","Destination not found");
                exit;
        }

        # LB function returns negative if no suitable destination (for requested resources) is found,
        # or if all destinations are full
        if ( !load_balance("1","$avp(lb_res)") ) {
             send_reply("500","Service full");
             exit;
        }

	xlog("Selected destination is: $du\n");

        # arm a failure route for be able to catch a failure event and to do 
        # failover to the next available destination
        t_on_failure("LB_failed");

        # send it out
	if (!t_relay()) {
		sl_reply_error();
	}
}

failure_route[LB_failed]
{
        # skip if call was canceled 
	if (t_was_cancelled()) {
		exit;
	}

        # was a destination failure ? (we do not want to do failover
        # if it was a call setup failure, so we look for 500 and 600
        # class replied and for local timeouts)
        if ( t_check_status("[56][0-9][0-9]") ||
        (t_check_status("408") && t_local_replied("all") ) ) {
                # this is a case for failover
                xlog("REPORT: LB destination $du failed with code $T_reply_code\n");
                # mark failed destination as disabled 
                lb_disable();
                # try to re-route to next available destination
                if ( !load_balance("1","$avp(lb_res)") ) {
                      send_reply("500","Service full");
                      exit;
                }
                xlog("REPORT: re-routing call to $du \n");
                t_relay();
        }
}
```
