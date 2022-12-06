---
title: "fs 命令行"
date: "2019-12-10 11:19:39"
draft: false
---
<a name="brXiD"></a>
# 运行fs
<a name="f50K3"></a>
## 前台运行

```makefile
freeswitch
```

<a name="y57Vs"></a>
## 后台运行

```makefile
freeswich -nc
```

<a name="TcGty"></a>
## 参数列表
These are the optional arguments you can pass to freeswitch:


FreeSWITCH startup switches

```makefile
-waste                 -- allow memory waste
-no-auto-stack         -- don't adjust thread stack size
-core                  -- dump cores
-help                  -- print this message
-version               -- print the version and exit
-rp                    -- enable high(realtime) priority settings
-lp                    -- enable low priority settings
-np                    -- enable normal priority settings (system default)
-vg                    -- run under valgrind
-nosql                 -- disable internal SQL scoreboard
-heavy-timer           -- Heavy Timer, possibly more accurate but at a cost
-nonat                 -- disable auto NAT detection
-nonatmap              -- disable auto NAT port mapping
-nocal                 -- disable clock calibration
-nort                  -- disable clock clock_realtime
-stop                  -- stop freeswitch
-nc                    -- no console and run in background
-ncwait                -- no console and run in background, but wait until the system is ready before exiting (implies -nc)
-c                     -- output to a console and stay in the foreground (default behavior)
```

<a name="xxj1D"></a>
## UNIX-like only

```makefile
-nf                    -- no forking
-u [user]              -- specify user to switch to
-g [group]             -- specify group to switch to
-ncwait                -- do not output to a console and background but wait until the system is ready before exiting (implies -nc)
```


<a name="sdvkX"></a>
## Windows-only
-service [name]        -- start freeswitch as a service, cannot be used if loaded as a console app<br />-install [name]        -- install freeswitch as a service, with optional service name<br />-uninstall             -- remove freeswitch as a service<br />-monotonic-clock       -- use monotonic clock as timer source


<a name="MHU4Y"></a>
## File locations
-base [basedir]         -- alternate prefix directory<br />-conf [confdir]         -- alternate directory for FreeSWITCH configuration files<br />-log [logdir]           -- alternate directory for logfiles<br />-run [rundir]           -- alternate directory for runtime files<br />-db [dbdir]             -- alternate directory for the internal database<br />-mod [moddir]           -- alternate directory for modules<br />-htdocs [htdocsdir]     -- alternate directory for htdocs<br />-scripts [scriptsdir]   -- alternate directory for scripts<br />-temp [directory]       -- alternate directory for temporary files<br />-grammar [directory]    -- alternate directory for grammar files<br />-recordings [directory] -- alternate directory for recordings<br />-storage [directory]    -- alternate directory for voicemail storage<br />-sounds [directory]     -- alternate directory for sound files<br />If you set the file locations of any one of -conf, -log, or -db you must set all three.
<a name="KbaRi"></a>
## File Paths
A handy method to determine where  FreeSWITCH™ is currently looking for files (in linux):<br />Method for showing FS paths

```makefile
bash> fs_cli -x 'global_getvar'| grep _dir
```

base_dir=/usr<br />recordings_dir=/var/lib/freeswitch/recordings<br />sounds_dir=/usr/share/freeswitch/sounds<br />conf_dir=/etc/freeswitch<br />log_dir=/var/log/freeswitch<br />run_dir=/var/run/freeswitch<br />db_dir=/var/lib/freeswitch/db<br />mod_dir=/usr/lib/freeswitch/mod<br />htdocs_dir=/usr/share/freeswitch/htdocs<br />script_dir=/usr/share/freeswitch/scripts<br />temp_dir=/tmp<br />grammar_dir=/usr/share/freeswitch/grammar<br />fonts_dir=/usr/share/freeswitch/fonts<br />images_dir=/var/lib/freeswitch/images<br />certs_dir=/etc/freeswitch/tls<br />storage_dir=/var/lib/freeswitch/storage<br />cache_dir=/var/cache/freeswitch<br />data_dir=/usr/share/freeswitch<br />localstate_dir=/var/lib/freeswitch<br />Argument Cautions<br />Setting some arguments may affect behavior in unexpected ways. The following list contains known side-effects of setting various command line arguments.<br />* nosql - Setting nosql completely disables the use of coreDB which means you will not have show channels, show calls, tab completion, or anything else that is stored in the coreDB.

