---
title: JVM垃圾回收类型
categories:
  - JAVA
  - JVM
tags:
  - JVM
date: 2020-11-13 00:03:50
---

## 垃圾回收的几种类型

Minor GC、Major GC、Young GC、Old GC、Full GC、Stop-The-World

### Minor GC

从年轻代空间回收内存被称为 Minor GC，有时候也称之为 Young GC

- 当 JVM 无法为一个新的对象分配空间时会触发 Minor GC，比如当 Eden 区满了。所以 Eden 区越小，越频繁执行 Minor GC
- 当年轻代中的 Eden 区分配满的时候，年轻代中的部分对象会晋升到老年代，所以 Minor GC 后老年代的占用量通常会有所升高
- 所有的 Minor GC 都会触发 Stop-The-World，停止应用程序的线程.

对于大部分应用程序，停顿导致的延迟都是可以忽略不计的，因为大部分 Eden 区中的对象都能被认为是垃圾，永远也不会被复制到 Survivor 区或者老年代空间。如果情况相反，即 Eden 区大部分新生对象不符合 GC 条件（即他们不被垃圾回收器收集），那么 Minor GC 执行时暂停的时间将会长很多（因为他们要JVM要将他们复制到 Survivor 区或老年代）

### Major GC

从老年代空间回收内存被称为 Major GC，有时候也称之为 Old GC

许多 Major GC 是由 Minor GC 触发的，所以很多情况下将这两种 GC 分离是不太可能的

Minor GC 作用于年轻代，Major GC 作用于老年代。 分配对象内存时发现内存不够，触发 Minor GC。Minor GC 会将对象移到老年代中，如果此时老年代空间不够，那么触发 Major GC。因此才会说，许多 Major GC 是由 Minor GC 引起的
<!--more-->

### Full GC

Full GC 是清理整个堆空间 —— 包括年轻代、老年代和永久代（如果有的话）。因此 Full GC 可以说是 Minor GC 和 Major GC 的结合

当准备要触发一次 Minor GC 时，如果发现年轻代的剩余空间比以往晋升的空间小，则不会触发 Minor GC 而是转为触发 Full GC。因为JVM此时认为：之前这么大空间的时候已经发生对象晋升了，那现在剩余空间更小了，那么很大概率上也会发生对象晋升。既然如此，那么我就直接帮你把事情给做了吧，直接来一次 Full GC，整理一下老年代和年轻代的空间

在永久代分配空间但已经没有足够空间时，也会触发 Full GC

### Stop-The-World

Stop-The-World，中文一般翻译为全世界暂停，是指在进行垃圾回收时因为标记或清理的需要，必须让所有执行任务的线程停止执行任务，从而让垃圾回收线程回收垃圾的时间间隔

在 Stop-The-World 这段时间里，所有非垃圾回收线程都无法工作，都暂停下来。只有等到垃圾回收线程工作完成才可以继续工作。可以看出，Stop-The-World 时间的长短将关系到应用程序的响应时间，因此在 GC 过程中，Stop-The-World 的时间是一个非常重要的指标