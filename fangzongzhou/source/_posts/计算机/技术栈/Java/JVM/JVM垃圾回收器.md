---
title: JVM垃圾回收器
categories:
  - Java
  - JVM
tags:
  - JVM
date: 2020-11-12 22:20:22
---
Java 虚拟机的垃圾回收器可以分为四大类别：串行回收器、并行回收器、CMS 回收器、G1 回收器

## 串行回收器

串行回收器进行垃圾回收时,会触发`Stop-The-World`现象

新生代串行回收器使用的是复制算法,老年代串行回收器使用的是标记压缩算法

若要启用老年代串行回收器，可以尝试以下参数

- `-XX:UseSerialGC`  新生代、老年代都使用串行回收器
- `-XX:UseParNewGC` 新生代使用 ParNew 回收器，老年代使用串行回收器
- `-XX:UseParallelGC` 新生代使用 ParallelGC 回收器，老年代使用串行回收器
<!--more-->

## 并行回收器

并行回收器在串行回收器的基础上做了改进，其使用多线程进行垃圾回收

根据作用内存区域的不同，并行回收器也有三个不同的回收器：新生代 ParNew 回收器、新生代 ParallelGC 回收器、老年代 ParallelGC 回收器

### 新生代 ParNew 回收器

只是简单地将串行回收器多线程化，其回收策略、算法以及参数和新生代串行回收器一样

要开启新生代 ParNew 回收器，可以使用以下参数

- `-XX:+UseParNewGC` 新生代使用 ParNew 回收器，老年代使用串行回收器
- `-XX:UseConcMarkSweepGC` 新生代使用 ParNew 回收器，老年代使用 CMS
- `-XX:ParallelGCThreads` 指定 ParNew 回收器的工作线程数量

### 新生代 Parallel GC 回收器

### 老年代 ParallelOldGC 回收器

## CMS 回收器

CMS 回收器主要关注系统停顿时间。CMS 回收器全称为 Concurrent Mark Sweep，意为标记清除算法，其是一个使用多线程并行回收的垃圾回收器

CMS 的主要工作步骤有：初始标记、并发标记、预清理、重新标记、并发清除和并发重置. 其中初始标记和重新标记是独占系统资源的，而其他阶段则可以和用户线程一起执行

启用CMS回收器可以使用参数 `-XX:+UseConcMarkSweepGC` ,线程并发数可以通过`-XX:ConcGCThreads`或`XX:ParallelCMSThreads` 设定. 还可以设置`-XX:CMSInitiatingOccupancyFraction` 来指定老年代空间使用阈值(其它回收器只有内存不足时才进行GC).

由于标记删除算法会产生内存碎片.可以使用`XX:+UseCMSCompactAtFullCollection`参数让CMS完成垃圾回收后,进行一次内存碎片整理.使用`-XX:CMSFullGCsBeforeCompaction`设置进行多少次CMS回收后进行一次内存压缩

如果希望使用 CMS 回收 Perm 区，那么则可以打开 `-XX:+CMSClassUnloadingEnabled` 开关。打开该开关后，如果条件允许，那么系统会使用 CMS 的机制回收 Perm 区 Class 数据

## G1回收器

G1 回收器拥有独特的垃圾回收策略，和之前所有垃圾回收器采用的垃圾回收策略不同。从分代看，G1 依然属于分代垃圾回收器。但它最大的改变是使用了分区算法，从而使得 Eden 区、From 区、Survivor 区和老年代等各块内存不必连续。

在 G1 回收器之前，所有的垃圾回收器其内存分配都是连续的一块内存，如下图所示
[![DSMIR1.png](https://s3.ax1x.com/2020/11/13/DSMIR1.png)](https://imgchr.com/i/DSMIR1)

在 G1 回收器中，其将一大块的内存分为许多细小的区块，从而不要求内存是连续的
[![DSM7M6.png](https://s3.ax1x.com/2020/11/13/DSM7M6.png)](https://imgchr.com/i/DSM7M6)

H 是以往算法中没有的，它代表 Humongous。这表示这些 Region 存储的是巨型对象（humongous object，H-obj），当新建对象大小超过 Region 大小一半时，直接在新的一个或多个连续 Region 中分配，并标记为 H

堆内存中一个 Region 的大小可以通过 `-XX:G1HeapRegionSize` 参数指定，大小区间只能是1M、2M、4M、8M、16M 和 32M，总之是2的幂次方。如果G1HeapRegionSize 为默认值，即把设置的最小堆内存按照2048份均分，最后得到一个合理的大小。

G1 收集器的收集过程主要有四个阶段

- 新生代GC
- 并发标记周期
- 混合回收
- 如果需要,进行FullGc

**新生代 GC** : 清空 Eden 区，将存活对象移动到 Survivor 区，部分年龄到了就移动到老年代

**并发标记周期**: 分为 初始标记、根区域扫描、并发标记、重新标记、独占清理、并发清理阶段. 其中初始标记、重新标记、独占清理是独占式的，会引起停顿. 初始标记会引发一次新生代GC. 这个阶段,所有将被回收的区域会被记录在一个称为Collection Set的集合中

**混合回收阶段**:首先针对Collection Set中的内存进行回收.在混合回收时,也会执行多次新生代GC和混合GC,从而进行内存回收

**必要时Full GC**: 回收阶段遇到内存不足时,G1会停止垃圾回收,并进行一次Full GC,从而腾出更多空间进行垃圾回收

相关JVM参数:

- `-XX:+UseG1GC` 打开G1收集器
- `-XX:MaxGCPauseMillis` 设置目标最大停顿时间
- `-XX:ParallelGCThreads` 设置GC工作线程数量
- `-XX:InitiatingHeapOccupancyPercent` 设置堆使用率触发并发标记周期的执行





