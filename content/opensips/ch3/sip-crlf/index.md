---
title: "SIP消息格式CRLF"
date: "2020-12-25 17:44:31"
draft: false
---
```bash
         generic-message  =  start-line
                             *message-header
                             CRLF
                             [ message-body ]
         start-line       =  Request-Line / Status-Line
```

其中在[rfc2543](https://tools.ietf.org/html/rfc2543)中规定

```bash
CR        =  %d13 ; US-ASCII CR, carriage return character 
LF        =  %d10 ; US-ASCII LF, line feed character
```

| 项目 | 十进制 | 字符串表示 |
| --- | --- | --- |
| CR | 13 | \\r |
| LF | 10 | \\n |


也就是说在一个SIP消息中

```bash
headline\r\n
key:v\r\n
\r\n
some_body\r\n
```

所以CRLF就是 `\r\n` 


# 参考

- [https://tools.ietf.org/html/rfc3261](https://tools.ietf.org/html/rfc3261)
- [https://tools.ietf.org/html/rfc2543](https://tools.ietf.org/html/rfc2543)

