---
title: "rtpengine"
date: "2020-02-20 10:28:41"
draft: false
---

# 帮助文档


## Usage:

```bash
rtpengine [OPTION...]  - next-generation media proxy
```


## Application Options:

- -v, --version
   - Print build time and exit
- --config-file=FILE
   - Load config from this file
- --config-section=STRING
   - Config file section to use
- --log-facility=daemon|local0|...|local7                    
   - Syslog facility to use for logging
- **-L, --log-level=INT      **                                  
   - Mask log priorities above this level
   - 取值从0-7，
   - 7 debug
   - 6 info
   - 5 notice
- **-E, --log-stderr      **                                      
   - Log on stderr instead of syslog
- --no-log-timestamps                                        
   - Drop timestamps from log lines to stderr
- --log-mark-prefix                                          
   - Prefix for sensitive log info
- --log-mark-suffix                                          
   - Suffix for sensitive log info
- **-p, --pidfile=FILE           **                               
   - Write PID to file
- **-f, --foreground                       **                     
   - Don't fork to background
- -t, --table=INT                                            
   - Kernel table to use
- -F, --no-fallback                                          
   - Only start when kernel module is available
- **-i, --interface=[NAME/]IP[!IP]   **                           
   - Local interface for RTP
- -k, --subscribe-keyspace=INT INT ...                        
   - Subscription keyspace list
- -l, --listen-tcp=[IP:]PORT                                  
   - TCP port to listen on
- -u, --listen-udp=[IP46|HOSTNAME:]PORT                      
   - UDP port to listen on
- -n, --listen-ng=[IP46|HOSTNAME:]PORT                      
   -  UDP port to listen on, NG protocol
- **-c, --listen-cli=[IP46|HOSTNAME:]PORT     **                 
   - UDP port to listen on, CLI
- -g, --graphite=IP46|HOSTNAME:PORT                          
   - Address of the graphite server
- -G, --graphite-interval=INT                                
   - Graphite send interval in seconds
- --graphite-prefix=STRING                                    
   - Prefix for graphite line
- -T, --tos=INT                                              
   - Default TOS value to set on streams
- --control-tos=INT                                          
   - Default TOS value to set on control-ng
- -o, --timeout=SECS                                          
   - RTP timeout
- -s, --silent-timeout=SECS                                  
   - RTP timeout for muted
- -a, --final-timeout=SECS                                    
   - Call timeout
- --offer-timeout=SECS                                        
   - Timeout for incomplete one-sided calls
- **-m, --port-min=INT    **                                      
   - Lowest port to use for RTP
- **-M, --port-max=INT    **                                      
   - Highest port to use for RTP
- -r, --redis=[PW@]IP:PORT/INT                                
   - Connect to Redis database
- -w, --redis-write=[PW@]IP:PORT/INT                        
   -  Connect to Redis write database
- --redis-num-threads=INT                                    
   - Number of Redis restore threads
- --redis-expires=INT                                        
   - Expire time in seconds for redis keys
- -q, --no-redis-required                                    
   - Start no matter of redis connection state
- --redis-allowed-errors=INT                                  
   - Number of allowed errors before redis is temporarily disabled
- --redis-disable-time=INT                                    
   - Number of seconds redis communication is disabled because of errors
- --redis-cmd-timeout=INT                                    
   - Sets a timeout in milliseconds for redis commands
- --redis-connect-timeout=INT                                
   - Sets a timeout in milliseconds for redis connections
- -b, --b2b-url=STRING                                        
   - XMLRPC URL of B2B UA
- --log-facility-cdr=daemon|local0|...|local7                
   - Syslog facility to use for logging CDRs
- --log-facility-rtcp=daemon|local0|...|local7                
   - Syslog facility to use for logging RTCP
- --log-facility-dtmf=daemon|local0|...|local7              
   -  Syslog facility to use for logging DTMF
- --log-format=default|parsable                              
   - Log prefix format
- --dtmf-log-dest=IP46|HOSTNAME:PORT                          <br />    Destination address for DTMF logging via UDP
- -x, --xmlrpc-format=INT                                    
   - XMLRPC timeout request format to use. 0: SEMS DI, 1: call-id only, 2: Kamailio
- --num-threads=INT                                          
   - Number of worker threads to create
- --media-num-threads=INT                                    
   - Number of worker threads for media playback
- -d, --delete-delay=INT                                      
   - Delay for deleting a session from memory.
- --sip-source                                                
   - Use SIP source address by default
- --dtls-passive                                              
   - Always prefer DTLS passive role
- --max-sessions=INT                                          
   - Limit of maximum number of sessions
- --max-load=FLOAT                                            
   - Reject new sessions if load averages exceeds this value
- --max-cpu=FLOAT                                            
   - Reject new sessions if CPU usage (in percent) exceeds this value
- --max-bandwidth=INT                                        
   - Reject new sessions if bandwidth usage (in bytes per second) exceeds this value
- --homer=IP46|HOSTNAME:PORT                                  
   - Address of Homer server for RTCP stats
- --homer-protocol=udp|tcp                                    
   - Transport protocol for Homer (default udp)
- --homer-id=INT                                              
   - 'Capture ID' to use within the HEP protocol
- --recording-dir=FILE                                        
   - Directory for storing pcap and metadata files
- --recording-method=pcap|proc                                
   - Strategy for call recording
- --recording-format=raw|eth                                  
   - File format for stored pcap files
- --iptables-chain=STRING                                    
   - Add explicit firewall rules to this iptables chain
- --codecs                                                    
   - Print a list of supported codecs and exit
- --scheduling=default|none|fifo|rr|other|batch|idle          
   - Thread scheduling policy
- --priority=INT                                              
   - Thread scheduling priority
- --idle-scheduling=default|none|fifo|rr|other|batch|idle    
   - Idle thread scheduling policy
- --idle-priority=INT                                        
   - Idle thread scheduling priority
- --log-srtp-keys                                            
   - Log SRTP keys to error log
- --mysql-host=HOST|IP                                        
   - MySQL host for stored media files
- --mysql-port=INT                                            
   - MySQL port
- --mysql-user=USERNAME                                      
   - MySQL connection credentials
- --mysql-pass=PASSWORD                                      
   - MySQL connection credentials
- --mysql-query=STRING                                        
   - MySQL select query
- --endpoint-learning=delayed|immediate|off|heuristic        
   - RTP endpoint learning algorithm
- --jitter-buffer=INT                                        
   - Size of jitter buffer
- --jb-clock-drift                                            
   - Compensate for source clock drift



# 参考

- [https://github.com/sipwise/rtpengine](https://github.com/sipwise/rtpengine)

