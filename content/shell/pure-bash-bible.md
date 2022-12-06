---
title: 'pure-bash-bible'
date: '2019-12-26 13:46:31'
draft: false
---

# 字符串

## 字符串包含

**Using a test:**

```shell
if [[ $var == *sub_string* ]]; then
    printf '%s\n' "sub_string is in var."
fi

# Inverse (substring not in string).
if [[ $var != *sub_string* ]]; then
    printf '%s\n' "sub_string is not in var."
fi

# This works for arrays too!
if [[ ${arr[*]} == *sub_string* ]]; then
    printf '%s\n' "sub_string is in array."
fi
```

**Using a case statement:**

```shell
case "$var" in
    *sub_string*)
        # Do stuff
    ;;

    *sub_string2*)
        # Do more stuff
    ;;

    *)
        # Else
    ;;
esac
```

## 字符串开始

```shell
if [[ $var == sub_string* ]]; then
    printf '%s\n' "var starts with sub_string."
fi

# Inverse (var does not start with sub_string).
if [[ $var != sub_string* ]]; then
    printf '%s\n' "var does not start with sub_string."
fi
```

## 字符串结尾

```shell
if [[ $var == *sub_string ]]; then
    printf '%s\n' "var ends with sub_string."
fi

# Inverse (var does not end with sub_string).
if [[ $var != *sub_string ]]; then
    printf '%s\n' "var does not end with sub_string."
fi
```

# 循环

## 数字范围循环

Alternative to `seq`.

```shell
# Loop from 0-100 (no variable support).
for i in {0..100}; do
    printf '%s\n' "$i"
done
```

## 变量循环

Alternative to `seq`.

```shell
# Loop from 0-VAR.
VAR=50
for ((i=0;i<=VAR;i++)); do
    printf '%s\n' "$i"
done
```

## 数组遍历

```shell
arr=(apples oranges tomatoes)

# Just elements.
for element in "${arr[@]}"; do
    printf '%s\n' "$element"
done
```

## 索引遍历

```shell
arr=(apples oranges tomatoes)

# Elements and index.
for i in "${!arr[@]}"; do
    printf '%s\n' "${arr[i]}"
done

# Alternative method.
for ((i=0;i<${#arr[@]};i++)); do
    printf '%s\n' "${arr[i]}"
done
```

## 文件或者目录遍历

Don’t use `ls`.

```shell
# Greedy example.
for file in *; do
    printf '%s\n' "$file"
done

# PNG files in dir.
for file in ~/Pictures/*.png; do
    printf '%s\n' "$file"
done

# Iterate over directories.
for dir in ~/Downloads/*/; do
    printf '%s\n' "$dir"
done

# Brace Expansion.
for file in /path/to/parentdir/{file1,file2,subdir/file3}; do
    printf '%s\n' "$file"
done

# Iterate recursively.
shopt -s globstar
for file in ~/Pictures/**/*; do
    printf '%s\n' "$file"
done
shopt -u globstar
```

#

# 文件处理

**CAVEAT:** `bash` does not handle binary data properly in versions `< 4.4`.

## 将文件读取为字符串

Alternative to the `cat` command.

```shell
file_data="$(<"file")"
```

## 将文件按行读取成数组

Alternative to the `cat` command.

```shell
# Bash <4 (discarding empty lines).
IFS=$'\n' read -d "" -ra file_data < "file"

# Bash <4 (preserving empty lines).
while read -r line; do
    file_data+=("$line")
done < "file"

# Bash 4+
mapfile -t file_data < "file"
```

## 获取文件头部的 N 行

Alternative to the `head` command.

**CAVEAT:** Requires `bash` 4+

**Example Function:**

```sh
head() {
    # Usage: head "n" "file"
    mapfile -tn "$1" line < "$2"
    printf '%s\n' "${line[@]}"
}
```

**Example Usage:**

```shell
$ head 2 ~/.bashrc
# Prompt
PS1='➜ '

$ head 1 ~/.bashrc
# Prompt
```

## 获取尾部 N 行

Alternative to the `tail` command.

**CAVEAT:** Requires `bash` 4+

**Example Function:**

```sh
tail() {
    # Usage: tail "n" "file"
    mapfile -tn 0 line < "$2"
    printf '%s\n' "${line[@]: -$1}"
}
```

**Example Usage:**

