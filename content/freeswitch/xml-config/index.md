---
title: "XML Switch Configuration"
date: "2019-12-10 11:30:38"
draft: false
---
The FreeSWITCH core configuration is contained in [autoload_configs/switch.conf.xml](http://git.freeswitch.org/git/freeswitch/tree/conf/vanilla/autoload_configs/switch.conf.xml)

<a name="r3E59"></a>
## **Default key bindings**
Function keys can be mapped to API commands using the following configuration:<br /><cli-keybindings><br /><key name="[1-12]" value="[api command]"/><br /></cli-keybindings><br />The default keybindings are;<br />F1 = help<br />F2 = status<br />F3 = show channels<br />F4 = show calls<br />F5 = sofia status<br />F6 = reloadxml<br />F7 = console loglevel 0<br />F8 = console loglevel 7<br />F9 = sofia status profile internal<br />F10 = sofia profile internal siptrace on<br />F11 = sofia profile internal siptrace off<br />F12 = version<br />Beware that the option loglevel is actually setting the minimum hard_log_Level in the application. What this means is if you set this to something other than DEBUG no matter what log level you set the console to one you start up you will not be able to get any log messages below the level you set. Also be careful of mis-typing a log level, if the log level is not correct it will default to a hard_log_level of 0. This means that virtually no log messages will show up anywhere.
<a name="JYmHz"></a>
## **Core parameters**
<a name="oH2mI"></a>
### **core-db-dsn**
Allows to use ODBC database instead of sqlite3 for freeswitch core.<br />Syntax<br />dsn:user:pass
<a name="tzZuV"></a>
### 
**max-db-handles**<br />Maximum number of simultaneous DB handles open
<a name="B5yQd"></a>
### **db-handle-timeout**
Maximum number of seconds to wait for a new DB handle before failing
<a name="ptDC6"></a>
### **disable-monotonic-timing**
(bool) disables monotonic timer/clock support if it is broken on your system.
<a name="poPRq"></a>
### **enable-use-system-time**
Enables FreeSWITCH to use system time.
<a name="HuusN"></a>
### **initial-event-threads**
Number of event dispatch threads to allocate in the core. Default is 1.<br />If you see the WARNING "Create additional event dispatch thread" on a heavily loaded server, you could increase the number of threads to prevent the system from falling behind.
<a name="7h1Vg"></a>
### **loglevel**
amount of detail to show in log
<a name="wZVbt"></a>
### **max-sessions**
limits the total number of concurrent channels on your FreeSWITCH™ system.
<a name="IIPBF"></a>
### **sessions-per-second**
throttling mechanism, the switch will only create this many channels at most, per second.
<a name="hYI3g"></a>
### **rtp-start-port**
RTP port range begin
<a name="kiczE"></a>
### **rtp-end-port**
RTP port range end
<a name="fKgc8"></a>
## **Variables**
Variables are default channel variables set on each channel automatically.<br /> 
<a name="0n4Zy"></a>
## **Example config**
<configuration name="switch.conf" description="Modules"><br /><settings><br /><!--Most channels to allow at once --><br /><param name="max-sessions" value="1000"/><br /><param name="sessions-per-second" value="30"/><br /><param name="loglevel" value="debug"/>

<!-- Maximum number of simultaneous DB handles open --><br /><param name="max-db-handles" value="50"/><br /><!-- Maximum number of seconds to wait for a new DB handle before failing --><br /><param name="db-handle-timeout" value="10"/>

</settings><br /><!--Any variables defined here will be available in every channel, in the dialplan etc --><br /><variables><br /><variable name="uk-ring" value="%(400,200,400,450);%(400,2200,400,450)"/><br /><variable name="us-ring" value="%(2000, 4000, 440.0, 480.0)"/><br /><variable name="bong-ring" value="v=4000;>=0;+=2;#(60,0);v=2000;%(940,0,350,440)"/><br /></variables><br /></configuration>

