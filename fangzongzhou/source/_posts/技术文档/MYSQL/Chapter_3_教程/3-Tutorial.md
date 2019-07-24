---
title: 3-Tutorial
date: 2019-05-14 18:19:48
categories:
tags:
---

本章通过演示如何通过mysql客户端程序创建并使用一个简单的数据库来介绍MySQL，mysql是一个可以连接MySQL服务，执行查询，并能展示结果的交互程序。mysql可以使用批量模式：先将查询放置在文件中，然后告诉mysql执行包含在文件中的命令。这两种使用mysql的方式都会有相应示例。

可以添加`--help`选项来列出mysql提供的选项
```
mysql --help
```

本章假定`mysql`已经安装在你的机器上，并且你可以连接到一个MySQL服务．如果不能连接，请联系你的MySQL服务administrator(如果你就是administrator,你可以参照[MySQL Server Administrator](https://dev.mysql.com/doc/refman/5.7/en/server-administration.html)中的相关部分)

本章介绍了设置使用数据库的所有过程,如果你只对访问已经存在的数据库感兴趣,你可以跳过那些描述如何创建数据库和表的部分.

本章的本质是教程,因此会省略很多细节.这里涉及的相关主题可以参阅手册的其他相关章节.

## 3.1 与服务建立/断开连接

为了连接服务,通常需要在调用时提供MySQL用户名,密码.如果服务所在的机器不在你当前登录的机器,还需要指定hostname.可以联系administrator来获取用来创建连接需要的连接参数(host,username,password).一旦你知道了正确的参数,你可以像这样建立连接:
```
mysql -h host -u user -p
```
host表示你的MySQL服务运行机器的主机名,user表示你的MySQL账号的用户名.

如果连接成功,你将看到一个`mysql>`提示符结束的提示信息

```
mysql>
```
`mysql>` 提示符提示你mysql准备好处理你输入的SQL语法

如果你所登录的机器和服务提供的机器一样,你可以像下边这样省略host
```
mysql -u user -p
```

如果你尝试登录,获取到错误信息 例如 `ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)` 表示MySQL服务当前没有运行.联系administrator或参照[Installing and Upgrading MySQL](https://dev.mysql.com/doc/refman/5.7/en/installing.html)

其他登录时常遇到的问题请参见[Common Errors When Using MySQL Programs](https://dev.mysql.com/doc/refman/5.7/en/common-errors.html)

一些MySQL安装允许在本地通过未命名用户连接,如果你的机器也使用了该配置,可以通过调用未带任何参数的mysql命令连接本地服务
```
mysql
```

当你成功连接后,你可以通过`QUIT`命令在任何时机断开连接
```
QUIT
```
在Unix中,你也可以通过`Control+D`来断开连接.

后续章节中的例子假定你已经成功连接服务.