```shell
$ tail 2 ~/.bashrc
# Enable tmux.
# [[ -z "$TMUX"  ]] && exec tmux

$ tail 1 ~/.bashrc
# [[ -z "$TMUX"  ]] && exec tmux
```

## 获取文件行数

Alternative to `wc -l`.

**Example Function (bash 4):**

```sh
lines() {
    # Usage: lines "file"
    mapfile -tn 0 lines < "$1"
    printf '%s\n' "${#lines[@]}"
}
```

**Example Function (bash 3):**

This method uses less memory than the `mapfile` method and works in `bash` 3 but it is slower for bigger files.

```sh
lines_loop() {
    # Usage: lines_loop "file"
    count=0
    while IFS= read -r _; do
        ((count++))
    done < "$1"
    printf '%s\n' "$count"
}
```

**Example Usage:**

```shell
$ lines ~/.bashrc
48

$ lines_loop ~/.bashrc
48
```

## 计算文件或者文件夹数量

This works by passing the output of the glob to the function and then counting the number of arguments.

**Example Function:**

```sh
count() {
    # Usage: count /path/to/dir/*
    #        count /path/to/dir/*/
    printf '%s\n' "$#"
}
```

**Example Usage:**

```shell
# Count all files in dir.
$ count ~/Downloads/*
232

# Count all dirs in dir.
$ count ~/Downloads/*/
45

# Count all jpg files in dir.
$ count ~/Pictures/*.jpg
64
```

## 创建临时文件

Alternative to `touch`.

```shell
# Shortest.
>file

# Longer alternatives:
:>file
echo -n >file
printf '' >file
```

## 在两个标记之间抽取 N 行

**Example Function:**

```sh
extract() {
    # Usage: extract file "opening marker" "closing marker"
    while IFS=$'\n' read -r line; do
        [[ $extract && $line != "$3" ]] &&
            printf '%s\n' "$line"

        [[ $line == "$2" ]] && extract=1
        [[ $line == "$3" ]] && extract=
    done < "$1"
}
```

**Example Usage:**

````shell
# Extract code blocks from MarkDown file.
$ extract ~/projects/pure-bash/README.md '```sh' '```'
# Output here...
````

#

# 文件路径

## 获取文件的目录

Alternative to the `dirname` command.

**Example Function:**

```sh
dirname() {
    # Usage: dirname "path"
    local tmp=${1:-.}

    [[ $tmp != *[!/]* ]] && {
        printf '/\n'
        return
    }

    tmp=${tmp%%"${tmp##*[!/]}"}

    [[ $tmp != */* ]] && {
        printf '.\n'
        return
    }

    tmp=${tmp%/*}
    tmp=${tmp%%"${tmp##*[!/]}"}

    printf '%s\n' "${tmp:-/}"
}
```

**Example Usage:**

```shell
$ dirname ~/Pictures/Wallpapers/1.jpg
/home/black/Pictures/Wallpapers

$ dirname ~/Pictures/Downloads/
/home/black/Pictures
```

## 获取文件路径的 base-name

Alternative to the `basename` command.

**Example Function:**

```sh
basename() {
    # Usage: basename "path" ["suffix"]
    local tmp

    tmp=${1%"${1##*[!/]}"}
    tmp=${tmp##*/}
    tmp=${tmp%"${2/"$tmp"}"}

    printf '%s\n' "${tmp:-/}"
}
```

**Example Usage:**

```shell
$ basename ~/Pictures/Wallpapers/1.jpg
1.jpg

$ basename ~/Pictures/Wallpapers/1.jpg .jpg
1

$ basename ~/Pictures/Downloads/
Downloads
```

# 变量

## 变量声明和使用

```shell
$ hello_world="value"

# Create the variable name.
$ var="world"
$ ref="hello_$var"

# Print the value of the variable name stored in 'hello_$var'.
$ printf '%s\n' "${!ref}"
value
```

Alternatively, on `bash` 4.3+:

```shell
$ hello_world="value"
$ var="world"

# Declare a nameref.
$ declare -n ref=hello_$var

$ printf '%s\n' "$ref"
value
```

## 基于变量命名变量

```shell
$ var="world"
$ declare "hello_$var=value"
$ printf '%s\n' "$hello_world"
value
```

#

# ESCAPE SEQUENCES

