---
title: "Sofia SIP Stack"
date: "2019-12-10 11:27:17"
draft: false
---
Sofia is a SIP stack used by FreeSWITCH.<br /> When you see "sofia" anywhere in your configuration, think "This is SIP stuff." It takes a while to master it all, so please be patient with yourself. SIP is a crazy protocol and it will make you crazy too if you aren't careful. Read on for information on setting up SIP/Sofia in your FreeSWITCH configuration.

mod_sofia exposes the Sofia API and sets up the FreeSWITCH SIP endpoint.
<a name="jcouV"></a>
## **Endpoint**
A FreeSWITCH endpoint represents a full user agent and controls the signaling protocol and media streaming necessary to process calls. The endpoint is analogous to a physical VoIP telephone sitting on your desk. It speaks a particular protocol  such as SIP or Verto, to the outside world and interprets that for the FreeSWITCH core.
<a name="uAAkV"></a>
## **Configuration Files**
sofia.conf.xml contains the configuration settings for mod_sofia<br />See [Sofia Configuration Files](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1048969#content/view/7144453).
<a name="IhkC0"></a>
## **SIP profiles**
See [SIP profiles](https://freeswitch.org/confluence/display/FREESWITCH/Configuring+FreeSWITCH#ConfiguringFreeSWITCH-SIPProfilessip-profiles) section in [Configuring FreeSWITCH](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1048969#content/view/1048906). 
<a name="qDvUW"></a>
## **What if these commands don't work for me?**
Make sure that you are not running another SIP server at the same time as FreeSWITCH. It is not always obvious that another SIP server is running. If you type in Sofia commands such as 'sofia status profile default' and it doesn't work then you may have another SIP server running. Stop the other SIP server and restart FreeSWITCH.<br />On Linux, you may wish to try, as a superuser (often "root"):<br />netstat -lunp | less<br /># -l show listeners, -u show only UDP sockets,<br /># -n numeric output (do not translate addresses or UDP port numbers)<br /># -p show process information (PID, command). Only the superuser is allowed to see this info<br />With the less search facility (usually the keystroke "/"), look for :5060 which is the usual SIP port.<br />To narrow the focus, you can use grep. In the example configs, port 5060 is the "internal" profile. Try this:<br />netstat -lnp | grep 5060<br />See if something other than FreeSWITCH is using port 5060.
<a name="INIQt"></a>
## **Sofia Recover**
sofia recover<br />You can ask Sofia to recover calls that were up, after crashing (or other scenarios).<br />Sofia recover can also be used, if your core db uses ODBC to achieve HA / failover.<br />For FreeSWITCH HA configuration, see [Freeswitch HA](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1048969#content/view/7143926).
<a name="bbXaj"></a>
## **Flushing and rebooting registered endpoints**
You can flush a registration or reboot specific registered endpoint by issuing a flush_inbound_reg command from the console.<br />freeswitch> sofia profile <profile_name> flush_inbound_reg [<call_id>|<user@host>] [reboot]<br />If you leave out <call_id> and/or <user@host>, you will flush/reboot every registered endpoint on a profile.

- Note: For polycom phone, the command causes the phone to check its configuration from the server. If the file is different (you may add extra space at the end of file), the phone will reboot. You should not change the value of voIpProt.SIP.specialEvent.checkSync.alwaysReboot="0" to "1" in sip.cfg as that allows potential a DOS attack on the phone.<br />

You can also use the check_sync command:<br />sofia profile <profile_name> check_sync <call_id> | <user@domain>

- Note: The polycom phones do not reload <mac>-directory.xml configuration in response to either of these commands, they only reload the configuration. If you want new speed dials to take effect, you'll need to do a full reboot of the phone or enable the alwaysReboot option. (Suggestions from anyone with more detailed PolyCom knowledge would be appreciated here.)<br />
<a name="2Kzpo"></a>
## **Starting a new profile**
If you have created a new profile you need to start it from the console:<br />freeswitch> sofia profile <new_profile_name> start
<a name="M6LB2"></a>
## **Reloading profiles and gateways**
You can reload a specific SIP profile by issuing a rescan/restart command from the console<br />freeswitch> **sofia profile <profile_name> [<rescan>|<restart>] reloadxml**<br />The difference between rescan and restart is that rescan will just load new config and not stop FreeSWITCH from processing any more calls on a profile.** Some config options like IP address and (UDP) port are not reloaded with rescan.**
<a name="WZxeD"></a>
## **Deleting gateways**
You can delete a specific gateway by issuing a killgw command from the console. If you use **_all_** as gateway name, all gateways will be killed<br />freeswitch> sofia profile <profile_name> killgw <gateway_name>
<a name="oVRg9"></a>
## **Restarting gateways**
You can force a gateway to restart ( good for forcing a re-registration or similar ) by issuing a killgw command from the console followed by a profile rescan. This is safe to perform on a profile that has active calls.<br />freeswitch> sofia profile <profile_name> killgw <gateway_name><br />freeswitch> sofia profile <profile_name> rescan
<a name="zf7SU"></a>
## **Adding / Changing Existing Gateways**
It will be assumed that you have all your gateways in the /usr/local/freeswitch/conf/sip_profiles/external directory and that you have just created a new entry. You can add a new gateway to FreeSWITCH by issuing a rescan reloadxml command from the console as seen in the example below. This will load the newly created gateway and not affect any calls that are currently up.<br />freeswitch> sofia profile external rescan reloadxml

You now realize that you have screwed up the IP address in the new gateway and need to change it. So you edit your gateway file and make any changes that you want. You will then need to issue the following commands to destroy the gateway, and then have FreeSWITCH reload the changes with affecting any existing calls that are currently up.

freeswitch> sofia profile external killgw <gateway_name><br />freeswitch> sofia profile external rescan reloadxml
<a name="RjrST"></a>
## **View SIP Registrations**
You can view all the devices that have registered by running the following from the console.<br />freeswitch> sofia status profile <profile name> reg<br />freeswitch> sofia status profile default reg<br />freeswitch> sofia status profile outbound reg<br />You can also use the xmlstatus key to retrieve statuses in XML format. This is specially useful if you are using mod_xml_rpc.<br />Commands are as follows:<br />freeswitch> sofia xmlstatus profile <profile name> reg<br />freeswitch> sofia xmlstatus profile default reg<br />freeswitch> sofia xmlstatus profile outbound reg
<a name="dJMvh"></a>
## **List the status of gateways**
For the gateways that are in-service:<br />freeswitch> sofia profile <profile> gwlist up<br />For the gateways that are out-of-service:<br />freeswitch> sofia profile <profile> gwlist down<br />**Notes:**

- It should be used together with <param name="ping" value="<sec>"/>. See [Sofia_Configuration_Files](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1048969#content/view/7144453)<br />
- It can also be used to feed into mod distributor to exclude dead gateways.<br />
<a name="hg47U"></a>
## **List gateway data**
To retrieve the value of an inbound variable:<br />sofia_gateway_data <gateway_name> ivar <name><br />To retrieve the value of an outbound variable:<br />sofia_gateway_data <gateway_name> ovar <name><br />To retrieve the value of either use:<br />sofia_gateway_data <gateway_name> var <name><br />This first checks for an inbound variable, then checks for an outbound variable if there's no matching inbound.
<a name="CBZ9y"></a>
## **View User Presence Data**
Displays presence data from registered devices as seen by the server<br />Usage:<br />sofia_presence_data [list|status|rpid|user_agent] [profile/]<user>@domain<br />sofia_presence_data list */2005<br />status|rpid|user_agent|network_ip|network_port<br />Away|away|Bria 3 release 3.5.1 stamp 69738|192.168.20.150|21368<br />+OK

Its possible to retrieve only one value<br />sofia_presence_data status */2005<br />Away

You can use this value in the dialplan, e.g.<br /><extension name="12005"><br /><condition field="destination_number" expression="^(12005)$" require-nested="false"><br /><condition field="${sofia_presence_data status */2005@${domain}}" expression="^(Busy)$"><br /><action application="playback" data="ivr/8000/ivr-user_busy.wav"/><br /><action application="hangup"/><br /></condition><br /><action application="bridge" data="user/2005@${domain_name}"/><br /></condition><br /></extension>
<a name="wAbkY"></a>
## **Debugging Sofia-SIP**
The Sofia-SIP components can output various debugging information. The detail of the debugging output is determined by the debugging level. The level is usually module-specific and it can be modified by module-specific environment variable. There is also a default level for all modules, controlled by environment variable #SOFIA_DEBUG.<br />The environment variables controlling the logging and other debug output are as follows:<br />- #SOFIA_DEBUG Default debug level (0..9)<br />- #NUA_DEBUG User Agent engine (<a href="nua/index.html">nua</a>) debug level (0..9)<br />- #SOA_DEBUG SDP Offer/Answer engine (<a href="soa/index.html">soa</a>) debug level (0..9)<br />- #NEA_DEBUG Event engine (<a href="nea/index.html">nea</a>) debug level (0..9)<br />- #IPTSEC_DEBUG HTTP/SIP authentication module debug level (0..9)<br />- #NTA_DEBUG Transaction engine debug level (0..9)<br />- #TPORT_DEBUG Transport event debug level (0..9)<br />- #TPORT_LOG If set, print out all parsed SIP messages on transport layer<br />- #TPORT_DUMP Filename for dumping unparsed messages from transport<br />- #SU_DEBUG <a href="nea/index.html">su</a> module debug level (0..9)<br />The defined debug output levels are:<br />- 0 SU_DEBUG_0() - fatal errors, panic<br />- 1 SU_DEBUG_1() - critical errors, minimal progress at subsystem level<br />- 2 SU_DEBUG_2() - non-critical errors<br />- 3 SU_DEBUG_3() - warnings, progress messages<br />- 5 SU_DEBUG_5() - signaling protocol actions (incoming packets, ...)<br />- 7 SU_DEBUG_7() - media protocol actions (incoming packets, ...)<br />- 9 SU_DEBUG_9() - entering/exiting functions, very verbatim progress<br />Starting with 1.0.4, those parameters can be controlled from the console by doing<br />freeswitch> sofia loglevel <all|default|tport|iptsec|nea|nta|nth_client|nth_server|nua|soa|sresolv|stun> [0-9]<br />"all" Will change every component's loglevel<br />A log level of 0 turns off debugging, to turn them all off, you can do<br />freeswitch> sofia loglevel all 0<br />To report a bug, you can turn on debugging with more verbose<br />sofia global siptrace on<br />sofia loglevel all 9<br />sofia tracelevel alert<br />console loglevel debug<br />fsctl debug_level 10
<a name="2AVdr"></a>
### **Debugging presence and SLA**
As of Jan 14, 2011, sofia supports a new debugging command: sofia global debug. It can turn on debugging for SLA, presence, or both. Usage is:<br />sofia global debug sla<br />sofia global debug presence<br />sofia global debug none<br />The first two enable debugging SLA and presence, respectively. The third one turns off SLA and/or presence debugging.
<a name="tutmV"></a>
### **Sample Export (Linux/Unix)**
Alternatively, the levels can also be read from environment variables. The following bash commands turn on all debugging levels, and is equivalent to "sofia loglevel all 9"<br />export SOFIA_DEBUG=9<br />export NUA_DEBUG=9<br />export SOA_DEBUG=9<br />export NEA_DEBUG=9<br />export IPTSEC_DEBUG=9<br />export NTA_DEBUG=9<br />export TPORT_DEBUG=9<br />export TPORT_LOG=9<br />export TPORT_DUMP=/tmp/tport_sip.log<br />export SU_DEBUG=9<br />To turn this debugging off again, you have to exit FreeSWITCH and type unset. For example:<br />unset TPORT_LOG
<a name="uJSU2"></a>
### **Sample Set (Windows)**
The following bash commands turn on all debugging levels.<br />set SOFIA_DEBUG=9<br />set NUA_DEBUG=9<br />set SOA_DEBUG=9<br />set NEA_DEBUG=9<br />set IPTSEC_DEBUG=9<br />set NTA_DEBUG=9<br />set TPORT_DEBUG=9<br />set TPORT_LOG=9<br />set TPORT_DUMP=/tmp/tport_sip.log<br />set SU_DEBUG=9<br />To turn this debugging off again, you have to exit FreeSWITCH and type unset. For example:<br />set TPORT_LOG=<br />You can also control SIP Debug output within fs_cli, the FreeSWITCH client app.<br />freeswitch> sofia profile <profilename> siptrace on|off<br />On newer software release, you can now be able to issue siptrace for all profiles:<br />sofia global siptrace [on|off]

To have the SIP Debug details put in the /usr/local/freeswitch/log/freeswitch.log file, use<br />freeswitch> sofia tracelevel info (or any other loglevel name or number)<br />To have the SIP details put into the log file automatically on startup, add this to sofia.conf.xml:<br /><global_settings><br />...<br /><param name="tracelevel" value="DEBUG"/><br />...<br /></global_settings>


and the following to the sip profile xml file:<br /><profiles><br />...<br /><profile name="..."><br />...<br /><param name="sip-trace" value="yes"/><br />...<br /></profile><br />...<br /></profiles>

<a name="JAJyg"></a>
## **Profile Configurations**
<a name="Dl5uO"></a>
### **Track Call**
<param name="track-calls" value="true"/><br />This will make FreeSWITCH track call state using the call database.<br />This can be stored in your ODBC database if you have that configured, allowing you to share call state between multiple FreeSWITCH instances.<br />For FreeSWITCH HA configuration, See [Freeswitch HA](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1048969#content/view/7143926)
<a name="uEQX6"></a>
### **Sofia SIP Stack Watchdog**
As of October 6, 2010, the Sofia profiles now support a watchdog on the Sofia SIP stack.<br /><param name="watchdog-enabled" value="no"/><br /><param name="watchdog-step-timeout" value="30000"/><br /><param name="watchdog-event-timeout" value="30000"/><br />Sometimes, in extremely rare edge cases, the Sofia SIP stack may stop responding. These options allow you to enable and control a watchdog on the Sofia SIP stack so that if it stops responding for the specified number of milliseconds, it will cause FreeSWITCH to shut down immediately. This is useful if you run in an HA environment and need to ensure automated recovery from such a condition. Note that if your server is idle a lot, the watchdog may fire due to not receiving any SIP messages. Thus, if you expect your system to be idle, you should leave the watchdog disabled.<br />The watchdog can be toggled on and off through the FreeSWITCH CLI either on an individual profile basis or globally for all profiles. So, if you run in an HA environment with a master and slave, you should use the CLI to make sure the watchdog is only enabled on the master.<br />sofia profile internal watchdog off<br />sofia profile internal watchdog on<br />sofia global watchdog off<br />sofia global watchdog on<br />Generally, when running in an HA environment, you will have some sort of resource agent that manages which FreeSWITCH node is the master and which is the slave. You will also likely have demote and promote actions that are performed to switch states. When the demote action is called, it should execute the 'sofia global watchdog off' command. When the promote action is called, it should execute the 'sofia global watchdog on' command.

<a name="qbOWI"></a>
### **ACL**
You can restrict access by IP address for either REGISTERs or INVITEs (or both) by using the following options in the sofia profile.<br /><param name="apply-inbound-acl" value="<acl_list|cidr>"/><br /><param name="apply-register-acl" value="<acl_list|cidr>"/><br />See [ACL](https://confluence.freeswitch.org/display/FREESWITCH/ACL) for other access controls<br />See [acl.conf.xml](https://freeswitch.org/stash/projects/FS/repos/freeswitch/browse/conf/vanilla/autoload_configs/acl.conf.xml) for list configuration
<a name="Z6CDl"></a>
### **Disabling Hold**
Disable all calls on this profile from putting the call on hold:<br /><param name="disable-hold" value="true"/>

- See also: [rtp_disable_hold](https://freeswitch.org/confluence/display/FREESWITCH/__Channel+Variables#id-__ChannelVariables-rtp_disable_hold) variable<br />
<a name="3MQae"></a>
### **Using A Single Domain For All Registrations**
You can force all registrations in a particular profile to use a single domain. In other words, you can ignore the domain in the SIP message. You will need to modify several sofia profile settings.
<a name="KM0GR"></a>
#### **challenge realm**
<param name="challenge-realm" value="auto_from"/><br />Defaults to "auto_to" if not set; default config specifies "auto_from"<br />Possible Values:

- auto_from - uses the from field as the value for the SIP realm.<br />
- auto_to - uses the to field as the value for the SIP realm.<br />
- <anyvalue> - you can input any value to use for the SIP realm.<br />
<a name="Wor1p"></a>
#### **force-register-domain**
<param name="force-register-domain" value="$${domain}"/><br />This will force the profile to ignore the domain in the to or from packet and force it to the value listed here for this parameter.<br />This will store the info into the database with the user@<from domain in SIP packet>
<a name="6ec9c"></a>
#### **force-subscription-domain**
<param name="force-subscription-domain" value="$${domain}"/><br />This will force the profile to ignore the domain in the to or from packet and force it to the value listed here for this parameter.<br />This will store the info into the database with the user@<from domain in SIP packet>
<a name="ie52D"></a>
#### **force-register-db-domain**
<param name="force-register-db-domain" value="$${domain}"/><br />This will work in conjunction with force-register-domain so that the forced domain is stored in the database also.
<a name="no6IE"></a>
### **Forcing SIP profile to use a static IP address**
The default FreeSWITCH configuration will automatically determine the IP address of your local network interface. If you want to manually set the IP (for example, if you have multiple network interfaces on a single machine), you can set the following parameters in the Sofia profile:<br /><param name="rtp-ip" value="192.168.1.3"/><br /><param name="sip-ip" value="192.168.1.3"/><br />where 192.168.1.3 is the IP you want it to bind to.<br />and also in the sofia.conf.xml file:<br /><param name="auto-restart" value="false"/><br />This will prevent the profile from automatically restarting when it detects a network address change.
<a name="pWHRT"></a>
## **Syntax**
<a name="JPIl1"></a>
### **Call an extension on a Remote SIP Server**
Basic form:<br />sofia/_<profile>_/_<extension>_@_<remoteserver>_<br />Example 1:<br />sofia/$${profile}/$1@example.org<br />Example 2:<br />sofia/foo/0@sipphone.com<br />Where _<profile>_ is the name of one of the profiles defined in sofia.conf.xml. By default, there is one profile defined as name="$${domain}", where the $${domain} variable is defined in freeswitch.xml, and defaults to mydomain.com.<br />Therefore, if you have not changed these config files and are dialing an extension on a remote server, the config would be<br />sofia/_mydomain.com_/_<extension>_@_<remoteserver>_<br />To list all profiles defined, type **sofia status** on the CLI.
<a name="K5XSJ"></a>
### **Call a locally registered endpoint**
Basic form:<br />sofia/_<profile>_/_<extension>_%_<localserver>_<br />Example 1:<br />sofia/$${profile}/$1%$${domain}<br />Example 2:<br />sofia/foo/101%192.168.1.1<br />where foo is the SIP profile, 101 is the userid of the registered endpoint, and 192.168.1.1 is the IP address of FreeSWITCH.<br />If your SIP profile name is set to your domain, or the domain attribute is set in the profile (e.g., <profile name="internal" domain="$${domain}">), you can originate with the following:<br />sofia/<profile>/<extension><br />And fore-go the domain when dialing local extensions.
<a name="TL5pE"></a>
### **Multiple Registrations**
Call one extension and ring several phones<br />You must enable multiple registrations in **conf/sip_profiles/internal-ipv6.xml** and **conf/sip_profiles/internal.xml** (enabling the setting in conf/autoload_configs/switch.conf.xml had no effect).<br />Valid values for this parameter are "contact", "true", "false", "call-id".<br /><param name="multiple-registrations" value="contact"/><br />Setting this value to "contact" will remove the old registration based on sip_user, sip_host and contact field as opposed to the call_id.<br />**Ringing All Registered Extensions**<br />In your dialplan (**conf/dialplan/default.xml**) you can now use the _sofia_contact_ lookup function to return all registered sip profiles; for example in the _default.xml_ in sections _<extension name="Local_Extension">_ and _<extension name="extension-intercom">_ replace:<br /><extension name="extension-intercom"><br /><condition field="destination_number" expression="^8(10[01][0-9])$"><br /><action application="set" data="dialed_extension=$1"/><br /><action application="export" data="sip_auto_answer=true"/><br /><!-- needed for multiple-registrations=true and multi extension ringing --><br /><!-- <action application="bridge" data="user/${dialed_extension}@${domain_name}"/> --><br /><action application="bridge" data="${sofia_contact(${dialed_extension})}"/><br /></condition><br /></extension><br />With the following:<br /><action application="bridge" data="${sofia_contact(${dialed_extension})}"/><br />This will ring all devices currently registered to the dialed extension. Do note that _sofia_contact_ also works at the CLI, so you can test before you add it to your dialplan<br />See [Function sofia contact](https://wiki.freeswitch.org/wiki/Function_sofia_contact) for more information.<br />**Note (this applies to FreeSWITCH 1.0.1 and later):** you can disable multiple registrations on a per-user basis by setting the variable "sip-allow-multiple-registrations" to "false" in the directory. In this case, that single user won't be allowed to use multiple registrations.
<a name="VfAOO"></a>
### **Registration Count**
This api is used to return the count of registration of a user of a domain, or just of a domain.<br />freeswitch@internal> sofia_count_reg [user]@domain
<a name="x5I8N"></a>
### **sofia_dig**
You can use sofia_dig to check DNS A and SRV records for a given domain from the fs_cli. If there isn't a SRV record freeswitch uses A records. The use of SRV allows graceful fail overs.<br />**Usage:**<br />sofia_dig voicenetwork.ca

Preference Weight Transport Port Address<br />================================================================================<br />1 0.500 udp 5060 74.51.38.15<br />1 0.500 tcp 5060 74.51.38.15
<a name="Ejlko"></a>
### **Flushing Inbound Registrations**
From time to time, you may need to kill a registration.<br />You can kill a registration from the CLI, or anywhere that accepts API commands with a command similar to the following:<br />sofia profile <profile_name_here> flush_inbound_reg [optional_callid]
<a name="IZU6B"></a>
### **Dial out of a gateway**
Basic form:<br />sofia/gateway/<gateway>/<number_to_dial><br />Example 1:<br />sofia/gateway/asterlink/18005551212<br />gateway: is a keyword and not a "gateway" name. It has special meaning and tells the stack which credentials to use when challenged for the call.<br /><gateway> is the actual name of the gateway through which you want to send the call

Your available gateways (usually configured in conf/sip_profiles/external/*.xml) will show up in **sofia status**:<br />freeswitch#> sofia status

Name Type     Data State<br />=================================================================================================<br />default profile sip:mod_sofia@2.3.4.5:5060 RUNNING (2)<br />mygateway gateway     sip:username@1.2.3.4 NOREG<br />phonebooth.example.com alias default ALIASED<br />=================================================================================================<br />1 profile 1 alias
<a name="xCP2o"></a>
### **Modifying the To: header**
You can override the To: header by appending ^_<toheader>_.<br />Example 1:<br />sofia/foo/user%192.168.1.1^101@$${domain}

<a name="NbJyi"></a>
### **Specifying SIP Proxy With fs_path**
You can route a call through a specific SIP proxy by using the "fs_path" directive. Example:<br />sofia/foo/user@that.domain;fs_path=sip:proxy.this.domain
<a name="J3xIO"></a>
### **Safe SIP URI Formatting**

As of commit [https://freeswitch.org/stash/projects/FS/repos/freeswitch/commits/76370f4d1767bb0dcf828a3d6cde6e015b2cfa03](https://freeswitch.org/stash/projects/FS/repos/freeswitch/commits/76370f4d1767bb0dcf828a3d6cde6e015b2cfa03) the User part of the SIP URI has been "safely" encoded in the case where spaces or other special characters appear.

<a name="J31ud"></a>
## **Channel Variables**
<a name="w6ElY"></a>
### **Adding Request Headers**
You can add arbitrary headers to outbound SIP calls by prefixing the string 'sip_h_' to any channel variable, for example:<br /><action application="set" data="sip_h_X-Answer=42"/><br /><action application="bridge" data="sofia/mydomain.com/1000@example.com"/><br />Note that for BYE requests, you will need to use the prefix 'sip_bye_h_' on the channel variable.

---

While not required, you should prefix your headers with "X-" to avoid issues with interoperability with other SIP stacks.<br />All inbound SIP calls will install any X- headers into local variables.<br />This means you can easily bridge any X- header from one FreeSWITCH instance to another.<br />To access the header above on a 2nd box, use the channel variable ${sip_h_X-Answer}<br />It is important to note that the syntax ${sip_h_custom-header} can't be used to retrieve any custom header not starting with X-.<br />It is because Sofia only reads and puts into variables custom headers starting with X-.


<a name="xoRGd"></a>
### **Adding Response Headers**
There are three types of response header prefixes that can be set:

- Response header<br />sip_rh_<br />
- Provisional response header<br />sip_ph_<br />
- Bye response header<br />sip_bye_h_<br />

Each prefix will exclusively add headers for their given types of requests - there is no "global" response header prefix that will add a header to all response messages.<br />For example:<br /><action application="set" data="sip_rh_X-Reason=Destination Number Not in Footprint"/><br /><action application="set" data="sip_bye_h_X-Accounting=Some Accounting Data"/>

<a name="rWfv1"></a>
### **Adding Custom Headers**
For instance, you may need **P-Charge-Info** to append to your INVITE header, you may do as follows:<br /><action application="set"><![CDATA[sip_h_P-Charge-Info=<sip:${caller_id_number}@${domain_name}>;npi=0;noa=3]]></action><br />Then, you would see it in SIP message:<br />INVITE sip:19099099099@1.2.3.4 SIP/2.0<br />Via: SIP/2.0/UDP 5.6.7.8:5080;rport;branch=z9hG4bKyg61X9v3gUD4g<br />Max-Forwards: 69<br />From: "DJB" <sip:2132132132@5.6.7.8>;tag=XQKQ322vQF5gK<br />To: <sip:19099099099@1.2.3.4><br />Call-ID: b6c776f6-47ed-1230-0085-000f1f659e58<br />CSeq: 30776798 INVITE<br />Contact: <sip:mod_sofia@5.6.7.8:5080><br />User-Agent: FreeSWITCH-mod_sofia/1.2.0-rc2+git~20120713T162602Z~0afd7318bd+unclean~20120713T184029Z<br />Allow: INVITE, ACK, BYE, CANCEL, OPTIONS, MESSAGE, UPDATE, INFO, REGISTER, REFER, NOTIFY<br />Supported: timer, precondition, path, replaces<br />Allow-Events: talk, hold, conference, refer<br />Content-Type: application/sdp<br />Content-Disposition: session<br />Content-Length: 229<br />P-Charge-Info: <sip:2132132132@5.6.7.8>;npi=0;noa=3<br />X-FS-Support: update_display,send_info.<br />Remote-Party-ID: "DJB" <sip:2132132132@5.6.7.8>;party=calling;screen=yes;privacy=off
<a name="pfDvY"></a>
### **Strip Individual SIP Headers**
Sometimes a SIP provider will add extra header information. Most of the time they do that for their own use (tracking calls). But that extra information can cause a lot of problems. For example: I get a call from the PSTN via a DID provider (provider1). Since im not in the office the call gets bridged to my cell phone (provider2). Provider1 add's extra information to the sip packet like displayed below:<br />X-voipnow-did: 01234567890<br />X-voipnow-extension: 987654321<br />...<br />In some scenario, we bridge this call directly to provider2 the calls get dropped since provider2 doesnt accept the X-voipnow header, so we have to strip off those SIP headers.<br />To strip them off, use the application UNSET in the dialplan (the inverse of SET):<br /><action application="unset" data="sip_h_X-voipnow-did"/><br /><action application="unset" data="sip_h_X-voipnow-extension"/><br />...
<a name="FSi2r"></a>
### **Strip All custom SIP Headers**
If you wish to strip all custom headers while keeping only those defined in dialplan:<br /><action application="set" data="sip_copy_custom_headers=false"/><br /><action application="set" data="sip_h_X-myCustomHeader=${sip_h_X-myCustomHeader}"/><br />...
<a name="maWMp"></a>
### **Additional Channel variables**
Additional variables may also be set to influence the way calls are handled by sofia.<br />For example, contacts can be filtered by setting the 'sip_exclude_contact' variable. Example:<br /><anti-action application="set" data="sip_exclude_contact=${network_addr}"/><br />Or you can perform SIP Digest authorization on outgoing calls by setting **sip_auth_username** and **sip_auth_password** variables to avoid using Gateways to authenticate. Example:<br /><action application="bridge" data="[sip_auth_username=secretusername,sip_auth_password=secretpassword]sofia/external/00123456789@sip.example.com"/><br />Changing the SIP Contact user FreeSWITCH normally uses mod_sofia@[ip:port](http://ipport/) for the internal SIP contact. To change this to foo@[ip:port](http://ipport/), there is a variable, sip_contact_user:<br />{sip_contact_user=foo}sofia/my_profile/1234@192.168.0.1;transport=tcp
<a name="mI4Wp"></a>
#### **sip_renegotiate_codec_on_reinvite**
true|false
<a name="s2ZrZ"></a>
#### **sip_recovery_break_rfc**
true|false
<a name="DdD6q"></a>
## **Transcoding Issues**
G729 and G723 will not let you transcode because of licensing issues. Calls will fail if for example originating endpoint has set G729 with higher priority and receiving endpoint has G723 with highest priority. The logic is to fail the call rather than attempt to find a codec match. If you are having issues due to transcoding you may disable transcoding and both endpoints will negotiate the compatible codec rather than just fail the call.<br />disable-transcoding will take the preferred codec from the inbound leg of your call and only offer that codec on the outbound leg.<br />Add the following command <param name="disable-transcoding" value="true"/> along with <param name="inbound-late-negotiation" value="false"/> to your sofia profile

Example:<br /><configuration name="sofia.conf" description="sofia Endpoint"><br /><profiles><br /><profile name="sip"><br /><settings><br /><param name="disable-transcoding" value="true"/><br /><param name="inbound-late-negotiation" value="false"/>

<a name="ohyJw"></a>
## **Custom Events**
The following are events that can be subscribed to via [Event Socket](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1048969#content/view/1048914)

- Registration<br />

* sofia::register<br />* sofia::pre_register<br />* sofia::register_attempt<br />* sofia::register_failure<br />* sofia::unregister - explicit unregister calls<br />* sofia::expire - when a user registration expires

- Gateways<br />

* sofia::gateway_add<br />* sofia::gateway_delete<br />* sofia::gateway_state - when a gateway is detected as down or back up

- Call recovery<br />

* sofia::recovery_send<br />* sofia::recovery_recv<br />* sofia::recovery_recovered

- Other<br />

* sofia::notify_refer<br />* sofia::reinvite<br />* sofia::error
<a name="S300T"></a>
## **FAQ**
<a name="OfzFo"></a>
### **Does it use UDP or TCP?**
By default it uses both, but you can add ;transport=tcp to the Sofia URL to force it to use TCP.<br />For example:<br />sofia/profile/foo@bar.com;transport=tcp<br />Also there is a parameter in the gateway config:<br /><param name="register-transport" value="tcp"/><br />That will cause it to use the TCP transport for the registration and all subsequent SIP messages.<br />Not sure if this is needed or what it does, but the following can also be used in gateway settings:<br /><!--extra sip params to send in the contact--><br /><param name="contact-params" value="tport=tcp"/>

