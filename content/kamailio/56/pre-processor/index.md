---
title: "1.3 预处理指令 - 文件导入、宏定义、环境变量读取"
draft: false
tags:
- all
categories:
- all
---

预处理指令主要的目的是方便脚本维护，方便脚本在不同环境下运行。
预处理之后，脚本才会开始解析。

# 1. include_file

       include_file "path_to_file"

Include the content of the file in config before parsing. path_to_file
must be a static string. Including file operation is done at startup. If
you change the content of included file, you have to restart the SIP
server to become effective.

> 路径必须是静态，修改脚本要重启

The path_to_file can be relative or absolute. If it is not absolute
path, first attempt is to locate it relative to current directory, and
if fails, relative to directory of the file that includes it. There is
no restriction where include can be used or what can contain - any part
of config file is ok. There is a limit of maximum 10 includes in depth,
otherwise you can use as many includes as you want. Reporting of the cfg
file syntax errors prints now the file name for easier troubleshooting.

> 在出现语法错误时，会打印原始文件名，方便调试

If the included file is not found, the config file parser throws error.
You can find this error message at the logging destination, usually in
the system logging (file).

You can use also the syntax **#!include_file** or **!!include_file**.

Example of usage:

``` c
route {
    ...
    include_file "/sr/checks.cfg"
    ...
}

--- /sr/checks.cfg ---

   if (!mf_process_maxfwd_header("10")) {
       sl_send_reply("483","Too Many Hops");
       exit;
   }

---
```

# 2. import_file

       import_file "path_to_file"

Similar to **include_file**, but does not throw error if the included
file is not found.

# 3. define

Control in C-style what parts of the config file are executed. The parts
in non-defined zones are not loaded, ensuring lower memory usage and
faster execution.

Available directives:

- **#!define NAME** - define a keyword
- **#!define NAME VALUE** - define a keyword with value
- **#!ifdef NAME** - check if a keyword is defined
- **#!ifndef** - check if a keyword is not defined
- **#!else** - switch to false branch of ifdef/ifndef region
- **#!endif** - end ifdef/ifndef region
- **#!trydef** - add a define if not already defined
- **#!redefine** - force redefinition even if already defined

Predefined keywords:

- **KAMAILIO_X\[\_Y\[\_Z\]\]** - Kamailio versions
- **MOD_X** - when module X has been loaded

See 'kamctl core.ppdefines_full' for full list.

Among benefits:

- easy way to enable/disable features (e.g., see default cfg --
    controlling support of nat traversal, presence, etc...)
- switch control for parts where conditional statements were not
    possible (e.g., global parameters, module settings)
- faster by not using conditional statements inside routing blocks
    when switching between running environments

Example: how to make config to be used in two environments, say testbed
and production, controlled just by one define to switch between the two
modes:

``` c
...

#!define TESTBED_MODE

#!ifdef TESTBED_MODE
  debug=5
  log_stderror=yes
  listen=192.168.1.1
#!else
  debug=2
  log_stderror=no
  listen=10.0.0.1
#!endif

...

#!ifdef TESTBED_MODE
modparam("acc|auth_db|usrloc", "db_url",
    "mysql://kamailio:kamailiorw@localhost/kamailio_testbed")
#!else
modparam("acc|auth_db|usrloc", "db_url",
    "mysql://kamailio:kamailiorw@10.0.0.2/kamailio_production")
#!endif

...

#!ifdef TESTBED_MODE
route[DEBUG] {
  xlog("SCRIPT: SIP $rm from: $fu to: $ru - srcip: $si"\n);
}
#!endif

...

route {
#!ifdef TESTBED_MODE
  route(DEBUG);
#!endif

  ...
}

...
```

- you can define values for IDs

``` c
#!define MYINT 123
#!define MYSTR "xyz"
```

- defined IDs are replaced at startup, during config parsing, e.g.,:

``` c
$var(x) = 100 + MYINT;
```

- is interpreted as:

``` c
$var(x) = 100 + 123;
```

- you can have multi-line defined IDs

``` c
#!define IDLOOP $var(i) = 0; \
                while($var(i)<5) { \
                    xlog("++++ $var(i)\n"); \
                    $var(i) = $var(i) + 1; \
                }
```

- then in routing block

``` c
route {
    ...
    IDLOOP
    ...
}
```

- number of allowed defines is now set to 256

<!-- -->

- notes:
  - multilines defines are reduced to single line, so line counter
        should be fine
  - column counter goes inside the define value, but you have to
        omit the '\\' and CR for the accurate inside-define position
  - text on the same line as the directive will cause problems. Keep
        the directive lines clean and only comment on a line before or
        after.
  - if using git to pull the kamailio.cfg to your machine, make
        sure that #!endif is NOT the last line of your config file.
        this causes a "different number of preprocessor directives"
        error.  if you need, put a comment line after the #!endif line

# 4. defenv

Preprocessor directive to define an ID to the value of an environment
variable with the name ENVVAR.

> 这里你思考一下，如果定义的环境变量不存在，会发生什么？

``` c
#!defenv ID=ENVVAR
```

It can also be just **$!defenv ENVVAR** and the defined ID is the ENVVAR
name.

Example:

``` c
#!defenv SHELL
```

If environment variable $SHELL is '/bin/bash', then it is like:

``` c
#!define SHELL /bin/bash
```

Full expression variant:

``` c
#!defenv ENVSHELL=SHELL
```

Then it is like:

``` c
#!define ENVSHELL /bin/bash
```

It is a simplified alternative of using **#!substdef** with
**$env(NAME)** in the replacement part.

# 5. defenvs

Similar to **#!defenv**, but the value is defined in between double
quotes to make it convenient to be used as a string token.

``` c
#!defenvs ENVVAR
#!defenvs ID=ENVVAR
```

# 6. subst

- perform substitutions inside the strings of config (note that define
    is replacing only IDs - alphanumeric tokens not enclosed in quotes)
- `#!subst` offers an easy way to search and replace inside strings
    before cfg parsing. E.g.,:

``` c
#!subst "/regexp/subst/flags"
```

- flags is optional and can be: 'i' - ignore case; 'g' - global
    replacement

Example:

``` c
#!subst "/DBPASSWD/xyz/"
modparam("acc", "db_url", "mysql://user:DBPASSWD@localhost/db")
```

- will do the substitution of db password in db_url parameter value

# 7. substdef

``` c
#!substdef "/ID/subst/"
```

Similar to **subst**, but in addition it adds a **#!define ID subst**.

# 8. substdefs

``` c
#!substdefs "/ID/subst/"
```

Similar to **subst**, but in addition it adds a **#!define ID "subst"**
(note the difference from `#!substdef` that the value for define is
enclosed in double quotes, useful when the define is used in a place for
a string value).

# 9. trydefenv

``` c
#!trydefenv ID=ENVVAR
```

Similar to **defenv**, but will not error if the environmental variable
is not set. This allows for boolean defines via system ENVVARs. For
example, using an environmental variable to toggle loading of db_mysql:

``` c
#!trydefenv WITH_MYSQL

#!ifdef WITH_MYSQL
loadmodule "db_mysql.so"
#!ifdef
```

# 10. trydefenvs

Similar to **#!trydefenv**, but the value is defined in between double
quotes to make it convenient to be used as a string token.

``` c
#!trydefenvs ENVVAR
#!trydefenvs ID=ENVVAR
```
