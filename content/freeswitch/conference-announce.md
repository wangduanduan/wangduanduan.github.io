---
title: "会议提示音无法正常播放"
date: 2022-05-28T17:17:54+08:00
---

呼入到会议，正常来说，当会议室有且只有一人时，应该会报“当前只有一人的提示音”。但是测试的时候，输入了密码，进入了会议，却没有播报正常的提示音。


经过排查发现，dialplan中，会议室的名字中含有@符号。

按照fs的文档，发现@后面应该是profilename, 然而fs的conference.conf.xml却没有这个profile, 进而导致语音无法播报的问题。所以只要加入这个profile, 或者直接用@default, 就可以正确的播报语音了。

| Action data                         | Description                                                            |
| ---                                 | ---                                                                    |
| confname                            | profile is "default", no flags or pin                                  |
| confname+1234                       | profile is "default", pin is 1234                                      |
| confname@profilename+1234           | profile is "profilename", pin=1234, no flags                           |
| confname+1234+flags{mute}           | profile is "default", pin=1234, one flag                               |
| confname++flags{endconf\|moderator}  | profile is "default", no p.i.n., multiple flags                        |
| bridge:confname:1000@${domain_name} | a "bridging" conference, you must provide another endpoint, or 'none'. |
| bridge:_uuid_:none                  | a "bridging" conference with UUID assigned as conference name          |

所以，当你遇到问题的时候，应该仔细的再去阅读一下官方的接口文档。

参考文档
- https://txlab.wordpress.com/2012/09/17/setting-up-a-conference-bridge-with-freeswitch/
- https://freeswitch.org/confluence/display/FREESWITCH/mod_conference

