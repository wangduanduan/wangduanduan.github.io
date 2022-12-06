---
title: "fs reload命令"
date: "2019-12-10 11:17:55"
draft: false
---
| **Item** | **Reload Command** | **Notes** |
| :--- | :--- | :--- |
| XML Dialplan | reloadxml | Run each time you edit XML dial file(s) |
| ACLs | reloadacl | Edit acl.conf.xml first |
| Voicemail | reload mod_voicemail | Edit voicemail.conf.xml first |
| Conference | reload mod_conference | Edit conference.conf.xml first |
| Add Sofia Gateway | sofia profile <name> rescan | Less intrusive - no calls dropped |
| Remove Sofia Gateway | sofia profile <name> killgw <gateway_name> | Less intrusive - no calls dropped |
| Restart Sofia Gateway | sofia profile <name> killgw <gateway_name><br />sofia profile <name> rescan | Less intrusive - no calls dropped |
| Add/remove Sofia Gateway | sofia profile <name> restart | More intrusive - all profile calls dropped |
| Local Stream | see [Mod_local_stream](https://freeswitch.org/confluence/display/FREESWITCH/mod_local_stream#mod_local_stream-API) | Edit localstream.conf.xml first |
| Update a lua file | nothing necessary | file is loaded from disk each time it is run |
| Update LCR SQL table | nothing necessary | SQL query is run for each new call |
| Update LCR options | reload mod_lcr | Edit lcr.conf.xml first |
| Update CID Lookup Options | reload mod_cidlookup | Edit cidlookup.conf.xml first |
| Update JSON CDR Options | reload mod_json_cdr | Edit json_cdr.conf.xml first |
| Update XML CDR Options | reload mod_xml_cdr | Edit xml_cdr.conf.xml first |
| Update XML CURL Server Response | nothing, unless using [cache](https://freeswitch.org/confluence/display/FREESWITCH/mod_xml_curl#mod_xml_curl-Caching) |   |


