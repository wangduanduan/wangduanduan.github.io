---
title: "nom 学习笔记 Ch1"
date: "2025-10-20 22:37:17"
draft: false
type: posts
tags:
- all
categories:
- all
---

# 环境说明

- rust版本 1.87.0
- cargo版本 1.87.0
- nom版本 8.0.0

# 解析逻辑

1. 输入一个字符串
2. 创建一个解析器
3. 解析器调用parse方法
4. 如果解析成功，返回结果，结果包含两部分内容，前者是没有匹配的内容，后者是匹配到的内容

![](./arch.drawio.png)

# 举例

## 例1 空解析

这个例子描述了如何使用nom解析一个字符串。
输入是候输入字符串为my_input，匹配到的内容是空字符串，没有匹配到的是my_input。

```rust
use nom::IResult;
use std::error::Error;

pub fn do_nothing_parser(input: &str) -> IResult<&str, &str> {
    Ok((input, ""))
}

fn main() -> Result<(), Box<dyn Error>> {
    let (remaining_input, output) = do_nothing_parser("my_input")?;
    assert_eq!(remaining_input, "my_input");
    assert_eq!(output, "");
    Ok(())
}
```

## 例2 字符串匹配


```rust

pub use nom::bytes::complete::tag;
pub use nom::IResult;
use std::error::Error;

fn parse_input(input: &str) -> IResult<&str, &str> {
    // tag 函数的返回结果也是一个函数
    tag("Call-ID:")(input)
}

fn main() -> Result<(), Box<dyn Error>> {
    let (leftover_input, output) = parse_input("Call-ID: helloWorld")?;
    assert_eq!(leftover_input, " helloWorld"); // tag 函数匹配成功后返回剩余的输入
    assert_eq!(output, "Call-ID:"); // tag 函数匹配成功返回匹配的内容

    assert!(parse_input("defWorld").is_err());
  Ok(())
}
```

## 例3 预定义匹配类型

- **alpha0**: 识别0个或者多个大小写字符: /[a-zA-Z]/. 
    - **alpha1**: 和前者相同，并且至少返回一个字符
- **alphanumeric0**: 识别0个或者多个大小写字符和数字: /[0-9a-zA-Z]/. 
    - **alphanumeric1** 和前者相同，并且至少返回一个字符
- **digit0**:识别0个或者多个数字: /[0-9]/. 
    - **digit1** 和前者相同，并且至少返回一数字
- **multispace0**: 识别0个或者多个空格, 制表, 会车和换行符
    - **multispace1** 和前者相同，并且至少返回一数字
- **space0**: 识别0个或者多个空格和制表符. 
    - **space1** 和前者相同，并且至少返回一数字
- **line_ending**: 识别行尾 (`\n` and `\r\n`)
- **newline**: 匹配换行符 `\n`
- **tab**: 匹配制表符 `\t`

```rust

use nom::character::complete::alpha0;
pub use nom::IResult;
use std::error::Error;

fn parse_input(input: &str) -> IResult<&str, &str> {
    // tag 函数的返回结果也是一个函数
    alpha0(input)
}

fn main() -> Result<(), Box<dyn Error>> {
    let (leftover_input, output) = parse_input("Call-ID: helloWorld")?;
    assert_eq!(leftover_input, "-ID: helloWorld"); // tag 函数匹配成功后返回剩余的输入
    assert_eq!(output, "Call"); // tag 函数匹配成功返回匹配的内容

    assert!(parse_input("defWorld").is_ok());
  Ok(())
}
```


# 参考
- https://tfpk.github.io/nominomicon/chapter_2.html