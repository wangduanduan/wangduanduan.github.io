---
title: "sipsak"
date: "2020-07-31 19:16:36"
draft: false
---
sipsak is a command line tool which can send simple requests to a SIP server. It can run additional tests on a SIP server which are usefull for admins and developers of SIP enviroments.

[https://github.com/nils-ohlmeier/sipsak](https://github.com/nils-ohlmeier/sipsak)


# 安装
```bash
apt-get install sipsak
```


# 发送options
```bash
sipsak -vv -p 192.168.2.63:5060 -s sip:8001@test.cc
```



# man
```bash
SIPSAK(1)                                                     User Manuals                                                    SIPSAK(1)

NAME
       sipsak - a utility for various tests on sip servers and user agents

SYNOPSIS
       sipsak  [-dFGhiILnNMRSTUVvwz]  [-a  PASSWORD ] [-b NUMBER ] [-c SIPURI ] [-C SIPURI ] [-D NUMBER ] [-e NUMBER ] [-E STRING ] [-f
       FILE ] [-g STRING ] [-H HOSTNAME ] [-j STRING ] [-J STRING ] [-l PORT ] [-m NUMBER ] [-o NUMBER ] [-p HOSTNAME ]  [-P  NUMBER  ]
       [-q REGEXP ] [-r PORT ] [-t NUMBER ] [-u STRING ] [-W NUMBER ] [-x NUMBER ] -s SIPURI

DESCRIPTION
       sipsak  is  a  SIP stress and diagnostics utility.  It sends SIP requests to the server within the sip-uri and examines received
       responses.  It runs in one of the following modes:

       - default mode
              A SIP message is sent to destination in sip-uri and reply status is displayed.  The request is either taken from filename
              or generated as a new OPTIONS message.

       - traceroute mode (-T)
              This mode is useful for learning request's path. It operates similarly to IP-layer utility traceroute(8).

       - message mode (-M)
              Sends  a  short  message (similar to SMS from the mobile phones) to a given target. With the option -B the content of the
              MESSAGE can be set. Useful might be the options -c and -O in this mode.

       - usrloc mode (-U)
              Stress mode for SIP registrar.  sipsak keeps registering to a SIP server at high pace. Additionally the registrar can  be
              stressed  with  the -I or the -M option.  If -I and -M are omitted sipsak can be used to register any given contact (with
              the -C option) for an account at a registrar and to query the current bindings for an account at a registrar.

       - randtrash mode (-R)
              Parser torture mode.  sipsak keeps sending randomly corrupted messages to torture a SIP server's parser.

       - flood mode (-F)
              Stress mode for SIP servers.  sipsak keeps sending requests to a SIP server at high pace.
      If libruli (http://www.nongnu.org/ruli/) or c-ares (http://daniel.haxx.se/projects/c-ares/) support is compiled into the  sipsak
       binary,  then  first a SRV lookup for _sip._tcp.hostname is made. If that fails a SRV lookup for _sip._udp.hostname is made. And
       if this lookup fails a normal A lookup is made. If a port was given in the target URI the SRV lookup is omitted. Failover,  load
       distribution and other transports are not supported yet.

OPTIONS
       -a, --password PASSWORD
              With  the  given  PASSWORD an authentication will be tryed on received '401 Unauthorized'. Authorization will be tryed on
              time. If this option is omitted an authorization with an empty password ("") will be tryed. If the password is equal to -
              the  password  will  be read from the standard input (e.g. the keyboard). This prevents other users on the same host from
              seeing the password the password in the process list.  NOTE: the password still can be read  from  the  memory  if  other
              users have access to it.

       -A, --timing
              prints  only the timing values of the test run if verbosity is zero because no -v was given. If one or more -v were given
              this option will be ignored.

       -b, --apendix-begin NUMBER
              The starting number which is appended to the user name in the usrloc mode.  This NUMBER is increased until it reaches the
              value given by the -e parameter. If omitted the starting number will be one.

       -B, --message-body STRING
              The given STRING will be used as the body for outgoing MESSAGE requests.

       -c, --from SIPURI
              The  given SIPURI will be used in the From header if sipsak runs in the message mode (initiated with the -M option). This
              is helpful to present the receiver of a MESSAGE a meaningfull and usable address to where maybe  even  responses  can  be
              send.
      -C, --contact SIPURI
              This  is  the content of the Contact header in the usrloc mode. This allows to insert forwards like for mail. For example
              you can insert the uri of your first SIP account at a second account, thus all calls to the second account will  be  for‐
              warded  to the first account.  As the argument to this option will not be enclosed in brackets you can give also multiple
              contacts in the raw format as comma separated list.  The special words empty or none will result in no contact header  in
              the  REGISTER  request and thus the server should answer with the current bindings for the account at the registrar.  The
              special words * or star will result in Contact header containing just a star,  e.g.  to  remove  all  bindings  by  using
              expires value 0 together with this Contact.

       -d, --ignore-redirects
              If this option is set all redirects will be ignored. By default without this option received redirects will be respected.
              This option is automatically activated in the randtrash mode and in the flood mode.

       -D, --timeout-factor NUMBER
              The SIP_T1 timer is getting multiplied with the given NUMBER. After  receiving  a  provisional  response  for  an  INVITE
              request,  or  when a reliable transport like TCP or TLS is used sipsak waits for the resulting amount of time for a final
              response until it gives up.

       -e, --appendix-end NUMBER
              The ending number which is appended to the user name in the usrloc mode.  This number is increased until it reaches  this
              ending  number.   In  the  flood  mode this is the maximum number of messages which will be send.  If omitted the default
              value is 2^31 (2147483647) in the flood mode.

       -E, --transport STRING
              The value of STRING will be used as IP transport for sending and receiving requests and  responses.   This  option  over‐
              writes  any  result  from  the  URI  evaluation and SRV lookup.  Currently only 'udp' and 'tcp' are accepted as value for
              STRING.
      -f, --filename FILE
              The content of FILE will be read in in binary mode and will be used as replacement for the alternatively created sip mes‐
              sage.  This  can  used in the default mode to make other requests than OPTIONS requests (e.g. INVITE). By default missing
              carriage returns in front of line feeds will be inserted (use -L to de-activate this function). If the filename is  equal
              to - the file is read from standard input, e.g. from the keyboard or a pipe.  Please note that the manipulation functions
              (e.g. inserting Via header) are only tested with RFC conform requests. Additionally special strings within the  file  can
              be replaced with some local or given values (see -g and -G for details).

       -F, --flood-mode
              This options activates the flood mode. In this mode OPTIONS requests with increasing CSeq numbers are sent to the server.
              Replies are ignored -- source port 9 (discard) of localhost is advertised in topmost Via.

       -h, --help
              Prints out a simple usage help message. If the long option --help is available it will print out a help message with  the
              available long options.

       -g, --replace-string STRING
              Activates  the  replacement of $replace$ within the request (usually read in from a file) with the STRING.  Alternatively
              you can also specify a list of attribute and values.  This list has to start and end with a non alpha-numeric  character.
              The same character has to be used also as separator between the attribute and the value and between new further attribute
              value pairs. The string "$attribute$" will be replaced with the value string in the message.

       -G, --replace
              Activates the automatic replacement of the following variables in the request (usually read in from  a  file):  $dsthost$
              will  be  replaced  by with the host or domainname which is given by the -s parameter.  $srchost$ will be replaced by the
              hostname of the local machine.  $port$ will be replaced by the local listening port of sipsak.  $user$ will  be  replaced
              by the username which is given by the -s parameter.

       -H, --hostname HOSTNAME
              Overwrites  the automatic detection of the hostname with the given parameter.  Warning: use this with caution (preferable
              only if the automatic detection fails).
       -i, --no-via
              Deactivates the insertion of the Via line of the localhost.   Warning:  this  probably  disables  the  receiving  of  the
              responses from the server.

       -I, --invite-mode
              Activates  the  Invites  cycles  within the usrloc mode. It should be combined with -U.  In this combination sipsak first
              registeres a user, and then simulates an invitation to this user. First an Invite is sent, this is replied  with  200  OK
              and  finally an ACK is sent. This option can also be used without -U , but you should be sure to NOT invite real UAs with
              this option. In the case of a missing -U the -l PORT is required because only if you made a -U run  with  a  fixed  local
              port  before,  a  run with -I and the same fixed local port can be successful.  Warning: sipsak is no real UA and invita‐
              tions to real UAs can result in unexpected behaivior.

       -j, --headers STRING
              The string will be added as one or more additional headers to the request. The string "\n" (note: two characters) will be
              replaced with CRLF and thus result in two separate headers. That way more then one header can be added.

       -J, --autohash STRING
              The  string  will be used as the H(A1) input to the digest authentication response calculation. Thus no password from the
              -a option is required if this option is provided. The given string is expected to be a hex string with the length of  the
              used hash function.

       -k, --local-ip STRING
              The local ip address to be used

       -l, --local-port PORT
              The  receiving  UDP socket will use the local network port.  Useful if a file is given by -f which contains a correct Via
              line. Check the -S option for details how sipsak sends and receives messages.

       -L, --no-crlf
              De-activates the insertion of carriage returns (\r) before all line feeds (\n) (which is not already  proceeded  by  car‐
              raige  return)  if the input is coming from a file ( -f ). Without this option also an empty line will be appended to the
              request if required.

      -m, --max-forwards NUMBER
              This sets the value of the Max-Forward header field. If omitted no Max-Forward field will be inserted. If omitted in  the
              traceroute mode number will be 255.

       -M, --message-mode
              This  activates the Messages cycles within the usrloc mode (known from sipsak versions pre 0.8.0 within the normal usrloc
              test). This option should be combined with -U so that a successful registration will be tested with a test message to the
              user  and  replied  with  200  OK. But this option can also be used without the -U option.  Warning: using without -U can
              cause unexpected behaivor.

       -n, --numeric
              Instead of the full qualified domain name in the Via line the IP of the local host will be used. This option is now on by
              default.

       -N, --nagios-code
              Use  Nagios comliant return codes instead of the normal sipsak ones. This means sipsak will return 0 if everything was ok
              and 2 in case of any error (local or remote).

       -o, --sleep NUMBER
              sipsak will sleep for NUMBER ms before it starts the next cycle in the usrloc mode. This will slow down  the  whole  test
              process  to  be more realistic. Each cycle will be still completed as fast as possible, but the whole test will be slowed
              down.

       -O, --disposition STRING
              The given STRING will be used as the content for the Content-Disposition header. Without this option  there  will  be  no
              Content-Disposition header in the request.

       -p, --outbound-proxy HOSTNAME[:PORT]
              the address of the hostname is the target where the request will be sent to (outgoing proxy). Use this if the destination
              host is different then the host part of the request uri. The hostname is resolved via DNS SRV if supported (see  descrip‐
              tion for SRV resolving) and no port is given.
       -P, --processes NUMBER
              Start  NUMBER  of  processes in parallel to do the send and reply checking. Only makes sense if a higher number for -e is
              given in the usrloc, message or invite mode.

       -q, --search REGEXP
              match replies against REGEXP and return false if no match occurred. Useful for example to detect server  name  in  Server
              header field.

       -r, --remote-port PORT
              Instead of the default sip port 5060 the PORT will be used. Alternatively the remote port can be given within the sip uri
              of the -s parameter.

       -R, --random-mode
              This activates the randtrash mode. In this mode OPTIONS requests will be send to server with increasing numbers  of  ran‐
              domly  crashed  characters  within this request. The position within the request and the replacing character are randomly
              chosen. Any other response than Bad request (4xx) will stop this mode. Also three unresponded sends will stop this  mode.
              With the -t parameter the maximum of trashed characters can be given.

       -s, --sip-uri SIPURI
              This mandatory option sets the destination of the request. It depends on the mode if only the server name or also an user
              name is mandatory. Example for a full SIPURI : sip:test@foo.bar:123 See the  note  in  the  description  part  about  SRV
              lookups for details how the hostname of this URI is converted into an IP and port.

       -S, --symmetric
              With  this  option  sipsak will use only one port for sending and receiving messages. With this option the local port for
              sending will be the value from the -l option. In the default mode sipsak sends from a random  port  and  listens  on  the
              given port from the -l option.  Note: With this option sipsak will not be able to receive replies from servers with asym‐
              metric signaling (and broken rport implementation) like the Cisco proxy. If you run sipsak as root and  with  raw  socket
              support  (check  the output from the -V option) then this option is not required because in this case sipsak already uses
              only one port for sending and receiving messages.
     -t, --trash-chars NUMBER
              This parameter specifies the maximum of trashed characters in the randtrash mode. If omitted NUMBER will be  set  to  the
              length of the request.

       -T, --traceroute-mode
              This  activates the traceroute mode. This mode works like the well known traceroute(8) command expect that not the number
              of network hops are counted rather the number of server on the way to the destination user. Also the round trip  time  of
              each  request  is  printed out, but due to a limitation within the sip protocol the identity (IP or name) can only deter‐
              mined and printed out if the response from the server contains a warning header field. In  this  mode  on  each  outgoing
              request  the  value  of  the  Max-Forwards  header field is increased, starting with one. The maximum of the Max-Forwards
              header will 255 if no other value is given by the -m parameter. Any other response than 483 or 1xx are treated as a final
              response and will terminate this mode.

       -u, --auth-username STRING
              Use the given STRING as username value for the authentication (different account and authentication username).

       -U, --usrloc-mode
              This  activates  the  usrloc mode. Without the -I or the -M option, this only registers users at a registrar. With one of
              the above options the previous registered user will also be probed ether with a simulated call flow (invite, 200, ack) or
              with  an instant message (message, 200). One password for all users accounts within the usrloc test can be given with the
              -a option. An user name is mandatory for this mode in the -s parameter. The number starting from the -b parameter to  the
              -e  parameter  is  appended the user name. If the -b and the -e parameter are omitted, only one runs with the given user‐
              name, but without append number to the usernames is done.

       -v, --verbose
              This parameter increases the output verbosity. No -v means nearly no output except in traceroute and error messages.  The
              maximum of three v's prints out the content of all packets received and sent.

       -V, --version
              Prints out the name and version number of sipsak and the options which were compiled into the binary.

       -w, --extract-ip
              Activates the extraction of the IP or hostname from the Warning header field.
       -W, --nagios-warn NUMBER
              Return Nagios warn exit code (1) if the number of retransmissions before success was above the given number.

       -x, --expires NUMBER
              Sets the value of the Expires header to the given number.

       -z, --remove-bindings
              Activates the randomly removing of old bindings in the usrloc mode. How many per cent of the bindings will be removed, is
              determined by the USRLOC_REMOVE_PERCENT define within the code (set it before compilation).  Multiple removing  of  bind‐
              ings is possible, and cannot be prevented.

       -Z, --timer-t1
              Sets the amount of milliseconds for the SIP timer T1. It determines the length of the gaps between two retransmissions of
              a request on a unreliable transport. Default value is 500 if not changed via the configure option --enable-timeout.

RETURN VALUES
       The return value 0 means that a 200 was received. 1 means something else then 1xx or 2xx was received.  2 will  be  returned  on
       local  errors  like  non  resolvable  names or wrong options combination. 3 will be returned on remote errors like socket errors
       (e.g. icmp error), redirects without a contact header or simply no answer (timeout).

       If the -N option was given the return code will be 2 in case of any (local or remote) error. 1 in case there have been  retrans‐
       missions from sipsak to the server. And 0 if there was no error at all.

CAUTION
       Use sipsak responsibly. Running it in any of the stress modes puts substantial burden on network and server under test.

EXAMPLES
       sipsak -vv -s sip:nobody@foo.bar
              displays received replies.

       sipsak -T -s sip:nobody@foo.bar
              traces SIP path to nobody.
       sipsak -U -C sip:me@home -x 3600 -a password -s sip:myself@company
              inserts forwarding from work to home for one hour.

       sipsak -f bye.sip -g '!FTAG!345.af23!TTAG!1208.12!' -s sip:myproxy
              reads the file bye.sip, replaces $FTAG$ with 345.af23 and $TTAG$ with 1208.12 and finally send this message to myproxy

LIMITATIONS / NOT IMPLEMENTED
       Many  servers  may  decide NOT to include SIP "Warning" header fields.  Unfortunately, this makes displaying IP addresses of SIP
       servers in traceroute mode impossible.

       IPv6 is not supported.

       Missing support for the Record-Route and Route header.

BUGS
       sipsak is only tested against the SIP Express Router (ser) though their could be various bugs. Please feel free to mail them  to
       the author.

AUTHOR
       Nils Ohlmeier <nils at sipsak dot org>

SEE ALSO
       traceroute(8)

```

