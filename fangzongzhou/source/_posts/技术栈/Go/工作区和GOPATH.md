---
title: 工作区和GOPATH
date: 2018-08-10 22:07:12
categories:
tags:
- GO
---
## GOPATH是什么
是go的环境变量，可以是一个目录路径，也可以包含多个目录路径，每个目录都代表了一个workspace。

这些workspace用来存放go源码文件及install后的归档文件和可执行文件。go生命周期的所有操作都是围绕着GOPATH来进行的。go要使用外部代码，必须install源码到当前的workspace中。


## 源码组织方式
GO源码以代码包为基本组织单位。每个代码包都有导入路径，实际使用程序前，必须先导入其所在的代码包。
```
import "github.com/qwer/asdf"
```
<!--more-->
workspace中，一个代码包的导入路径实际上就是从 src 子目录，到该包的实际存储位置的相对路径。