Contrary to popular belief, there is no issue in utilizing raw escape sequences. Using `tput` abstracts the same ANSI sequences as if printed manually. Worse still, `tput` is not actually portable. There are a number of `tput` variants each with different commands and syntaxes (_try `tput setaf 3` on a FreeBSD system_). Raw sequences are fine.

## 文本颜色

**NOTE:** Sequences requiring RGB values only work in True-Color Terminal Emulators.

| Sequence               | What does it do?                        | Value         |
| ---------------------- | --------------------------------------- | ------------- |
| `\e[38;5;<NUM>m`       | Set text foreground color.              | `0-255`       |
| `\e[48;5;<NUM>m`       | Set text background color.              | `0-255`       |
| `\e[38;2;<R>;<G>;<B>m` | Set text foreground color to RGB color. | `R`, `G`, `B` |
| `\e[48;2;<R>;<G>;<B>m` | Set text background color to RGB color. | `R`, `G`, `B` |

## 文本属性

**NOTE:** Prepend 2 to any code below to turn it's effect off<br />(examples: 21=bold text off, 22=faint text off, 23=italic text off).

| Sequence | What does it do?                  |
| -------- | --------------------------------- |
| `\e[m`   | Reset text formatting and colors. |
| `\e[1m`  | Bold text.                        |
| `\e[2m`  | Faint text.                       |
| `\e[3m`  | Italic text.                      |
| `\e[4m`  | Underline text.                   |
| `\e[5m`  | Blinking text.                    |
| `\e[7m`  | Highlighted text.                 |
| `\e[8m`  | Hidden text.                      |
| `\e[9m`  | Strike-through text.              |

## 光标移动

| Sequence              | What does it do?                      | Value            |
| --------------------- | ------------------------------------- | ---------------- |
| `\e[<LINE>;<COLUMN>H` | Move cursor to absolute position.     | `line`, `column` |
| `\e[H`                | Move cursor to home position (`0,0`). |                  |
| `\e[<NUM>A`           | Move cursor up N lines.               | `num`            |
| `\e[<NUM>B`           | Move cursor down N lines.             | `num`            |
| `\e[<NUM>C`           | Move cursor right N columns.          | `num`            |
| `\e[<NUM>D`           | Move cursor left N columns.           | `num`            |
| `\e[s`                | Save cursor position.                 |                  |
| `\e[u`                | Restore cursor position.              |                  |

## 文本擦除

| Sequence    | What does it do?                                         |
| ----------- | -------------------------------------------------------- |
| `\e[K`      | Erase from cursor position to end of line.               |
| `\e[1K`     | Erase from cursor position to start of line.             |
| `\e[2K`     | Erase the entire current line.                           |
| `\e[J`      | Erase from the current line to the bottom of the screen. |
| `\e[1J`     | Erase from the current line to the top of the screen.    |
| `\e[2J`     | Clear the screen.                                        |
| `\e[2J\e[H` | Clear the screen and move cursor to `0,0`.               |

#

# 参数展开

## 指令

| Parameter  | What does it do?                                                                                                                       |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| `${!VAR}`  | Access a variable based on the value of `VAR`.                                                                                         |
| `${!VAR*}` | Expand to `IFS` separated list of variable names starting with `VAR`.                                                                  |
| `${!VAR@}` | Expand to `IFS` separated list of variable names starting with `VAR`. If double-quoted, each variable name expands to a separate word. |

## 替换

| Parameter                 | What does it do?                                       |
| ------------------------- | ------------------------------------------------------ |
| `${VAR#PATTERN}`          | Remove shortest match of pattern from start of string. |
| `${VAR##PATTERN}`         | Remove longest match of pattern from start of string.  |
| `${VAR%PATTERN}`          | Remove shortest match of pattern from end of string.   |
| `${VAR%%PATTERN}`         | Remove longest match of pattern from end of string.    |
| `${VAR/PATTERN/REPLACE}`  | Replace first match with string.                       |
| `${VAR//PATTERN/REPLACE}` | Replace all matches with string.                       |
| `${VAR/PATTERN}`          | Remove first match.                                    |
| `${VAR//PATTERN}`         | Remove all matches.                                    |

## 长度

| Parameter    | What does it do?             |
| ------------ | ---------------------------- |
| `${#VAR}`    | Length of var in characters. |
| `${#ARR[@]}` | Length of array in elements. |

## 展开

