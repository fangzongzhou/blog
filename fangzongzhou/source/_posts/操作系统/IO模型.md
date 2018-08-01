---
title: IO模型
date: 2018-07-10 09:59:53
categories:
- 计算机
tags:
- 知识点
---
Linux下的系统调用recv ，用于从套接字上接收一个消息，调用时会从用户进程空间切换到内核空间运行一段时间再切换回来。







## 阻塞IO模型（bloking IO）
一直等数据直到拷贝到用户空间，这段时间内进程始终阻塞。这种方式是同步的。

## 同步非阻塞IO（non-blocking IO）
不管有没有数据都直接返回，防止进程阻塞，如果没有数据可用的情况过一段时间之后再进行尝试

## IO复用模型（multiplexing IO）


信号驱动式IO（signal-driven IO）

异步IO（asynchronous IO）
