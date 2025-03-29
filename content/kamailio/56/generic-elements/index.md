---
title: "1.2 通用元素 - 注释、标识符、变量、值、表达式"
# date: "2025-03-28 23:49:25"
draft: false
# type: posts
tags:
- all
categories:
- all
---


# 1. Comments

Line comments start with **#** (hash/pound character - like in shell) or
**/ /** (double forward slash - like in C++/Java).

Block comments start with /\* (forward slash and asterisk) and are ended
by \*/ (sterisk and forward slash) (like in C, C++, Java).

Example:

      # this is a line comment

      // this is another line comment

      /* this
         is
         a
         block
         comment */

Important: be aware of preprocessor directives that start with **#!**
(hash/pound and exclamation) - those are no longer line comments.

# 2. Values

There are three types of values:

- integer - numbers of 32bit size
- boolean - aliases to 1 (true, on, yes) or 0 (false, off, no)
- string - tokens enclosed in between double or single quotes

> 这里思考一个问题：如果字符串太长，如何换行？

Example:

``` c
// next two are strings

  "this is a string value"
  'this is another string value'

// next is a boolean

  yes

// next is an integer

  64

```

# 3. Identifiers

Identifiers are tokens which are not enclosed in single or double quotes
and to match the rules for integer or boolean values.

For example, the identifiers are the core parameters and functions,
module functions, core keywords and statements.

Example:

``` c
return
```

# 4. Variables

The variables start with **$** (dollar character).

You can see the list with available variables in the Pseudo-Variables
Cookbook.

Example:

``` c
$var(x) = $rU + "@" + $fd;
```

# 5. Actions

An action is an element used inside routing blocks ended by **;**
(semicolon). It can be an execution of a function from core or a module,
a conditional or loop statement, an assignment expression.

Example:

``` c
  sl_send_reply("404", "Not found");
  exit;
```

#  6. Expressions

An expression is an association group of statements, variables,
functions and operators.

Example:

``` c
if(!t_relay())

if($var(x)>10)

"sip:" + $var(prefix) + $rU + "@" + $rd
```