| Parameter               | What does it do?                                                                                                       |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `${VAR:OFFSET}`         | Remove first `N` chars from variable.                                                                                  |
| `${VAR:OFFSET:LENGTH}`  | Get substring from `N` character to `N` character. <br /> (`${VAR:10:10}`: Get sub-string from char `10` to char `20`) |
| `${VAR:: OFFSET}`       | Get first `N` chars from variable.                                                                                     |
| `${VAR:: -OFFSET}`      | Remove last `N` chars from variable.                                                                                   |
| `${VAR: -OFFSET}`       | Get last `N` chars from variable.                                                                                      |
| `${VAR:OFFSET:-OFFSET}` | Cut first `N` chars and last `N` chars.                                                                                |

## 大小写修改

| Parameter  | What does it do?                 | CAVEAT    |
| ---------- | -------------------------------- | --------- |
| `${VAR^}`  | Uppercase first character.       | `bash 4+` |
| `${VAR^^}` | Uppercase all characters.        | `bash 4+` |
| `${VAR,}`  | Lowercase first character.       | `bash 4+` |
| `${VAR,,}` | Lowercase all characters.        | `bash 4+` |
| `${VAR~}`  | Reverse case of first character. | `bash 4+` |
| `${VAR~~}` | Reverse case of all characters.  | `bash 4+` |

## 默认值

| Parameter        | What does it do?                                                |
| ---------------- | --------------------------------------------------------------- |
| `${VAR:-STRING}` | If `VAR` is empty or unset, use `STRING` as its value.          |
| `${VAR-STRING}`  | If `VAR` is unset, use `STRING` as its value.                   |
| `${VAR:=STRING}` | If `VAR` is empty or unset, set the value of `VAR` to `STRING`. |
| `${VAR=STRING}`  | If `VAR` is unset, set the value of `VAR` to `STRING`.          |
| `${VAR:+STRING}` | If `VAR` is not empty, use `STRING` as its value.               |
| `${VAR+STRING}`  | If `VAR` is set, use `STRING` as its value.                     |
| `${VAR:?STRING}` | Display an error if empty or unset.                             |
| `${VAR?STRING}`  | Display an error if unset.                                      |

#

# 大括号展开

## 范围

```shell
# Syntax: {<START>..<END>}

# Print numbers 1-100.
echo {1..100}

# Print range of floats.
echo 1.{1..9}

# Print chars a-z.
echo {a..z}
echo {A..Z}

# Nesting.
echo {A..Z}{0..9}

# Print zero-padded numbers.
# CAVEAT: bash 4+
echo {01..100}

# Change increment amount.
# Syntax: {<START>..<END>..<INCREMENT>}
# CAVEAT: bash 4+
echo {1..10..2} # Increment by 2.
```

## 字符串列表

```shell
echo {apples,oranges,pears,grapes}

# Example Usage:
# Remove dirs Movies, Music and ISOS from ~/Downloads/.
rm -rf ~/Downloads/{Movies,Music,ISOS}
```

#

# 条件表达式

## 文件条件判断

| Expression | Value  | What does it do?                                       |
| ---------- | ------ | ------------------------------------------------------ |
| `-a`       | `file` | If file exists.                                        |
| `-b`       | `file` | If file exists and is a block special file.            |
| `-c`       | `file` | If file exists and is a character special file.        |
| `-d`       | `file` | If file exists and is a directory.                     |
| `-e`       | `file` | If file exists.                                        |
| `-f`       | `file` | If file exists and is a regular file.                  |
| `-g`       | `file` | If file exists and its set-group-id bit is set.        |
| `-h`       | `file` | If file exists and is a symbolic link.                 |
| `-k`       | `file` | If file exists and its sticky-bit is set               |
| `-p`       | `file` | If file exists and is a named pipe (_FIFO_).           |
| `-r`       | `file` | If file exists and is readable.                        |
| `-s`       | `file` | If file exists and its size is greater than zero.      |
| `-t`       | `fd`   | If file descriptor is open and refers to a terminal.   |
| `-u`       | `file` | If file exists and its set-user-id bit is set.         |
| `-w`       | `file` | If file exists and is writable.                        |
| `-x`       | `file` | If file exists and is executable.                      |
| `-G`       | `file` | If file exists and is owned by the effective group ID. |
| `-L`       | `file` | If file exists and is a symbolic link.                 |
| `-N`       | `file` | If file exists and has been modified since last read.  |
| `-O`       | `file` | If file exists and is owned by the effective user ID.  |
| `-S`       | `file` | If file exists and is a socket.                        |

