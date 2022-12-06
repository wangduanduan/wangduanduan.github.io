---
title: "mod_commands"
date: "2019-12-10 11:32:38"
draft: false
---
<a name="GgcOL"></a>
# **Usage**
<a name="Six6E"></a>
## [CLI](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/1048948)
See below.
<a name="tc7Tj"></a>
## **API/Event Interfaces**

- [mod_event_socket](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/1048924)<br />
- [mod_erlang_event](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/1048926)<br />
- [mod_xml_rpc](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/1048928)<br />
<a name="lKnUF"></a>
## **Scripting Interfaces**

- [mod_perl](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/1048930)<br />
- [mod_v8](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/1048935)<br />
- [mod_python](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/1048940)<br />
- [mod_lua](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/1048944)<br />
<a name="CMLqT"></a>
## **From the** [Dialplan](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/1048645)
An [API command](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/30867723) can be called from the dialplan. Example:<br />**Invoke API Command From Dialplan**<br /><extension name="Make API call from Dialplan"><br /><condition field="destination_number" expression="^(999)$"><br /><!-- next line calls hupall, so be careful! --><br /><action application="set" data="api_result=${hupall(normal_clearing)}"/><br /></condition><br /></extension><br />Other examples:<br />**Other Dialplan API Command Examples**<br /><action application="set" data="api_result=${status()}"/><br /><action application="set" data="api_result=${version()}"/><br /><action application="set" data="api_result=${strftime()}"/><br /><action application="set" data="api_result=${expr(1+1)}"/><br />[API commands](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/30867723) with multiple arguments usually have the arguments separated by a space:<br />**Multiple Arguments**<br /><action application="set" data="api_result=${sched_api(+5 none avmd ${uuid} start)}"/>

**Dialplan Usage**<br />If you are calling an [API command](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/30867723) from the dialplan make absolutely certain that there isn't already a dialplan application that gives you the functionality you are looking for. See [mod_dptools](https://wiki.freeswitch.org/wiki/Mod_dptools) for a list of dialplan applications, they are quite extensive.
<a name="yHlgH"></a>
# **Extraction Script**
Mitch Capper wrote a Perl script to extract commands from mod_commands source code. It's tailored specifically for extracting from mod_commands but should work for most other files.<br />**Extraction Perl Script**<br />#!/usr/bin/perl<br />use strict;<br />open (fl,"src/mod/applications/mod_commands/mod_commands.c");<br />my $cont;<br />{<br />    local $/ = undef;<br />    $cont = <fl>;<br />}<br />close fl;<br />my %DEFINES;<br />my $reg_define = qr/[A-Za-z0-9_]+/;<br />my $reg_function = qr/[A-Za-z0-9_]+/;<br />my $reg_string_or_define = qr/(?:(?:$reg_define)|(?:"[^"]*"))/;

#load defines<br />while ($cont =~ /<br />                    ^\s* \#define \s+ ($reg_define) \s+ \"([^"]*)\"<br />                /mgx){<br />    warn "$1 is #defined multiple times" if ($DEFINES{$1});<br />    $DEFINES{$1} = $2;<br />}

