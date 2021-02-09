---
title: redis
categories:
  - Redis
tags:
  - Redis
date: 2021-02-04 22:40:22
---

Redis是一个开源的使用ANSI C语言编写的,支持网络,可基于内存亦可持久化的日志型,Key-Value数据库.并提供多种语言API

Redis 是 REmote DIctionary Server(远程字典服务)的缩写.以字典结构存储数据,并允许其他应用通过TCP协议读写字典中的内容.

## 数据类型

- 字符串类型
- 散列类型
- 列表类型
- 集合类型
- 有序集合类型

## 应用层协议

RESP(Redis Serialization Protocol)协议: 基于TCP的应用层协议,底层采用TCP的连接方式,通过tcp进行数据传输,然后根据解析规则解析相应信息,完成交互.

RESP协议特点:

- 容易实现
- 解析快
- 人类可读

<!--more-->

| 文件名           | 说明               |
| ---------------- | ------------------ |
| redis-server     | Redis服务器        |
| redis-cli        | Redis命令行客户端  |
| redis-benchmark  | Redis 性能测试工具 |
| redis-check-AOF  | AOF文件修复工具    |
| redis-check-dump | RDB文件检查工具    |
| redis-sentinel   | Sentinel 服务器    |

