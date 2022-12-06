---
title: '核心变量'
date: '2022-10-31 14:41:43'
draft: true
---

# 脚本变量

# avp 变量

# 伪变量

## SIP 头, $(hrd(name))

$(hdr(name)[N]) - represents the body of the N-th header identified by 'name'. If [N] is omitted then the body of the first header is printed. The first header is got when N=0, for the second N=1, a.s.o. To print the last header of that type, use -1, no other negative values are supported now. No white spaces are allowed inside the specifier (before }, before or after {, [, ] symbols). When N='\*', all headers of that type are printed.

The module should identify most of compact header names (the ones recognized by OpenSIPS which should be all at this moment), if not, the compact form has to be specified explicitly. It is recommended to use dedicated specifiers for headers (e.g., %ua for user agent header), if they are available -- they are faster.

$(hdrcnt(name)) -- returns number of headers of type given by 'name'. Uses same rules for specifying header names as $hdr(name) above. Many headers (e.g., Via, Path, Record-Route) may appear more than once in the message. This variable returns the number of headers of a given type.

Note that some headers (e.g., Path) may be joined together with commas and appear as a single header line. This variable counts the number of header lines, not header values.

For message fragment below, $hdrcnt(Path) will have value 2 and $(hdr(Path)[0]) will have value <a.com>:

```
    Path: <a.com>
    Path: <b.com>
```

For message fragment below, $hdrcnt(Path) will have value 1 and $(hdr(Path)[0]) will have value <a.com>,<b.com>:

```
    Path: <a.com>,<b.com>
```

Note that both examples above are semantically equivalent but the variables take on different values.
