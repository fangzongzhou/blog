---
title: jcmd
categories:
  - Java
  - JVM
tags:
  - JVM
date: 2020-11-06 10:18:37
---

可以用它来导出堆、查看Java进程、导出线程信息、执行GC、还可以进行采样分析

## 查看进程

命令:`jcmd -l`,等价于`jcmd`,`jps`

## 查看性能统计

`jcmd pid PerfCounter.print`


<!--more-->