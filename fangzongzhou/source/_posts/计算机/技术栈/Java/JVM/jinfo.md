---
title: jinfo
categories:
  - Java
  - JVM
tags:
  - JVM
date: 2020-11-06 11:21:18
---

全称Java Configuration Info. 主要作用是实时查看和调整JVM配置参数

## 查看JVM参数

用法：`jinfo -flag <name> PID`  例:`jinfo -flag ThreadStackSize 18348`，得到结果-XX:ThreadStackSize=256，即Xss为256K

## 调整JVM参数

用法：
如果是布尔类型的JVM参数: `jinfo -flag [+|-]<name> PID`，enable or disable the named VM flag

如果是数字/字符串类型的JVM参数 `jinfo -flag <name>=<value> PID`，to set the named VM flag to the given value

### 查看所有支持动态修改的JVM参数

`java -XX:+PrintFlagsInitial | grep manageable`
<!--more-->