## 文件比较

| Expression       | What does it do?                                                                                  |
| ---------------- | ------------------------------------------------------------------------------------------------- |
| `file -ef file2` | If both files refer to the same inode and device numbers.                                         |
| `file -nt file2` | If `file` is newer than `file2` (_uses modification time_) or `file` exists and `file2` does not. |
| `file -ot file2` | If `file` is older than `file2` (_uses modification time_) or `file2` exists and `file` does not. |

## 变量测试

| Expression | Value | What does it do?                     |
| ---------- | ----- | ------------------------------------ |
| `-o`       | `opt` | If shell option is enabled.          |
| `-v`       | `var` | If variable has a value assigned.    |
| `-R`       | `var` | If variable is a name reference.     |
| `-z`       | `var` | If the length of string is zero.     |
| `-n`       | `var` | If the length of string is non-zero. |

## 变量比较

| Expression    | What does it do?                              |
| ------------- | --------------------------------------------- |
| `var = var2`  | Equal to.                                     |
| `var == var2` | Equal to (_synonym for `=`_).                 |
| `var != var2` | Not equal to.                                 |
| `var < var2`  | Less than (_in ASCII alphabetical order._)    |
| `var > var2`  | Greater than (_in ASCII alphabetical order._) |

#

# 算数操作

## 赋值

| Operators | What does it do?                              |
| --------- | --------------------------------------------- |
| `=`       | Initialize or change the value of a variable. |

## 算数

| Operators | What does it do?                                |
| --------- | ----------------------------------------------- |
| `+`       | Addition                                        |
| `-`       | Subtraction                                     |
| `*`       | Multiplication                                  |
| `/`       | Division                                        |
| `**`      | Exponentiation                                  |
| `%`       | Modulo                                          |
| `+=`      | Plus-Equal (_Increment a variable._)            |
| `-=`      | Minus-Equal (_Decrement a variable._)           |
| `*=`      | Times-Equal (_Multiply a variable._)            |
| `/=`      | Slash-Equal (_Divide a variable._)              |
| `%=`      | Mod-Equal (_Remainder of dividing a variable._) |

## 位操作

| Operators | What does it do?    |
| --------- | ------------------- |
| `<<`      | Bitwise Left Shift  |
| `<<=`     | Left-Shift-Equal    |
| `>>`      | Bitwise Right Shift |
| `>>=`     | Right-Shift-Equal   |
| `&`       | Bitwise AND         |
| `&=`      | Bitwise AND-Equal   |
| `\|`      | Bitwise OR          |
| `\|=`     | Bitwise OR-Equal    |
| `~`       | Bitwise NOT         |
| `^`       | Bitwise XOR         |
| `^=`      | Bitwise XOR-Equal   |

## 逻辑

| Operators | What does it do? |
| --------- | ---------------- |
| `!`       | NOT              |
| `&&`      | AND              |
| `\|\|`    | OR               |

## Miscellaneous

| Operators | What does it do? | Example           |
| --------- | ---------------- | ----------------- |
| `,`       | Comma Separator  | `((a=1,b=2,c=3))` |

#

# ARITHMETIC

## Simpler syntax to set variables

```shell
# Simple math
((var=1+2))

# Decrement/Increment variable
((var++))
((var--))
((var+=1))
((var-=1))

# Using variables
((var=var2*arr[2]))
```

## Ternary Tests

```shell
# Set the value of var to var2 if var2 is greater than var.
# var: variable to set.
# var2>var: Condition to test.
# ?var2: If the test succeeds.
# :var: If the test fails.
((var=var2>var?var2:var))
```

# TRAPS