sub resolve_str_or_define($){<br />    my ($str) = @_;<br />    if ($str =~ s/^"// && $str =~ s/"$//){ #if starts and ends with a quote strip them off and return the str<br />        return $str;<br />    }<br />    warn "Unable to resolve define: $str" if (! $DEFINES{$str});<br />    return $DEFINES{$str};<br />}<br />#parse commands<br />while ($cont =~ /<br />                    SWITCH_ADD_API \s* \( ([^,]+) #interface $1<br />                    ,\s* ($reg_string_or_define) # command $2<br />                    ,\s* ($reg_string_or_define) # command description $3<br />                    ,\s* ($reg_function) # function $4<br />                    ,\s* ($reg_string_or_define) # usage $5<br />                    \s*\);<br />                /sgx){<br />        my ($interface,$command,$descr,$function,$usage) = ($1,$2,$3,$4,$5);<br />        $command = resolve_str_or_define($command);<br />        $descr = resolve_str_or_define($descr);<br />        $usage = resolve_str_or_define($usage);<br />        warn "Found a not command interface of: $interface for command: $command" if ($interface ne "commands_api_interface");<br />        print "$command -- $descr -- $usage\n";<br />}
<a name="3n3yj"></a>
# **Core Commands**
Implemented in [http://fisheye.freeswitch.org/browse/freeswitch.git/src/mod/applications/mod_commands/mod_commands.c](http://fisheye.freeswitch.org/browse/freeswitch.git/src/mod/applications/mod_commands/mod_commands.c)<br />**Format of Returned Data**<br />Results of some status and listing commands are presented in comma delimited lists by default. Data returned from some modules may also contain commas, making it difficult to automate result processing. They may be able to be retrieved in an XML format by appending the string "as xml" to the end of the command string, or as json using "as json", or change the delimiter from comma to something else using "as delim |".
<a name="jrLiL"></a>
## **acl**
Compare an ip to an Access Control List<br />Usage: acl <ip> <list_name>
<a name="Ach8e"></a>
## **alias**
Alias: a means to save some keystrokes on commonly used commands.<br />Usage: alias add <alias> <command> | del [<alias>|*]<br />Example:<br />freeswitch> alias add reloadall reloadacl reloadxml<br />+OK<br />freeswitch> alias add unreg sofia profile internal flush_inbound_reg<br />+OK<br />You can add aliases that persist across restarts using the stickyadd argument:<br />freeswitch> alias stickyadd reloadall reloadacl reloadxml<br />+OK<br />Only really works from the [console](https://wiki.freeswitch.org/wiki/Mod_console), not [fs_cli](https://wiki.freeswitch.org/wiki/Fs_cli).
<a name="ibQDI"></a>
## **bgapi**
Execute an [API command](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/30867723) in a thread.<br />Usage: bgapi <command>[ <arg>]
<a name="LXdVE"></a>
## **complete**
Complete.<br />Usage: complete add <word>|del [<word>|*]
<a name="kWVKQ"></a>
## **cond**
Evaluate a conditional expression.<br />Usage: cond <expr> ? <true val> : <false val><br />Operators supported by <expr> are:

- == (equal to)<br />
- != (not equal to)<br />
- >  (greater than)<br />
- >= (greater than or equal to)<br />
- <  (less than)<br />
- <= (less than or equal to)<br />

**How are values compared?**

- two strings are compared as strings<br />
- two numbers are compared as numbers<br />
- a string and a number are compared as strlen(string) and numbers<br />

For example, foo == 3 evaluates to true, and foo == three to false.

 Examples (click to expand)

Example:<br />**Return true if first value is greater than the second**<br />cond 5 > 3 ? true : false<br />true<br />Example in dialplan:<br /><action application="set" data="voicemail_authorized=${cond(${sip_authorized} == true ? true : false)}"/><br />Slightly more complex example:<br /><action application="set" data="voicemail_authorized=${cond(${sip_acl_authed_by} == domains ? false : ${cond(${sip_authorized} == true ? true : false)})}"/>



**Note about syntax**<br />The whitespace around the question mark and colon are required since [FS-5945](https://freeswitch.org/jira/browse/FS-5945). Before that, they were optional. If the spaces are missing, the cond function will return -ERR.
<a name="bkIfe"></a>
## **domain_exists**
Check if a FreeSWITCH domain exists.<br />Usage: domain_exists <domain>
<a name="VF0rC"></a>
## **eval**
Eval (noop). Evaluates a string, expands variables. Those variables that are set only during a call session require the uuid of the desired session or else return "-ERR no reply".<br />Usage: eval [uuid:<uuid> ]<expression><br />Examples:<br />eval ${domain}<br />10.15.0.94<br />eval Hello, World!<br />Hello, World!<br />eval uuid:e72aff5c-6838-49a8-98fb-84c90ad840d9 ${channel-state}<br />CS_EXECUTE
<a name="9a3kp"></a>
## **expand**
Execute an [API command](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/30867723) with variable expansion.<br />Usage: expand [uuid:<uuid> ]<cmd> <args><br />Example:<br />expand originate sofia/internal/1001%${domain} 9999<br />In this example the value of ${domain} is expanded. If the domain were, for example, "192.168.1.1" then this command would be executed:<br />originate sofia/internal/1001%192.168.1.1 9999
<a name="pmafQ"></a>
## **fsctl**
Send control messages to FreeSWITCH.<br />USAGE: fsctl<br />   [<br />   api_expansion [on|off] |<br />   calibrate_clock |<br />   debug_level [level] |<br />   debug_sql |<br />   default_dtmf_duration [n] |<br />   flush_db_handles |<br />   hupall |<br />   last_sps |<br />   loglevel [level] |<br />   max_dtmf_duration [n] |<br />   max_sessions [n] |<br />   min_dtmf_duration [n] |<br />   min_idle_cpu [d] |<br />   pause [inbound|outbound] |<br />   pause_check [inbound|outbound] |<br />   ready_check |<br />   reclaim_mem |<br />   recover |<br />   resume [inbound|outbound] |<br />   save_history |<br />   send_sighup |<br />   shutdown [cancel|elegant|asap|now|restart] |<br />   shutdown_check |<br />   sps |<br />   sps_peak_reset |<br />   sql [start] |<br />   sync_clock |<br />   sync_clock_when_idle |<br />   threaded_system_exec |<br />   verbose_events [on|off]<br />   ]


**fsctl arguments**
<a name="adUdM"></a>
### **api_expansion**
Usage: fsctl api_expansion [on|off]<br />Toggles API expansion. With it off, no [API functions](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/30867723) can be expanded inside channel variables like ${show channels} This is a specific security mode that is not often used.
<a name="RmamC"></a>
### **calibrate_clock**
Usage: fsctl calibrate_clock<br />Runs an algorithm to compute how long it actually must sleep in order to sleep for a true 1ms.  It's only useful in older kernels that don't have timerfd.  In those older kernels FS auto detects that it needs to do perform that computation. This command just repeats the calibration.
<a name="JDs60"></a>
### **debug_level **
Usage: fsctl debug_level [level]<br />Set the amount of debug information that will be posted to the log. 1 is less verbose while 9 is more verbose. Additional debug messages will be posted at the ALERT loglevel.<br />0 - fatal errors, panic<br />1 - critical errors, minimal progress at subsystem level<br />2 - non-critical errors<br />3 - warnings, progress messages<br />5 - signaling protocol actions (incoming packets, ...)<br />7 - media protocol actions (incoming packets, ...)<br />9 - entering/exiting functions, very verbatim progress

<a name="V9RmR"></a>
### **debug_sql**
Usage: fsctl debug_sql<br />Toggle core SQL debugging messages on or off each time this command is invoked. Use with caution on busy systems. In order to see all messages issue the "logelevel debug" command on the fs_cli interface.
<a name="ocgHR"></a>
### **default_dtmf_duration**
Usage: fsctl default_dtmf_duration [int]<br />int = number of clock ticks<br />Example:<br />fsctl default_dtmf_duration 2000<br />This example sets the default_dtmf_duration switch parameter to 250ms. The number is specified in clock ticks (CT) where duration (milliseconds) = CT / 8 or CT = duration * 8<br />The default_dtmf_duration specifies the DTMF duration to use on originated DTMF events or on events that are received without a duration specified. This value is bounded on the lower end by min_dtmf_duration and on the upper end by max_dtmf_duration. So max_dtmf_duration >= default_dtmf_duration >= min_dtmf_duration . This value can be set persistently in switch.conf.xml<br />To check the current value:<br />fsctl default_dtmf_duration 0<br />FS recognizes a duration of 0 as a status check. Instead of setting the value to 0, it simply returns the current value.
<a name="WH7qc"></a>
### **flush_db_handles**
Usage: fsctl flush_db_handles<br />Flushes cached database handles from the core db handlers. FreeSWITCH reuses db handles whenever possible, but a heavily loaded FS system can accumulate a large number of db handles during peak periods while FS continues to allocate new db handles to service new requests in a FIFO manner. "fsctl flush_db_handles" closes db connections that are no longer needed to avoid exceeding connections to the database server.
<a name="4EMrc"></a>
### **hupall**
Usage: fsctl hupall <clearing_type> dialed_ext <extension><br />Disconnect existing calls to a destination and post a clearing cause.<br />For example, to kill an active call with normal clearing and the destination being extension 1000:<br />fsctl hupall normal_clearing dialed_ext 1000
<a name="6WgUN"></a>
### **last_sps**
Usage: fsctl last_sps<br />Query the actual sessions-per-second.<br />fsctl last_sps<br />+OK last sessions per second: 723987253<br />(Your mileage might vary.)
<a name="QYG3c"></a>
### **loglevel**
Usage: fsctl loglevel [level]<br />Filter much detail the log messages will contain when displayed on the fs_cli interface. See [mod_console](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/1048950) for legal values of "level" and further discussion.<br />The available loglevels can be specified by number or name:<br />0 - CONSOLE<br />1 - ALERT<br />2 - CRIT<br />3 - ERR<br />4 - WARNING<br />5 - NOTICE<br />6 - INFO<br />7 - DEBUG
<a name="C7roR"></a>
### **max_sessions**
Usage: fsctl max_sessions [int]<br />Set how many simultaneous call sessions FS will allow. This value can be ascertained by load testing, but is affected by processor speed and quantity, network and disk bandwidth, choice of codecs, and other factors. See switch.conf.xml for the persistent setting max-sessions.
<a name="Tmx26"></a>
### **max_dtmf_duration**
Usage: fsctl max_dtmf_duration [int]<br />Default = 192000 clock ticks<br />Example:<br />fsctl max_dtmf_duration 80000<br />This example sets the max_dtmf_duration switch parameter to 10,000ms (10 seconds). The integer is specified in clock ticks (CT) where CT / 8 = ms. The max_dtmf_duration caps the playout of a DTMF event at the specified duration. Events exceeding this duration will be truncated to this duration. You cannot configure a duration that exceeds this setting. This setting can be lowered, but cannot exceed 192000 (the default). This setting cannot be set lower than min_dtmf_duration. This setting can be set persistently in switch.conf.xml as max-dtmf-duration.<br />To query the current value:<br />fsctl max_dtmf_duration 0<br />FreeSWITCH recognizes a duration of 0 as a status check. Instead of setting the value to 0, it simply returns the current value.
<a name="Ddp6d"></a>
### **min_dtmf_duration**
Usage: fsctl min_dtmf_duration [int]<br />Default = 400 clock ticks<br />Example:<br />fsctl min_dtmf_duration 800<br />This example sets the min_dtmf_duration switch parameter to 100ms. The integer is specified in clock ticks (CT) where CT / 8 = ms. The min_dtmf_duration specifies the minimum DTMF duration to use on outgoing events. Events shorter than this will be increased in duration to match min_dtmf_duration. You cannot configure a DTMF duration on a profile that is less than this setting. You may increase this value, but cannot set it lower than 400 (the default). This value cannot exceed max_dtmf_duration. This setting can be set persistently in switch.conf.xml as min-dtmf-duration.<br />It is worth noting that many devices squelch in-band DTMF when sending [RFC 2833](https://tools.ietf.org/html/rfc2833). Devices that squelch in-band DTMF have a certain reaction time and clamping time which can sometimes reach as high as 40ms, though most can do it in less than 20ms. As the shortness of your DTMF event duration approaches this clamping threshold, the risk of your DTMF being ignored as a squelched event increases. If your call is always IP-IP the entire route, this is likely not a concern. However, when your call is sent to the PSTN, the [RFC 2833](https://tools.ietf.org/html/rfc2833) DTMF events must be encoded in the audio stream. This means that other devices down the line (possibly a PBX or IVR that you are calling) might not hear DTMF tones that are long enough to decode and so will ignore them entirely. For this reason, it is recommended that you do not send DTMF events shorter than 80ms.<br />Checking the current value:<br />fsctl min_dtmf_duration 0<br />FreeSWITCH recognizes a duration of 0 as a status check. Instead of setting the value to 0, it simply returns the current value.
<a name="kvRvQ"></a>
### **min_idle_cpu**
Usage: fsctl min_idle_cpu [int]<br />Allocates the minimum percentage of CPU idle time available to other processes to prevent FreeSWITCH from consuming all available CPU cycles.<br />Example:<br />fsctl min_idle_cpu 10<br />This allocates a minimum of 10% CPU idle time which is not available for processing by FS. Once FS reaches 90% CPU consumption it will respond with cause code 503 to additional SIP requests until its own usage drops below 90%, while reserving that last 10% for other processes on the machine.<br /> 
<a name="MEc9I"></a>
### **pause**
Usage: fsctl pause [inbound|outbound]<br />Pauses the ability to receive inbound or originate outbound calls, or both directions if the keyword is omitted. Executing fsctl pause inbound will also prevent registration requests from being processed. Executing fsctl pause outbound will result in the Critical log message "The system cannot create any outbound sessions at this time" in the FS log.<br />Use resume with the corresponding argument to restore normal operation.
<a name="PQpJ9"></a>
### **pause_check**
Usage: fsctl pause_check [inbound|outbound]<br />Returns true if the specified mode is active.<br />Examples:<br />fsctl pause_check inbound<br />true<br />indicates that inbound calls and registrations are paused. Use fsctl resume inbound to restore normal operation.<br />fsctl pause_check<br />true<br />indicates that both inbound and outbound sessions are paused. Use fsctl resume to restore normal operation.
<a name="5AHFn"></a>
### **ready_check**
Usage: fsctl ready_check<br />Returns true if the system is in the ready state, as opposed to awaiting an elegant shutdown or other not-ready state.
<a name="z9IUt"></a>
### **reclaim_mem**
Usage: fsctl reclaim_mem
<a name="rb2wd"></a>
### **recover**
Usage: fsctl recover<br />Sends an endpoint–specific recover command to each channel detected as recoverable. This replaces “sofia recover” and makes it possible to have multiple endpoints besides SIP implement recovery.
<a name="nuzfQ"></a>
### **resume**
Usage: fsctl resume [inbound|outbound]<br />Resumes normal operation after pausing inbound, outbound, or both directions of call processing by FreeSWITCH.<br />Example:<br />fsctl resume inbound<br />+OK<br />Resumes processing of inbound calls and registrations. Note that this command always returns +OK, but the same keyword must be used that corresponds to the one used in the pause command in order to take effect.
<a name="r2azK"></a>
### **save_history**
Usage: fsctl save_history<br />Write out the command history in anticipation of executing a configuration that might crash FS. This is useful when debugging a new module or script to allow other developers to see what commands were executed before the crash.
<a name="PJKN6"></a>
### **send_sighup**
Usage: fsctl send_sighup<br />Does the same thing that killing the FS process with -HUP would do without having to use the UNIX kill command. Useful in environments like Windows where there is no kill command or in cron or other scripts by using fs_cli -x "fsctl send_sighup" where the FS user process might not have privileges to use the UNIX kill command.
<a name="8cqLA"></a>
### **shutdown**
Usage: fsctl shutdown [asap|asap restart|cancel|elegant|now|restart|restart asap|restart elegant]

- cancel - discontinue a previous shutdown request.<br />
- elegant - wait for all traffic to stop, while allowing new traffic.<br />
- asap - wait for all traffic to stop, but deny new traffic.<br />
- now - shutdown FreeSWITCH immediately.<br />
- restart - restart FreeSWITCH immediately following the shutdown.<br />

When giving "elegant", "asap" or "now" it's also possible to add the restart command:
<a name="yiy2S"></a>
### **shutdown_check**
Usage: fsctl shutdown_check<br />Returns true if FS is shutting down, or shutting down and restarting.
<a name="hqgEp"></a>
### **sps**
Usage: fsctl sps [int]<br />This changes the sessions-per-second limit from the value initially set in switch.conf
<a name="gVqR6"></a>
### **sync_clock**
Usage: fsctl sync_clock<br />FreeSWITCH will not trust the system time. It gets one sample of system time when it first starts and uses the monotonic clock after that moment. You can sync it back to the current value of the system's real-time clock with fsctl sync_clock<br />Note: fsctl sync_clock immediately takes effect, which can affect the times on your CDRs. You can end up underbilling/overbilling, or even calls hungup before they originated. e.g. if FS clock is off by 1 month, then your CDRs will show calls that lasted for 1 month!<br />See fsctl sync_clock_when_idle which is much safer.
<a name="Ds2ti"></a>
### **sync_clock_when_idle**
Usage: fsctl sync_clock_when_idle<br />Synchronize the FreeSWITCH clock to the host machine's real-time clock, but wait until there are 0 channels in use. That way it doesn't affect any CDRs.
<a name="H47Fa"></a>
### **verbose_events**
Usage: fsctl verbose_events [on|off]<br />Enables verbose events. Verbose events have **every** channel variable in **every** event for a particular channel. Non-verbose events have only the pre-selected channel variables in the event headers.<br />See [switch.conf.xml](https://wiki.freeswitch.org/wiki/Switch.conf.xml) for the persistent setting of verbose-channel-events.

<a name="iVVJU"></a>
## **global_getvar**
Gets the value of a global variable. If the parameter is not provided then it gets all the global variables.<br />Usage: global_getvar [<varname>]
<a name="X3zBr"></a>
## **global_setvar**
Sets the value of a global variable.<br />Usage: global_setvar <varname>=<value><br />Example:<br />global_setvar outbound_caller_id=2024561000
<a name="Swt7n"></a>
## **group_call**
Returns the bridge string defined in a [call group](https://wiki.freeswitch.org/wiki/XML_User_Directory_Guide#Groups).<br />Usage: group_call group@domain[+F|+A|+E]<br />+F will return the group members in a serial fashion separated by | (the pipe character)<br />+A (default) will return them in a parallel fashion separated by , (comma)<br />+E will return them in a [enterprise fashion](https://wiki.freeswitch.org/wiki/Freeswitch_IVR_Originate#Enterprise_originate) separated by :_: (colon underscore colon).<br />There is no space between the domain and the optional flag. See [Groups](https://wiki.freeswitch.org/wiki/XML_User_Directory_Guide#Groups) in the XML User Directory for more information.<br />Please note: If you need to have outgoing user variables set in leg B, make sure you don't have dial-string and group-dial-string in your domain or dialed group variables list; instead set dial-string or group-dial-string in the default group of the user. This way group_call will return user/101 and user/ would set all your user variables to the leg B channel.<br />The B leg receives a new variable, dialed_group, containing the full group name.
<a name="IAe6m"></a>
## **help**
Show help for all the [API commands](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/30867723).<br />Usage: help
<a name="R5JaO"></a>
## **host_lookup**
Performs a DNS lookup on a host name.<br />Usage: host_lookup <hostname>
<a name="1BTS7"></a>
## **hupall**
Disconnect existing channels.<br />Usage: hupall <cause> [<variable> <value>]<br />All channels with <variable> set to <value> will be disconnected with <cause> code.<br />Example:<br />originate {foo=bar}sofia/internal/someone1@server.com,[sofia/internal/someone2@server.com](mailto:sofia/internal/someone2@server.com) &park<br />hupall normal_clearing foo bar<br />To hang up all calls on the switch indiscriminately:<br />hupall system_shutdown
<a name="YJ4kc"></a>
## **in_group**
Determine if a user is a member of a group.<br />Usage: in_group <user>[@<domain>] <group_name>
<a name="8NED6"></a>
## **is_lan_addr**
See if an IP is a LAN address.<br />Usage: is_lan_addr <ip>
<a name="YBGek"></a>
## **json**
JSON API<br />Usage: json {"command" : "...", "data" : "..."}<br />**Example**<br />> json {"command" : "status", "data" : ""}<br /> <br />{"command":"status","data":"","status":"success","response":{"systemStatus":"ready","uptime":{"years":0,"days":20,"hours":20,"minutes":37,"seconds":4,"milliseconds":254,"microseconds":44},"version":"1.6.9 -16-d574870 64bit","sessions":{"count":{"total":132,"active":0,"peak":2,"peak5Min":0,"limit":1000},"rate":{"current":0,"max":30,"peak":2,"peak5Min":0}},"idleCPU":{"used":0,"allowed":99.733333},"stackSizeKB":{"current":240,"max":8192}}}
<a name="APcsf"></a>
## **load**
Load external module<br />Usage: load <mod_name><br />Example:<br />load mod_v8
<a name="wWIQ9"></a>
## **md5**
Return MD5 hash for the given input data<br />Usage: md5 hash-key<br />Example:<br />md5 freeswitch-is-awesome<br />765715d4f914bf8590d1142b6f64342e
<a name="Hjaii"></a>
## **module_exists**
Check if module is loaded.<br />Usage: module_exists <module><br />Example:<br />module_exists mod_event_socket<br />true
<a name="7sBj3"></a>
## **msleep**
Sleep for x number of milliseconds<br />Usage: msleep <number of milliseconds to sleep>
<a name="J1I9S"></a>
## **nat_map**
Manage Network Address Translation mapping.<br />Usage: nat_map [status|reinit|republish] | [add|del] <port> [tcp|udp] [sticky] | [mapping] <enable|disable>

- status - Gives the NAT type, the external IP, and the currently mapped ports.<br />
- reinit - Completely re-initializes the NAT engine. Use this if you have changed routes or have changed your home router from NAT mode to UPnP mode.<br />
- republish - Causes FreeSWITCH to republish the NAT maps. This should not be necessary in normal operation.<br />
- mapping - Controls whether port mapping requests will be sent to the NAT (the command line option of -nonatmap can set it to disable on startup). This gives the ability of still using NAT for getting the public IP without opening the ports in the NAT.<br />

Note: sticky makes the mapping stay across FreeSWITCH restarts. It gives you a permanent mapping.<br />Warning: If you have multiple network interfaces with unique IP addresses defined in sip profiles using the same port, nat_map *will* get confused when it tries to map the same ports for multiple profiles. Set up a static mapping between the public address and port and the private address and port in the sip_profiles to avoid this problem.
<a name="R7khz"></a>
## **regex**
Evaluate a regex (regular expression).<br />Usage: regex <data>|<pattern>[|<subst string>][|(n|b)]<br />regex m:/<data>/<pattern>[/<subst string>][/(n|b)]<br />regex m:~<data>~<pattern>[~<subst string>][~(n|b)]<br />This command behaves differently depending upon whether or not a substitution string and optional flag is supplied:

- If a subst is not supplied, regex returns either "true" if the pattern finds a match or "false" if not.<br />
- If a subst is supplied, regex returns the subst value on a true condition.<br />
- If a subst is supplied, on a false (no pattern match) condition regex returns:<br />
   - the source string with no flag;<br />
   - with the n flag regex returns null which forces the response "-ERR no reply" from regex;<br />
   - with the b flag regex returns "false"<br />

The regex delimiter defaults to the | (pipe) character. The delimiter may be changed to ~ (tilde) or / (forward slash) by prefixing the regex with m:<br />Examples:<br />regex test1234|\d <== Returns "true"<br />regex m:/test1234/\d <== Returns "true"<br />regex m:~test1234~\d <== Returns "true"<br />regex test|\d <== Returns "false"<br />regex test1234|(\d+)|$1 <== Returns "1234"<br />regex sip:foo@bar.baz|^sip:(.*)|$1 <== Returns "foo@bar.baz"<br />regex testingonetwo|(\d+)|$1 <== Returns "testingonetwo" (no match)<br />regex m:~30~/^(10|20|40)$/~$1 <== Returns "30" (no match)<br />regex m:~30~/^(10|20|40)$/~$1~n <== Returns "-ERR no reply" (no match)<br />regex m:~30~/^(10|20|40)$/~$1~b <== Returns "false" (no match)<br />Logic in revision 14727 if the source string matches the result then the condition was false however there was a match and it is 1001.<br />regex 1001|/(^\d{4}$)/|$1

- See also [Regular_Expression](https://wiki.freeswitch.org/wiki/Regular_Expression)<br />
<a name="ew6Od"></a>
## **reload**
Reload a module.<br />Usage: reload <mod_name>
<a name="zbYVu"></a>
## **reloadacl**
Reload Access Control Lists after modifying them in autoload_configs/acl.conf.xml and as defined in extensions in the user directory conf/directory/*.xml<br />Usage: reloadacl [reloadxml]
<a name="qrA5f"></a>
## **reloadxml**
Reload conf/freeswitch.xml settings after modifying configuration files.<br />Usage: reloadxml
<a name="sWKpk"></a>
## **show**
Display various reports, **VERY** useful for troubleshooting and confirming proper configuration of FreeSWITCH. Arguments can not be abbreviated, they must be specified fully.<br />Usage: show [<br />   aliases |<br />   api |<br />   application |<br />   bridged_calls |<br />   calls [count] |<br />   channels [count|like <match string>] |<br />   chat |<br />   codec |<br />   complete |<br />   detailed_bridged_calls |<br />   detailed_calls |<br />   dialplan |<br />   endpoint |<br />   file |<br />   interface_types |<br />   interfaces |<br />   limits<br />   management |<br />   modules |<br />   nat_map |<br />registrations |<br />   say |<br />   tasks |<br />   timer |<br />   ] [as xml|as delim <delimiter>]<br />XML formatted:<br />show foo as xml<br />Change delimiter:<br />show foo as delim |

- aliases – list defined command aliases<br />
- api – list [API commands](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/30867723) exposed by loadable modules<br />
- application – list applications exposed by loadable modules, notably mod_dptools<br />
- bridged_calls – deprecated, use "show calls"<br />
- calls [count] – list details of currently active calls; the keyword "count" eliminates the details and only prints the total count of calls<br />
- channels [count|like <match string>] – list current channels; see [Channels vs Calls](https://wiki.freeswitch.org/wiki/Channels_vs_Calls)<br />
   - count – show only the count of active channels, no details<br />
   - like <match string> – filter results to include only channels that contain <match string> in uuid, channel name, cid_number, cid_name, presence data fields.<br />
- chat – list chat interfaces<br />
- codec – list codecs that are currently loaded in FreeSWITCH<br />
- complete – list command argument completion tables<br />
- detailed_bridged_calls – same as "show detailed_calls"<br />
- detailed_calls – like "show calls" but with more fields<br />
- dialplan – list dialplan interfaces<br />
- endpoint – list endpoint interfaces currently available to FS<br />
- file – list supported file format interfaces<br />
- interface_types – list all interface types with a summary count of each type of interface available<br />
- interfaces – enumerate all available interfaces by type, showing the module which exposes each interface<br />
- limits – list database limit interfaces<br />
- management – list management interfaces<br />
- module – enumerate modules and the path to each<br />
- nat_map – list Network Address Translation map<br />
- registrations – enumerate user extension registrations<br />
- say – enumerate available TTS (text-to-speech) interface modules with language supported<br />
- tasks – list FS tasks<br />
- timer – list timer modules<br />
<a name="Mc6eE"></a>
### **Tips For Showing Calls and Channels**
The best way to get an understanding of all of the show calls/channels is to use them and observe the results. To display more fields:

- show detailed_calls<br />
- show bridged_calls<br />
- show detailed_bridged_calls<br />

These three take the expand on information shown by "show calls". Note that "show detailed_calls" replaces "show distinct_channels". It provides similar, but more detailed, information. Also note that there is no "show detailed_channels" command, however using "show detailed_calls" will yield the same net result: FreeSWITCH lists detailed information about one-legged calls and bridged calls by using "show detailed_calls", which can be quite useful while configuring and troubleshooting FS.<br />**Filtering Results**<br />To filter only channels matching a specific uuid or related to a specific call, set the presence_data channel variable in the bridge or originate application to a unique string. Then you can use:<br />show channels like foo<br />to list only those channels of interest. The **like** directive filters on these fields:

- uuid<br />
- channel name<br />
- caller id name<br />
- caller id number<br />
- presence_data<br />

NOTE: **presence_data** must be set during **bridge** or **originate** and not after the channel is established.
<a name="l1oBr"></a>
## **shutdown**
Stop the FreeSWITCH program.<br />Usage: shutdown<br />This only works from the console. To shutdown FS from an API call or fs_cli, you should use "fsctl shutdown" which offers a number of options.<br />Shutdown from the console ignores arguments and exits immediately!

<a name="EWDi4"></a>
## **status**
Show current FS status. Very helpful information to provide when asking questions on the mailing list or irc channel.<br />Usage: status<br />freeswitch@internal> status<br />UP 17 years, 20 days, 10 hours, 10 minutes, 31 seconds, 571 milliseconds, 721 microseconds<br />FreeSWITCH (Version 1.5.8b git 87751f9 2013-12-13 18:13:56Z 32bit) is ready <!-- FS version --><br />53987253 session(s) since startup <!-- cumulative total number of channels created since FS started --><br />127 session(s) - peak 127, last 5min 253 <!-- current number of active channels --><br />55 session(s) per Sec out of max 60, peak 55, last 5min 253 <!-- current channels per second created, max cps set in switch.conf.xml --><br />1000 session(s) max <!-- set in switch.conf.xml --><br />min idle cpu 0.00/97.71 <!-- minimum reserved idle CPU time before refusing new calls, set in switch.conf.xml -->
<a name="mo3vv"></a>
## **strftime_tz**
Displays formatted time, converted to a specific timezone. See /usr/share/zoneinfo/zone.tab for the standard list of Linux timezones.<br />Usage: strftime_tz <timezone> [format_string]<br />Example:<br />strftime_tz US/Eastern %Y-%m-%d %T
<a name="Sy3BQ"></a>
## **unload**
Unload external module.<br />Usage: unload <mod_name>
<a name="j76jP"></a>
## **version**
Show version of the switch<br />Usage: version [short]<br />Examples:<br />freeswitch@internal> version<br />FreeSWITCH Version 1.5.8b+git~20131213T181356Z~87751f9eaf~32bit (git 87751f9 2013-12-13 18:13:56Z 32bit)<br />freeswitch@internal> version short<br />1.5.8b
<a name="bm3Ut"></a>
## **xml_locate**
Write active xml tree or specified branch to stdout.<br />Usage: xml_locate [root | <section> | <section> <tag> <tag_attr_name> <tag_attr_val>]<br />xml_locate root will return all XML being used by FreeSWITCH<br />xml_locate <section>: Will return the XML corresponding to the specified <section><br />xml_locate directory<br />xml_locate configuration<br />xml_locate dialplan<br />xml_locate phrases<br />Example:<br />xml_locate directory domain name example.com<br />xml_locate configuration configuration name ivr.conf
<a name="kHnW7"></a>
## **xml_wrap**
Wrap another [API command](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/30867723) in XML.<br />Usage: xml_wrap <command> <args>
<a name="85Rh9"></a>
# **Call Management Commands**
<a name="A1jBt"></a>
## **break**
Deprecated. See uuid_break.
<a name="LqFFr"></a>
## **create_uuid**
Creates a new UUID and returns it as a string.<br />Usage: create_uuid
<a name="h5Znj"></a>
## **originate**
Originate a new call.<br />**Usage**<br />originate <call_url> <exten>|&<application_name>(<app_args>) [<dialplan>] [<context>] [<cid_name>] [<cid_num>] [<timeout_sec>]

FreeSWITCH will originate a call to <call_url> as Leg A. If that leg supervises within 60 seconds FS will continue by searching for an extension definition in the specified dialplan for <exten> or else execute the application that follows the & along with its arguments.<br />**Originate Arguments**
<a name="H00W4"></a>
### **Arguments**

- <call_url> URL you are calling. For more info on sofia SIP URL syntax see: [FreeSwitch Endpoint Sofia](https://freeswitch.org/confluence/display/FREESWITCH/Sofia+SIP+Stack#SofiaSIPStack-Syntax)<br />
- Destination, one of:<br />
   - <exten> Destination number to search in dialplan; note that registered extensions will fail this way, use &bridge(user/xxxx) instead<br />
   - &<application_name>(<app_args>)<br />
      - "&" indicates what follows is an application name, not an exten<br />
      - (<app_args>) is optional (not all applications require parameters, e.g. park)<br />
      - The most commonly used application names include:<br />park, bridge, javascript/lua/perl, playback (remove mod_native_file).<br />
      - Note: Use single quotes to pass arguments with spaces, e.g. '&lua(test.lua arg1 arg2)'<br />
      - Note: There is no space between & and the application name<br />
- <dialplan> Defaults to 'XML' if not specified.<br />
- <context> Defaults to 'default' if not specified.<br />
- <cid_name> CallerID name to send to Leg A.<br />
- <cid_num> CallerID number to send to Leg A.<br />
- <timeout_sec> Timeout in seconds; default = 60 seconds.<br />


**Originate Variables**
<a name="Ssdiz"></a>
### **Variables**
These variables can be prepended to the dial string inside curly braces and separated by commas. Example:<br />originate {sip_auto_answer=true,return_ring_ready=false}user/1001 9198<br />Variables within braces must be separated by a comma.

- group_confirm_key<br />
- group_confirm_file<br />
- forked_dial<br />
- fail_on_single_reject<br />
- ignore_early_media - must be defined on Leg B in bridge or originate command to stop remote ringback from being heard by Leg A<br />
- return_ring_ready<br />
- originate_retries<br />
- originate_retry_sleep_ms<br />
- origination_caller_id_name<br />
- origination_caller_id_number<br />
- originate_timeout<br />
- sip_auto_answer<br />

[Description of originate's related variables](https://wiki.freeswitch.org/wiki/Channel_Variables#Originate_related_variables) 

**Originate Examples**
<a name="YxKbt"></a>
### **Examples**
You can call a locally registered sip endpoint 300 and park the call like so Note that the "example" profile used here must be the one to which 300 is registered. Also note the use of % instead of @ to indicate that it is a registered extension.<br />originate sofia/example/300%pbx.internal &park()<br />Or you could instead connect a remote sip endpoint to extension 8600<br />originate sofia/example/300@foo.com 8600<br />Or you could instead connect a remote SIP endpoint to another remote extension<br />originate sofia/example/300@foo.com &bridge(sofia/example/400@bar.com)<br />Or you could even run a Javascript application test.js<br />originate sofia/example/1000@somewhere.com &javascript(test.js)<br />To run a javascript with arguments you must surround it in single quotes.<br />originate sofia/example/1000@somewhere.com '&javascript(test.js myArg1 myArg2)'<br />Setting channel variables to the dial string<br />originate {ignore_early_media=true}sofia/mydomain.com/18005551212@1.2.3.4 15555551212<br />Setting SIP header variables to send to another FS box during originate<br />originate {sip_h_X-varA=111,sip_h_X-varB=222}sofia/mydomain.com/18005551212@1.2.3.4 15555551212<br />Note: you can set any channel variable, even custom ones. Use single quotes to enclose values with spaces, commas, etc.<br />originate {my_own_var=my_value}sofia/mydomain.com/that.ext@1.2.3.4 15555551212<br />originate {my_own_var='my value'}sofia/mydomain.com/that.ext@1.2.3.4 15555551212<br />If you need to fake the ringback to the originated endpoint try this:<br />originate {ringback=\'%(2000,4000,440.0,480.0)\'}sofia/example/300@foo.com &bridge(sofia/example/400@bar.com)<br />To specify a parameter to the Leg A call and the Leg B bridge application:<br />originate {'origination_caller_id_number=2024561000'}sofia/gateway/whitehouse.gov/2125551212 &bridge(['effective_caller_id_number=7036971379']sofia/gateway/pentagon.gov/3035554499)

If you need to make originate return immediately when the channel is in "Ring-Ready" state try this:<br />originate {return_ring_ready=true}sofia/gateway/someprovider/919246461929 &socket('127.0.0.1:8082 async full')<br />More info on [return_ring_ready](http://blog.godson.in/2010/12/use-of-returnringready-originate.html)<br />You can even set music on hold for the ringback if you want:<br />originate {ringback=\'/path/to/music.wav\'}sofia/gateway/name/number &bridge(sofia/gateway/siptoshore/12425553741)<br />You can originate a call in the background (asynchronously) and playback a message with a 60 second timeout.<br />bgapi originate {ignore_early_media=true,originate_timeout=60}sofia/gateway/name/number &playback(message)<br />You can specify the UUID of an originated call by doing the following:

- Use create_uuid to generate a UUID to use.<br />
- This will allow you to kill an originated call before it is answered by using uuid_kill.<br />
- If you specify origination_uuid it will remain the UUID for the answered call leg for the whole session.<br />

originate {origination_uuid=...}user/100@domain.name.com<br />Here's an example of originating a call to the echo conference (an external sip URL) and bridging it to a local user's phone:<br />originate sofia/internal/9996@conference.freeswitch.org &bridge(user/105@default)<br />Here's an example of originating a call to an extension in a different context than 'default' (required for the FreePBX which uses context_1, context_2, etc.):<br />originate sofia/internal/2001@foo.com 3001 xml context_3<br />You can also originate to multiple extensions as follows:<br />originate user/1001,user/1002,user/1003 &park()<br />To put an outbound call into a conference at early media, either of these will work (they are effectively the same thing)<br />originate sofia/example/300@foo.com &conference(conf_uuid-TEST_CON)<br />originate sofia/example/300@foo.com conference:conf_uuid-TEST_CON inline<br />See [mod_dptools: Inline Dialplan](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/6586667) for more detail on 'inline' Dialplans<br />An example of using loopback and inline on the A-leg can be found [in this mailing list post](http://lists.freeswitch.org/pipermail/freeswitch-users/2013-January/091769.html) 
<a name="3cfnl"></a>
## **pause**
Pause <uuid> playback of recorded media that was started with uuid_broadcast.<br />**Usage**<br />pause <uuid> <on|off><br />Turning pause "on" activates the pause function, i.e. it pauses the playback of recorded media. Turning pause "off" deactivates the pause function and resumes playback of recorded media at the same point where it was paused.<br />Note: always returns -ERR no reply when successful; returns -ERR No such channel! when uuid is invalid.
<a name="LlVEv"></a>
## **uuid_answer**
Answer a channel<br />**Usage**<br />uuid_answer <uuid><br />See Also

- [mod_dptools: answer](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/6586406)<br />
<a name="dHoil"></a>
## **uuid_audio**
Adjust the audio levels on a channel or mute (read/write) via a media bug.<br />**Usage**<br />uuid_audio <uuid> [start [read|write] [[mute|level] <level>]|stop]<br /><level> is in the range from -4 to 4, 0 being the default value.<br />Level is required for both mute|level params:<br />freeswitch@internal> uuid_audio 0d7c3b93-a5ae-4964-9e4d-902bba50bd19 start write mute <level><br />freeswitch@internal> uuid_audio 0d7c3b93-a5ae-4964-9e4d-902bba50bd19 start write level <level><br />(This command behaves funky. Requires further testing to vet all arguments. - JB)<br />See Also

- [mod_dptools: set audio level](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/6587102)<br />

<a name="QfNp6"></a>
## **uuid_break**
Break out of media being sent to a channel. For example, if an audio file is being played to a channel, issuing uuid_break will discontinue the media and the call will move on in the dialplan, script, or whatever is controlling the call.<br />Usage: uuid_break <uuid> [all]<br />If the **all** flag is used then all audio files/prompts/etc. that are queued up to be played to the channel will be stopped and removed from the queue, otherwise only the currently playing media will be stopped.
<a name="ggpz7"></a>
## **uuid_bridge**
Bridge two call legs together.<br />**Usage**<br />uuid_bridge <uuid> <other_uuid><br />uuid_bridge needs at least any one leg to be in the answered state. If, for example, one channel is parked and another channel is actively conversing on a call, executing uuid_bridge on these 2 channels will drop the existing call and bridge together the specified channels.
<a name="zihOz"></a>
## **uuid_broadcast**
Execute an arbitrary dialplan application, typically playing a media file, on a specific uuid. If a filename is specified then it is played into the channel(s). To execute an application use "app::args" syntax.<br />**Usage**<br />uuid_broadcast <uuid> <path> [aleg|bleg|both]<br />Execute an application on a chosen leg(s) with optional hangup afterwards:<br />**Usage**<br />uuid_broadcast <uuid> app[![hangup_cause]]::args [aleg|bleg|both]<br />Examples:<br />**Example**<br />uuid_broadcast 336889f2-1868-11de-81a9-3f4acc8e505e sorry.wav both<br />uuid_broadcast 336889f2-1868-11de-81a9-3f4acc8e505e say::en\snumber\spronounced\s12345 aleg<br />uuid_broadcast 336889f2-1868-11de-81a9-3f4acc8e505e say!::en\snumber\spronounced\s12345 aleg<br />uuid_broadcast 336889f2-1868-11de-81a9-3f4acc8e505e say!user_busy::en\snumber\spronounced\s12345 aleg<br />uuid_broadcast 336889f2-1868-11de-81a9-3f4acc8e505e playback!user_busy::sorry.wav aleg
<a name="ipLl4"></a>
## **uuid_buglist**
List the media bugs on channel. Output is formatted as XML.<br />**Usage**

uuid_buglist <uuid>

<a name="3XVHy"></a>
## **uuid_chat**
Send a chat message.<br />**Usage**<br />uuid_chat <uuid> <text><br />If the endpoint associated with the session <uuid> has a receive_event handler, this message gets sent to that session and is interpreted as an instant message.
<a name="3LzCz"></a>
## **uuid_debug_media**
Debug media, either audio or video.<br />**Usage**<br />uuid_debug_media <uuid> <read|write|both|vread|vwrite|vboth> <on|off><br />Use "read" or "write" for the audio direction to debug, or "both" for both directions. And prefix with v for video media.<br />uuid_debug_media emits a HUGE amount of data. If you invoke this command from fs_cli, be prepared.

**Example output**<br />R sofia/internal/1003@192.168.65.3 b= 172 192.168.65.3:17668 192.168.65.114:16072 192.168.65.114:16072 pt=0 ts=2981605109 m=0<br />W sofia/internal/1003@192.168.65.3 b= 172 192.168.65.3:17668 192.168.65.114:16072 192.168.65.114:16072 pt=0 ts=12212960 m=0<br />R sofia/internal/1003@192.168.65.3 b= 172 192.168.65.3:17668 192.168.65.114:16072 192.168.65.114:16072 pt=0 ts=2981605269 m=0<br />W sofia/internal/1003@192.168.65.3 b= 172 192.168.65.3:17668 192.168.65.114:16072 192.168.65.114:16072 pt=0 ts=12213120 m=0
<a name="LFBiM"></a>
### **Read Format**
"R %s b=%4ld %s:%u %s:%u %s:%u pt=%d ts=%u m=%d\n"<br />where the values are:

- switch_channel_get_name(switch_core_session_get_channel(session)),<br />
- (long) bytes,<br />
- my_host, switch_sockaddr_get_port(rtp_session->local_addr),<br />
- old_host, rtp_session->remote_port,<br />
- tx_host, switch_sockaddr_get_port(rtp_session->from_addr),<br />
- rtp_session->recv_msg.header.pt,<br />
- ntohl(rtp_session->recv_msg.header.ts),<br />
- rtp_session->recv_msg.header.m<br />
<a name="aWsDI"></a>
### **Write Format**
"W %s b=%4ld %s:%u %s:%u %s:%u pt=%d ts=%u m=%d\n"<br />where the values are:

- switch_channel_get_name(switch_core_session_get_channel(session)),<br />
- (long) bytes,<br />
- my_host, switch_sockaddr_get_port(rtp_session->local_addr),<br />
- old_host, rtp_session->remote_port,<br />
- tx_host, switch_sockaddr_get_port(rtp_session->from_addr),<br />
- send_msg->header.pt,<br />
- ntohl(send_msg->header.ts),<br />
- send_msg->header.m);<br />
<a name="qTpUf"></a>
## **uuid_deflect**
Deflect an answered SIP call off of FreeSWITCH by sending the REFER method<br />Usage: uuid_deflect <uuid> <sip URL><br />uuid_deflect waits for the final response from the far end to be reported. It returns the sip fragment from that response as the text in the FreeSWITCH response to uuid_deflect. If the far end reports the REFER was successful, then FreeSWITCH will issue a bye on the channel.<br />**Example**<br />uuid_deflect 0c9520c4-58e7-40c4-b7e3-819d72a98614 sip:info@example.net<br />Response:<br />Content-Type: api/response<br />Content-Length: 30<br />+OK:SIP/2.0 486 Busy Here
<a name="8ROb2"></a>
## **uuid_displace**
Displace the audio for the target <uuid> with the specified audio <file>.<br />Usage: uuid_displace <uuid> [start|stop] <file> [<limit>] [mux]<br />Arguments:

- uuid = Unique ID of this call (see 'show channels')<br />
- start|stop = Start or stop this action<br />
- file = path to an audio source (.wav file, shoutcast stream, etc...)<br />
- limit = limit number of seconds before terminating the displacement<br />
- mux = multiplex; mix the original audio together with 'file', i.e. both parties can still converse while the file is playing (if the level is not too loud)<br />

To specify the 5th argument 'mux' you must specify a limit; if no time limit is desired on playback, then specify 0.<br />**Examples**<br />cli> uuid_displace 1a152be6-2359-11dc-8f1e-4d36f239dfb5 start /sounds/test.wav 60<br />cli> uuid_displace 1a152be6-2359-11dc-8f1e-4d36f239dfb5 stop /sounds/test.wav

<a name="zAVV2"></a>
## **uuid_display**
Updates the display on a phone if the phone supports this. This works on some SIP phones right now including Polycom and Snom.<br />Usage: <uuid> name|number<br />Note the pipe character separating the Caller ID name and Caller ID number.<br />This command makes the phone re-negotiate the codec. The SIP -> RTP Packet Size should be 0.020 seconds. If it is set to 0.030 on the Cisco SPA series phones it causes a DTMF lag. When DTMF keys are pressed on the phone they are can be seen on the fs_cli 4-6 seconds late.<br />Example:<br />freeswitch@sidious> uuid_display f4053af7-a3b9-4c78-93e1-74e529658573 Fred Jones|1001<br />+OK Success

<a name="OWici"></a>
## **uuid_dual_transfer**
Transfer each leg of a call to different destinations.<br />Usage: <uuid> <A-dest-exten>[/<A-dialplan>][/<A-context>] <B-dest-exten>[/<B-dialplan>][/<B-context>]
<a name="6x5ls"></a>
## **uuid_dump**
Dumps all variable values for a session.<br />Usage: uuid_dump <uuid> [format]<br />Format options: txt (default, may be omitted), XML, JSON, plain
<a name="VP4p4"></a>
## **uuid_early_ok**
Stops the process of ignoring early media, i.e. if ignore_early_media=true, this stops ignoring early media coming from Leg B and responds normally.<br />Usage: uuid_early_ok <uuid>
<a name="votXC"></a>
## **uuid_exists**
Checks whether a given UUID exists.<br />Usage: uuid_exists <uuid><br />Returns true or false.
<a name="SJPzP"></a>
## **uuid_flush_dtmf**
Flush queued DTMF digits<br />Usage: uuid_flush_dtmf <uuid>
<a name="WCXrL"></a>
## **uuid_fileman**
Manage the audio being played into a channel from a sound file<br />Usage: uuid_fileman <uuid> <cmd:val><br />Commands are:

- speed:<+[step]>|<-[step]><br />
- volume:<+[step]>|<-[step]><br />
- pause (toggle)<br />
- stop<br />
- truncate<br />
- restart<br />
- seek:<+[milliseconds]>|<-[milliseconds]> (1000ms = 1 second, 10000ms = 10 seconds.)<br />

Example to seek forward 30 seconds:<br />uuid_fileman 0171ded1-2c31-445a-bb19-c74c659b7d08 seek:+3000<br />(Or use the current channel via ${uuid}, e.g. in a bind_digit_action)<br />The 'pause' argument is a toggle: the first time it is invoked it will pause playback, the second time it will resume playback.
<a name="20m1M"></a>
## **uuid_getvar**
Get a variable from a channel.<br />Usage: uuid_getvar <uuid> <varname>
<a name="h2ZhC"></a>
## **uuid_hold**
Place a channel on hold.<br />Usage:<br />uuid_hold <uuid> place a call on hold<br />uuid_hold off <uuid> switch off on hold<br />uuid_hold toggle <uuid> toggles call-state based on current call-state
<a name="T3CBt"></a>
## **uuid_kill**
Reset a specific <uuid> channel.<br />Usage: uuid_kill <uuid> [cause]<br />If no cause code is specified, NORMAL_CLEARING will be used.
<a name="un4pe"></a>
## **uuid_limit**
Apply or change limit(s) on a specified uuid.<br />Usage: uuid_limit <uuid> <backend> <realm> <resource> [<max>[/interval]] [number [dialplan [context]]]<br />See also [mod_dptools: Limit](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/3375201)
<a name="WbYcv"></a>
## **uuid_media**
Reinvite FreeSWITCH out of the media path:<br />Usage: uuid_media [off] <uuid><br />Reinvite FreeSWITCH back in:<br />Usage: uuid_media <uuid>
<a name="nuIMO"></a>
## **uuid_media_reneg**
Tell a channel to send a re-invite with optional list of new codecs to be renegotiated.<br />Usage: uuid_media_reneg <uuid> <=><codec string><br />Example: Adding =PCMU makes the offered codec string absolute.
<a name="JWdle"></a>
## **uuid_park**
Park call<br />Usage: uuid_park <uuid><br />The specified channel will be parked and the other leg of the call will be disconnected.
<a name="KlOu6"></a>
## **uuid_pre_answer**
Pre–answer a channel.<br />Usage: uuid_preanswer <uuid><br />See Also: [Misc._Dialplan_Tools_pre_answer](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/6586998)
<a name="HQhFm"></a>
## **uuid_preprocess**
Pre-process Channel<br />Usage: uuid_preprocess <uuid>
<a name="XJxRF"></a>
## **uuid_recv_dtmf**

Usage: uuid_recv_dtmf <uuid> <dtmf_data>

<a name="byXmZ"></a>
## **uuid_send_dtmf**
Send DTMF digits to <uuid><br />Usage: uuid_send_dtmf <uuid> <dtmf digits>[@<tone_duration>]<br />Use the character w for a .5 second delay and the character W for a 1 second delay.<br />Default tone duration is 2000ms .
<a name="OqiVp"></a>
## **uuid_send_info**
Send info to the endpoint<br />Usage: uuid_send_info <uuid>
<a name="yuNg8"></a>
## **uuid_session_heartbeat**
Usage: uuid_session_heartbeat <uuid> [sched] [0|<seconds>]
<a name="8pOVj"></a>
## **uuid_setvar**
Set a variable on a channel. If value is omitted, the variable is unset.<br />Usage: uuid_setvar <uuid> <varname> [value]
<a name="HPDBM"></a>
## **uuid_setvar_multi**
Set multiple vars on a channel.<br />Usage: uuid_setvar_multi <uuid> <varname>=<value>[;<varname>=<value>[;...]]
<a name="ib2F7"></a>
## **uuid_simplify**
This command directs FreeSWITCH to remove itself from the SIP signaling path if it can safely do so.<br />Usage: uuid_simplify <uuid><br />Execute this [API command](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/30867723) to instruct FreeSWITCH™ to inspect the Leg A and Leg B network addresses. If they are both hosted by the same switch as a result of a transfer or forwarding loop across a number of FreeSWITCH™ systems the one executing this command will remove itself from the SIP and media path and restore the endpoints to their local FreeSWITCH™ to shorten the network path. This is particularly useful in large distributed FreeSWITCH™ installations.<br />For example, suppose a call arrives at a FreeSWITCH™ box in Los Angeles, is answered, then forwarded to a FreeSWITCH™ box in London, answered there and then forwarded back to Los Angeles. The London switch could execute uuid_simplify to tell its local switch to examine both legs of the call to determine that they could be hosted by the Los Angeles switch since both legs are local to it. Alternatively, setting sip_auto_simplify to true either globally in vars.xml or as part of a dailplan extension would tell FS to perform this check for each call when both legs supervise. 
<a name="Qbktr"></a>
## **uuid_transfer**
Transfers an existing call to a specific extension within a <dialplan> and <context>. Dialplan may be "xml" or "directory".<br />**Usage**<br />uuid_transfer <uuid> [-bleg|-both] <dest-exten> [<dialplan>] [<context>]

The optional first argument will allow you to transfer both parties (-both) or only the party to whom <uuid> is talking.(-bleg). Beware that -bleg actually means "the other leg", so when it is executed on the actual B leg uuid it will transfer the actual A leg that originated the call and disconnect the actual B leg.<br />NOTE: if the call has been bridged, and you want to transfer either side of the call, then you will need to use <action application="set" data="hangup_after_bridge=false"/> (or the API equivalent). If it's not set, transfer doesn't really work as you'd expect, and leaves calls in limbo.<br />And more examples see [Inline Dialplan](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/13173434)
<a name="3xbtj"></a>
## **uuid_phone_event**
Send hold indication upstream:<br />**Usage**<br />uuid_phone_event <uuid> hold|talk

<a name="i1Zhs"></a>
# **Record/Playback Commands**
<a name="axTpr"></a>
## **uuid_record**
Record the audio associated with the given UUID into a file. The start command causes FreeSWITCH to start mixing all call legs together and saves the result as a file in the format that the file's extension dictates. (if available) The stop command will stop the recording and close the file. If media setup hasn't yet happened, the file will contain silent audio until media is available. Audio will be recorded for calls that are parked. The recording will continue through the bridged call. If the call is set to return to park after the bridge, the bug will remain on the call, but no audio is recorded until the call is bridged again. (TODO: What if media doesn't flow through FreeSWITCH? Will it re-INVITE first? Or do we just not get the audio in that case?)<br />Usage:<br />uuid_record <uuid> [start|stop|mask|unmask] <path> [<limit>]<br />Where limit is the max number of seconds to record.<br />If the path is not specified on start it will default to the channel variable "sound_prefix" or FreeSWITCH base_dir when the "sound_prefix" is empty.<br />You may also specify "all" for path when stop is used to remove all for this uuid<br />"stop" command must be followed by <path> option.<br />"mask" will mask with silence part of the recording beginning when the mask argument is executed by this command. see [http://jira.freeswitch.org/browse/FS-5269](http://jira.freeswitch.org/browse/FS-5269).<br />"unmask" will stop the masking and continue recording live audio normally.<br />[See record's related variables](https://freeswitch.org/confluence/display/FREESWITCH/Channel+Variables#ChannelVariables-CallRecordingRelated)<br />you will also want to see [mod_dptools: record_session](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/6587110)
<a name="I5S9w"></a>
# **Limit Commands**
More information is available at [Limit commands](https://wiki.freeswitch.org/wiki/Limit#API)
<a name="TUpGZ"></a>
## **limit_reset**
Reset a limit backend.
<a name="oqJLp"></a>
## **limit_status**
Retrieve status from a limit backend.
<a name="ucYSM"></a>
## **limit_usage**
Retrieve usage for a given resource.
<a name="xlEuR"></a>
## **uuid_limit_release**
Manually decrease a resource usage by one.
<a name="IGIqu"></a>
## **limit_interval_reset**
Reset the interval counter to zero prior to the start of the next interval.
<a name="Qspeg"></a>
# **Miscellaneous Commands**
<a name="7MGF2"></a>
## **bg_system**
Execute a system command in the background.<br />Usage: bg_system <command>
<a name="SM8R4"></a>
## **echo**
Echo input back to the console<br />Usage: echo <text to echo><br />Example:<br />echo This text will appear<br />This text will appear
<a name="jqjdq"></a>
## **file_exists**
Tests whether filename exists.<br />file_exists filename<br />Examples:<br />freeswitch> file_exists /tmp/real_file<br />true

freeswitch> file_exists /tmp/missing_file<br />false<br />Example dialplan usage:<br />**file_exists example**<br /><extension name="play-news-announcements"><br /><condition expression="${file_exists(${sounds_dir}/news.wav)}" expression="true"/><br /><action application="playback" data="${sounds_dir}/news.wav"/><br /><anti-action application="playback" data="${soufnds_dir}/no-news-is-good-news.wav"/><br /></condition><br /></extension>

file_exists tests whether FreeSWITCH can see the file, but the file may still be unreadable because of restrictive permissions.

<a name="fQwbI"></a>
## **find_user_xml**
Checks to see if a user exists. Matches user tags found in the directory, similar to [user_exists](https://wiki.freeswitch.org/index.php?title=User_exists&action=edit&redlink=1), but returns an XML representation of the user as defined in the directory (like the one shown in [user_exists](https://wiki.freeswitch.org/wiki/Mod_commands#user_exists)).<br />Usage: find_user_xml <key> <user> <domain><br /><key> references a key specified in a directory's user tag<br /><user> represents the value of the key<br /><domain> is the domain to which the user is assigned.
<a name="hswl1"></a>
## **list_users**
Lists Users configured in Directory<br />Usage:<br />list_users [group <group>] [domain <domain>] [user <user>] [context <context>]<br />Examples:<br />freeswitch@localhost> list_users group default

userid|context|domain|group|contact|callgroup|effective_caller_id_name|effective_caller_id_number<br />2000|default|192.168.20.73|default|sofia/internal/sip:2000@192.168.20.219:5060|techsupport|B#-Test 2000|2000<br />2001|default|192.168.20.73|default|sofia/internal/sip:2001@192.168.20.150:63412;rinstance=8e2c8b86809acf2a|techsupport|Test 2001|2001<br />2002|default|192.168.20.73|default|error/user_not_registered|techsupport|Test 2002|2002<br />2003|default|192.168.20.73|default|sofia/internal/sip:2003@192.168.20.149:5060|techsupport|Test 2003|2003<br />2004|default|192.168.20.73|default|error/user_not_registered|techsupport|Test 2004|2004

+OK<br />Search filters can be combined:<br />freeswitch@localhost> list_users group default user 2004

userid|context|domain|group|contact|callgroup|effective_caller_id_name|effective_caller_id_number<br />2004|default|192.168.20.73|default|error/user_not_registered|techsupport|Test 2004|2004

+OK
<a name="Xzeei"></a>
## **sched_api**
Schedule an [API call](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/30867723) in the future.<br />Usage:<br />sched_api [+@]<time> <group_name> <command_string>[&]<br /><time> is the UNIX timestamp at which the command should be executed. If it is prefixed by +, <time> specifies the number of seconds to wait before executing the command. If prefixed by @, it will execute the command periodically every <time> seconds; for the first instance it will be executed after <time> seconds.<br /><group_name> will be the value of "Task-Group" in generated events. "none" is the proper value for no group. If set to UUID of channel (example: ${uuid}), task will automatically be unscheduled when channel hangs up.<br /><command_string> is the command to execute at the scheduled time.<br />A scheduled task or group of tasks can be revoked with sched_del or unsched_api.<br />You could append the "&" symbol to the end of the line to executed this command in its own thread.<br />Example:<br />sched_api +1800 none originate sofia/internal/1000%${sip_profile} &echo()<br />sched_api @600 check_sched log Periodic task is running...<br />sched_api +10 ${uuid} chat verto|fs@mydomain.com|1000@mydomain.com|Hello World
<a name="QIZZS"></a>
## **sched_broadcast**
Play a <path> file to a specific <uuid> call in the future.<br />Usage:<br />sched_broadcast [[+]<time>|@time] <uuid> <path> [aleg|bleg|both]<br />Schedule execution of an application on a chosen leg(s) with optional hangup:<br />sched_broadcast [+]<time> <uuid> app[![hangup_cause]]::args [aleg|bleg|both]<br /><time> is the UNIX timestamp at which the command should be executed. If it is prefixed by +, <time> specifies the number of seconds to wait before executing the command. If prefixed by @, it will execute the command periodically every <time> seconds; for the first instance it will be executed after <time> seconds.<br />Examples:<br />sched_broadcast +60 336889f2-1868-11de-81a9-3f4acc8e505e commercial.wav both<br />sched_broadcast +60 336889f2-1868-11de-81a9-3f4acc8e505e say::en\snumber\spronounced\s12345 aleg
<a name="p4tb3"></a>
## **sched_del**
Removes a prior scheduled group or task ID<br />Usage:<br />sched_del <group_name|task_id><br />The one argument can either be a group of prior scheduled tasks or the returned task-id from sched_api.<br />sched_transfer, sched_hangup and sched_broadcast commands add new tasks with group names equal to the channel UUID. Thus, sched_del with the channel UUID as the argument will remove all previously scheduled hangups, transfers and broadcasts for this channel.<br />Examples:<br />sched_del my_group<br />sched_del 2
<a name="K2vU1"></a>
## **sched_hangup**
Schedule a running call to hangup.<br />Usage:<br />sched_hangup [+]<time> <uuid> [<cause>]<br />sched_hangup +0 is the same as uuid_kill
<a name="uVlQb"></a>
## **sched_transfer**
Schedule a transfer for a running call.<br />Usage:<br />sched_transfer [+]<time> <uuid> <target extension> [<dialplan>] [<context>]
<a name="g0fzu"></a>
## **stun**
Executes a STUN lookup.<br />Usage:<br />stun <stunserver>[:port]<br />Example:<br />stun stun.freeswitch.org
<a name="MFeuK"></a>
## **system**
Execute a system command.<br />Usage:<br />system <command><br />The <command> is passed to the system shell, where it may be expanded or interpreted in ways you don't expect. This can lead to security bugs if you're not careful. For example, the following command is dangerous:<br /><action application="system" data="log_caller_name ${caller_id_name}" /><br />If a malicious remote caller somehow sets his caller ID name to "; rm -rf /" you would unintentionally be executing this shell command:<br />log_caller_name; rm -rf /<br />This would be a Bad Thing.
<a name="oIPyz"></a>
## **time_test**
Runs a test to see how bad timer jitter is. It runs the test <count> times if specified, otherwise it uses the default count of 10, and tries to sleep for mss microseconds. It returns the actual timer duration along with an average.<br />Usage:<br />time_test <mss> [count]<br />Example:<br />time_test 100 5

test 1 sleep 100 99<br />test 2 sleep 100 97<br />test 3 sleep 100 96<br />test 4 sleep 100 97<br />test 5 sleep 100 102<br />avg 98
<a name="0ZQBH"></a>
## **timer_test**
Runs a test to see how bad timer jitter is. Unlike time_test, this uses the actual FreeSWITCH timer infrastructure to do the timer test and exercises the timers used for call processing.<br />Usage:<br />timer_test <10|20|40|60|120> [<1..200>] [<timer_name>]<br />The first argument is the timer interval.<br />The second is the number of test iterations.<br />The third is the timer name; "show timers" will give you a list.<br />Example:<br />timer_test 20 3

Avg: 16.408ms Total Time: 49.269ms

2010-01-29 12:01:15.504280 [CONSOLE] mod_commands.c:310 Timer Test: 1 sleep 20 9254<br />2010-01-29 12:01:15.524351 [CONSOLE] mod_commands.c:310 Timer Test: 2 sleep 20 20042<br />2010-01-29 12:01:15.544336 [CONSOLE] mod_commands.c:310 Timer Test: 3 sleep 20 19928
<a name="RsW29"></a>
## **tone_detect**
Start Tone Detection on a channel.<br />Usage:<br />tone_detect <uuid> <key> <tone_spec> [<flags> <timeout> <app> <args>] <hits><br /><uuid> is required when this is executed as an api call; as a dialplan app the uuid is implicit as part of the channel variables<br /><key> is an arbitrary name that identifies this tone_detect instance; required<br /><tone_spec> frequencies to detect; required<br /><flags> 'r' or 'w' to specify which direction to monitor<br /><timeout> duration during which to detect tones;<br />0 = detect forever<br />+time = number of milliseconds after tone_detect is executed<br />time = absolute time to stop in seconds since The Epoch (1 January, 1970)<br /><app> FS application to execute when tone_detect is triggered; if app is omitted, only an event will be returned<br /><args> arguments to application enclosed in single quotes<br /><hits> the number of times tone_detect should be triggered before executing the specified app<br />Once tone_detect returns a result, it will not trigger again until reset. Reset tone_detect by calling tone_detect <key> with no additional arguments to reactivate the previously specified tone_detect declaration.<br />See also [http://wiki.freeswitch.org/wiki/Misc._Dialplan_Tools_tone_detect](http://wiki.freeswitch.org/wiki/Misc._Dialplan_Tools_tone_detect)
<a name="B06ai"></a>
## **unsched_api**
Unschedule a previously scheduled [API command](https://freeswitch.org/confluence/plugins/servlet/mobile?contentId=1966741#content/view/30867723).<br />Usage:<br />unsched_api <task_id>
<a name="36eqA"></a>
## **url_decode**
Usage:<br />url_decode <string>
<a name="R2Tgq"></a>
## **url_encode**
Url encode a string.<br />Usage:<br />url_encode <string>
<a name="hEbih"></a>
## **user_data**
Retrieves user information (parameters or variables) as defined in the FreeSWITCH user directory.<br />Usage:<br />user_data <user>@<domain> <attr|var|param> <name><br /><user> is the user's id<br /><domain> is the user's domain<br /><attr|var|param> specifies whether the requested data is contained in the "variables" or "parameters" section of the user's record<br /><name> is the name (key) of the variable to retrieve<br />Examples:<br />user_data 1000@192.168.1.101 param password<br />will return a result of 1234, and<br />user_data 1000@192.168.1.101 var accountcode<br />will return a result of 1000 from the example user shown in [user_exists](https://wiki.freeswitch.org/wiki/Mod_commands#user_exists), and<br />user_data 1000@192.168.1.101 attr id<br />will return the user's actual alphanumeric ID (i.e. "john") when number-alias="1000" was set as an attribute for that user.
<a name="EXFds"></a>
## **user_exists**
Checks to see if a user exists. Matches user tags found in the directory and returns either true/false:<br />Usage:<br />user_exists <key> <user> <domain><br /><key> references a key specified in a directory's user tag<br /><user> represents the value of the key<br /><domain> is the domain to which the user belongs<br />Example:<br />user_exists id 1000 192.168.1.101<br />will return true where there exists in the directory a user with a key called id whose value equals 1000:<br />**User Directory Entry**<br /><user id="1000" randomvar="45"><br /><params><br /><param name="password" value="1234"/><br /><param name="vm-password" value="1000"/><br /></params><br /><variables><br /><variable name="accountcode" value="1000"/><br /><variable name="user_context" value="default"/><br /><variable name="effective_caller_id_name" value="Extension 1000"/><br /><variable name="effective_caller_id_number" value="1000"/><br /></variables><br /></user><br />In the above example, we also could have tested for randomvar:<br />user_exists randomvar 45 192.168.1.101<br />And we would have received the same true result, but:<br />user_exists accountcode 1000 192.168.1.101<br />or<br />user_exists vm-password 1000 192.168.1.101<br />Would have returned false.

