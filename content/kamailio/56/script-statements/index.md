---
title: "1.17 脚本语法 - if、else、switch、while、赋值、比较、算数等"
draft: false
tags:
- all
categories:
- all
---

# 1. if

IF-ELSE statement

Prototype:

        if(expr) {
           actions;
        } else {
           actions;
        }

The `expr` should be a valid logical expression.

The logical operators that can be used in `expr`:

- `==`:      equal
- `!=`:      not equal
- `=~`:      case-insensitive regular expression matching: Note: Posix regular expressions will be used, e.g. use `[[:digit:]]{3}` instead of `\d\d\d`
- `!~`:      regular expression not-matching (NOT PORTED from Kamailio 1.x, use `!(x =~ y)`)
- `>`:       greater
- `>=`:      greater or equal
- `<`:       less
- `<=`:      less or equal
- `&&`:      logical AND
- `||`:      logical OR
- `!`:       logical NOT

Example of usage:

      if(is_method("INVITE"))
      {
          log("this sip message is an invite\n");
      } else {
          log("this sip message is not an invite\n");
      }

See also the FAQ for how the function return code is evaluated:

- [How is the function code evaluated](../../tutorials/faq/main.md#how-is-the-function-return-code-evaluated)

# 2. switch

SWITCH statement - it can be used to test the value of a
pseudo-variable.

IMPORTANT NOTE: `break` can be used only to mark the end of a `case`
branch (as it is in shell scripts). If you are trying to use `break`
outside a `case` block the script will return error -- you must use
`return` there.

Example of usage:

        route {
            route(1);
            switch($retcode)
            {
                case -1:
                    log("process INVITE requests here\n");
                break;
                case 1:
                    log("process REGISTER requests here\n");
                break;
                case 2:
                case 3:
                    log("process SUBSCRIBE and NOTIFY requests here\n");
                break;
                default:
                    log("process other requests here\n");
           }

            # switch of R-URI username
            switch($rU)
            {
                case "101":
                    log("destination number is 101\n");
                break;
                case "102":
                    log("destination number is 102\n");
                break;
                case "103":
                case "104":
                    log("destination number is 103 or 104\n");
                break;
                default:
                    log("unknown destination number\n");
           }
        }

        route[1]{
            if(is_method("INVITE"))
            {
                return(-1);
            };
            if(is_method("REGISTER"))
                return(1);
            }
            if(is_method("SUBSCRIBE"))
                return(2);
            }
            if(is_method("NOTIFY"))
                return(3);
            }
            return(-2);
        }

NOTE: take care while using `return` - `return(0)` stops the execution
of the script.

# 3. while

while statement

Example of usage:

      $var(i) = 0;
      while($var(i) < 10)
      {
          xlog("counter: $var(i)\n");
          $var(i) = $var(i) + 1;
      }



# 4. Script Operations

Assignments together with string and arithmetic operations can be done
directly in configuration file.

## 4.1. Assignment

Assignments can be done like in C, via `=` (equal). The following
pseudo-variables can be used in left side of an assignment:

- Unordered List Item AVPs - to set the value of an AVP
- script variables `($var(...))` - to set the value of a script variable
- shared variables (`$shv(...)`)
- `$ru` - to set R-URI
- `$rd` - to set domain part of R-URI
- `$rU` - to set user part of R-URI
- `$rp` - to set the port of R-URI
- `$du` - to set dst URI
- `$fs` - to set send socket
- `$br` - to set branch
- `$mf` - to set message flags value
- `$sf` - to set script flags value
- `$bf` - to set branch flags value

<!-- -->

    $var(a) = 123;

For avp's there a way to remove all values and assign a single value in
one statement (in other words, delete existing AVPs with same name, add
a new one with the right side value). This replaces the `:=` assignment
operator from kamailio `< 3.0`.

    $(avp(i:3)[*]) = 123;
    $(avp(i:3)[*]) = $null;

## 4.2. String Operations

For strings, `+` is available to concatenate.

    $var(a) = "test";
    $var(b) = "sip:" + $var(a) + "@" + $fd;

## 4.3. Arithmetic Operations

For numbers, one can use:

- `+` : plus
- `-` : minus
- `/` : divide
- `*` : multiply
- `%` : modulo (Kamailio uses `mod` instead of `%`)
- `|` : bitwise OR
- `&` : bitwise AND
- `^` : bitwise XOR
- `~` : bitwise NOT
- `<<` : bitwise left shift
- `>>` : bitwise right shift

Example:

    $var(a) = 4 + ( 7 & ( ~2 ) );

NOTE: to ensure the priority of operands in expression evaluations do
use <u>parenthesis</u>.

Arithmetic expressions can be used in condition expressions.

    if( $var(a) & 4 )
        log("var a has third bit set\n");

# 5. Operators

1. type casts operators: `(int)`, `(str)`.
2. string comparison: `eq`, `ne`
3. integer comparison: `ieq`, `ine`

Note: The names are not yet final (use them at your own risk). Future
version might use `==`/`!=` only for ints (`ieq/ine`) and `eq/ne` for strings
(under debate). They are almost equivalent to `==` or `!=`, but they force
the conversion of their operands (`eq` to string and `ieq` to int), allowing
among other things better type checking on startup and more
optimizations.

Non equiv. examples:

`0 == ""` (true) is not equivalent to `0 eq ""` (false: it evaluates to `"0" eq ""`).

`"a" ieq "b"` (true: `(int)"a" is 0` and `(int)"b" is 0`) is not equivalent to `"a" == "b"` (false).

Note: internally `==` and `!=` are converted on startup to `eq/ne/ieq/ine`
whenever possible (both operand types can be safely determined at start
time and they are the same).

1. Kamailio tries to guess what the user wanted when operators that
    support multiple types are used on different typed operands. In
    general convert the right operand to the type of the left operand
    and then perform the operation. Exception: the left operand is
    undef. This applies to the following operators: `+`, `==` and `!=`.

<!-- -->

       Special case: undef as left operand:
       For +: undef + expr -> undef is converted to string => "" + expr.
       For == and !=:   undef == expr -> undef is converted to type_of expr.
       If expr is undef, then undef == undef is true (internally is converted
       to string).

1. expression evaluation changes: Kamailio will auto-convert to integer
    or string in function of the operators:

<!-- -->

         int(undef)==0,  int("")==0, int("123")==123, int("abc")==0
         str(undef)=="", str(123)=="123".

1. script operators for dealing with empty/undefined variables

<!-- -->

        defined expr - returns true if expr is defined, and false if not.
                       Note: only a standalone avp or pvar can be
                       undefined, everything else is defined.
        strlen(expr) - returns the lenght of expr evaluated as string.
        strempty(expr) - returns true if expr evaluates to the empty
                         string (equivalent to expr=="").
        Example: if (defined $v && !strempty($v)) $len=strlen($v);