Traps allow a script to execute code on various signals. In [pxltrm](https://github.com/dylanaraps/pxltrm) (_a pixel art editor written in bash_)  traps are used to redraw the user interface on window resize. Another use case is cleaning up temporary files on script exit.

Traps should be added near the start of scripts so any early errors are also caught.

**NOTE:** For a full list of signals, see `trap -l`.

## Do something on script exit

```shell
# Clear screen on script exit.
trap 'printf \\e[2J\\e[H\\e[m' EXIT
```

## Ignore terminal interrupt (CTRL+C, SIGINT)

```shell
trap '' INT
```

## React to window resize

```shell
# Call a function on window resize.
trap 'code_here' SIGWINCH
```

## Do something before every command

```shell
trap 'code_here' DEBUG
```

## Do something when a shell function or a sourced file finishes executing

```shell
trap 'code_here' RETURN
```

# PERFORMANCE

## Disable Unicode

If unicode is not required, it can be disabled for a performance increase. Results may vary however there have been noticeable improvements in [neofetch](https://github.com/dylanaraps/neofetch) and other programs.

```shell
# Disable unicode.
LC_ALL=C
LANG=C
```

# OBSOLETE SYNTAX

## Shebang

Use `#!/usr/bin/env bash` instead of `#!/bin/bash`.

-   The former searches the user's `PATH` to find the `bash` binary.
-   The latter assumes it is always installed to `/bin/` which can cause issues.

**NOTE**: There are times when one may have a good reason for using `#!/bin/bash` or another direct path to the binary.

```shell
# Right:

    #!/usr/bin/env bash

# Less right:

    #!/bin/bash
```

## Command Substitution

Use `$()` instead of ` `.

```shell
# Right.
var="$(command)"

# Wrong.
var=`command`

# $() can easily be nested whereas `` cannot.
var="$(command "$(command)")"
```

## Function Declaration

Do not use the `function` keyword, it reduces compatibility with older versions of `bash`.

```shell
# Right.
do_something() {
    # ...
}

# Wrong.
function do_something() {
    # ...
}
```

# INTERNAL VARIABLES

## Get the location to the `bash` binary

```shell
"$BASH"
```

## Get the version of the current running `bash` process

```shell
# As a string.
"$BASH_VERSION"

# As an array.
"${BASH_VERSINFO[@]}"
```

## Open the user's preferred text editor

```shell
"$EDITOR" "$file"

# NOTE: This variable may be empty, set a fallback value.
"${EDITOR:-vi}" "$file"
```

## Get the name of the current function

```shell
# Current function.
"${FUNCNAME[0]}"

# Parent function.
"${FUNCNAME[1]}"

# So on and so forth.
"${FUNCNAME[2]}"
"${FUNCNAME[3]}"

# All functions including parents.
"${FUNCNAME[@]}"
```

## Get the host-name of the system

```shell
"$HOSTNAME"

# NOTE: This variable may be empty.
# Optionally set a fallback to the hostname command.
"${HOSTNAME:-$(hostname)}"
```

## Get the architecture of the Operating System

```shell
"$HOSTTYPE"
```

## Get the name of the Operating System / Kernel

This can be used to add conditional support for different Operating<br />Systems without needing to call `uname`.

```shell
"$OSTYPE"
```

## Get the current working directory

This is an alternative to the `pwd` built-in.

```shell
"$PWD"
```

## Get the number of seconds the script has been running

```shell
"$SECONDS"
```

## Get a pseudorandom integer

Each time `$RANDOM` is used, a different integer between `0` and `32767` is returned. This variable should not be used for anything related to security (_this includes encryption keys etc_).

```shell
"$RANDOM"
```

# INFORMATION ABOUT THE TERMINAL

## Get the terminal size in lines and columns (_from a script_)

This is handy when writing scripts in pure bash and `stty`/`tput` can’t be<br />called.

**Example Function:**

```sh
get_term_size() {
    # Usage: get_term_size

    # (:;:) is a micro sleep to ensure the variables are
    # exported immediately.
    shopt -s checkwinsize; (:;:)
    printf '%s\n' "$LINES $COLUMNS"
}
```

**Example Usage:**

```shell
# Output: LINES COLUMNS
$ get_term_size
15 55
```

## Get the terminal size in pixels

**CAVEAT**: This does not work in some terminal emulators.

**Example Function:**

```sh
get_window_size() {
    # Usage: get_window_size
    printf '%b' "${TMUX:+\\ePtmux;\\e}\\e[14t${TMUX:+\\e\\\\}"
    IFS=';t' read -d t -t 0.05 -sra term_size
    printf '%s\n' "${term_size[1]}x${term_size[2]}"
}
```

**Example Usage:**

```shell
# Output: WIDTHxHEIGHT
$ get_window_size
1200x800

# Output (fail):
$ get_window_size
x
```

## Get the current cursor position

This is useful when creating a TUI in pure bash.

**Example Function:**

```sh
get_cursor_pos() {
    # Usage: get_cursor_pos
    IFS='[;' read -p $'\e[6n' -d R -rs _ y x _
    printf '%s\n' "$x $y"
}
```

**Example Usage:**

```shell
# Output: X Y
$ get_cursor_pos
1 8
```

# CONVERSION

## Convert a hex color to RGB

**Example Function:**

```sh
hex_to_rgb() {
    # Usage: hex_to_rgb "#FFFFFF"
    #        hex_to_rgb "000000"
    : "${1/\#}"
    ((r=16#${_:0:2},g=16#${_:2:2},b=16#${_:4:2}))
    printf '%s\n' "$r $g $b"
}
```

**Example Usage:**

```shell
$ hex_to_rgb "#FFFFFF"
255 255 255
```

## Convert an RGB color to hex

**Example Function:**

```sh
rgb_to_hex() {
    # Usage: rgb_to_hex "r" "g" "b"
    printf '#%02x%02x%02x\n' "$1" "$2" "$3"
}
```

**Example Usage:**

```shell
$ rgb_to_hex "255" "255" "255"
#FFFFFF
```

# CODE GOLF

## Shorter `for` loop syntax

```shell
# Tiny C Style.
for((;i++<10;)){ echo "$i";}

# Undocumented method.
for i in {1..10};{ echo "$i";}

# Expansion.
for i in {1..10}; do echo "$i"; done

# C Style.
for((i=0;i<=10;i++)); do echo "$i"; done
```

## Shorter infinite loops

```shell
# Normal method
while :; do echo hi; done

# Shorter
for((;;)){ echo hi;}
```

## Shorter function declaration

```shell
# Normal method
f(){ echo hi;}

# Using a subshell
f()(echo hi)

# Using arithmetic
# This can be used to assign integer values.
# Example: f a=1
#          f a++
f()(($1))

# Using tests, loops etc.
# NOTE: ‘while’, ‘until’, ‘case’, ‘(())’, ‘[[]]’ can also be used.
f()if true; then echo "$1"; fi
f()for i in "$@"; do echo "$i"; done
```

## Shorter `if` syntax

```shell
# One line
# Note: The 3rd statement may run when the 1st is true
[[ $var == hello ]] && echo hi || echo bye
[[ $var == hello ]] && { echo hi; echo there; } || echo bye

# Multi line (no else, single statement)
# Note: The exit status may not be the same as with an if statement
[[ $var == hello ]] &&
    echo hi

# Multi line (no else)
[[ $var == hello ]] && {
    echo hi
    # ...
}
```

## Simpler `case` statement to set variable

The `:` built-in can be used to avoid repeating `variable=` in a case statement. The `$_` variable stores the last argument of the last command. `:` always succeeds so it can be used to store the variable value.

```shell
# Modified snippet from Neofetch.
case "$OSTYPE" in
    "darwin"*)
        : "MacOS"
    ;;

    "linux"*)
        : "Linux"
    ;;

    *"bsd"* | "dragonfly" | "bitrig")
        : "BSD"
    ;;

    "cygwin" | "msys" | "win32")
        : "Windows"
    ;;

    *)
        printf '%s\n' "Unknown OS detected, aborting..." >&2
        exit 1
    ;;
esac

# Finally, set the variable.
os="$_"
```

# OTHER

## Use `read` as an alternative to the `sleep` command

Surprisingly, `sleep` is an external command and not a `bash` built-in.

**CAVEAT:** Requires `bash` 4+

**Example Function:**

```sh
read_sleep() {
    # Usage: read_sleep 1
    #        read_sleep 0.2
    read -rt "$1" <> <(:) || :
}
```

**Example Usage:**

```shell
read_sleep 1
read_sleep 0.1
read_sleep 30
```

For performance-critical situations, where it is not economic to open and close an excessive number of file descriptors, the allocation of a file descriptor may be done only once for all invocations of `read`:

(See the generic original implementation at [https://blog.dhampir.no/content/sleeping-without-a-subprocess-in-bash-and-how-to-sleep-forever](https://blog.dhampir.no/content/sleeping-without-a-subprocess-in-bash-and-how-to-sleep-forever))

```shell
exec {sleep_fd}<> <(:)
while some_quick_test; do
    # equivalent of sleep 0.001
    read -t 0.001 -u $sleep_fd
done
```

## Check if a program is in the user's PATH

```shell
# There are 3 ways to do this and either one can be used.
type -p executable_name &>/dev/null
hash executable_name &>/dev/null
command -v executable_name &>/dev/null

# As a test.
if type -p executable_name &>/dev/null; then
    # Program is in PATH.
fi

# Inverse.
if ! type -p executable_name &>/dev/null; then
    # Program is not in PATH.
fi

# Example (Exit early if program is not installed).
if ! type -p convert &>/dev/null; then
    printf '%s\n' "error: convert is not installed, exiting..."
    exit 1
fi
```

## Get the current date using `strftime`

Bash’s `printf` has a built-in method of getting the date which can be used in place of the `date` command.

**CAVEAT:** Requires `bash` 4+

**Example Function:**

```sh
date() {
    # Usage: date "format"
    # See: 'man strftime' for format.
    printf "%($1)T\\n" "-1"
}
```

**Example Usage:**

```shell
# Using above function.
$ date "%a %d %b  - %l:%M %p"
Fri 15 Jun  - 10:00 AM

# Using printf directly.
$ printf '%(%a %d %b  - %l:%M %p)T\n' "-1"
Fri 15 Jun  - 10:00 AM

# Assigning a variable using printf.
$ printf -v date '%(%a %d %b  - %l:%M %p)T\n' '-1'
$ printf '%s\n' "$date"
Fri 15 Jun  - 10:00 AM
```

## Get the username of the current user

**CAVEAT:** Requires `bash` 4.4+

```shell
$ : \\u
# Expand the parameter as if it were a prompt string.
$ printf '%s\n' "${_@P}"
black
```

## Generate a UUID V4

**CAVEAT**: The generated value is not cryptographically secure.

**Example Function:**

```sh
uuid() {
    # Usage: uuid
    C="89ab"

    for ((N=0;N<16;++N)); do
        B="$((RANDOM%256))"

        case "$N" in
            6)  printf '4%x' "$((B%16))" ;;
            8)  printf '%c%x' "${C:$RANDOM%${#C}:1}" "$((B%16))" ;;

            3|5|7|9)
                printf '%02x-' "$B"
            ;;

            *)
                printf '%02x' "$B"
            ;;
        esac
    done

    printf '\n'
}
```

**Example Usage:**

```shell
$ uuid
d5b6c731-1310-4c24-9fe3-55d556d44374
```

## Progress bars

This is a simple way of drawing progress bars without needing a for loop<br />in the function itself.

**Example Function:**

```sh
bar() {
    # Usage: bar 1 10
    #            ^----- Elapsed Percentage (0-100).
    #               ^-- Total length in chars.
    ((elapsed=$1*$2/100))

    # Create the bar with spaces.
    printf -v prog  "%${elapsed}s"
    printf -v total "%$(($2-elapsed))s"

    printf '%s\r' "[${prog// /-}${total}]"
}
```

**Example Usage:**

```shell
for ((i=0;i<=100;i++)); do
    # Pure bash micro sleeps (for the example).
    (:;:) && (:;:) && (:;:) && (:;:) && (:;:)

    # Print the bar.
    bar "$i" "10"
done

printf '\n'
```

## Get the list of functions in a script

```sh
get_functions() {
    # Usage: get_functions
    IFS=$'\n' read -d "" -ra functions < <(declare -F)
    printf '%s\n' "${functions[@]//declare -f }"
}
```

## Bypass shell aliases

```shell
# alias
ls

# command
# shellcheck disable=SC1001
\ls
```

## Bypass shell functions

```shell
# function
ls

# command
command ls
```

## 后台运行命令

This will run the given command and keep it running, even after the terminal or SSH connection is terminated. All output is ignored.

```sh
bkr() {
    (nohup "$@" &>/dev/null &)
}

bkr ./some_script.sh # some_script.sh is now running in the background
```

# AFTERWORD

Thanks for reading! If this bible helped you in any way and you'd like to give back, consider donating. Donations give me the time to make this the best resource possible. Can't donate? That's OK, star the repo and share it with your friends!

[![](https://img.shields.io/badge/donate-patreon-yellow.svg#align=left&display=inline&height=20&originHeight=20&originWidth=100&status=done&style=none&width=100)](https://www.patreon.com/dyla)
