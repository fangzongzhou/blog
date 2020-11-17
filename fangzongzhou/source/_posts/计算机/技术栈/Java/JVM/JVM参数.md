---
title: JVM参数
categories:
  - Java
  - JVM
tags:
  - JVM
date: 2020-11-05 19:40:15
---

[perfma JVM参数线上解析](https://opts.console.perfma.com/)

## HeapSize

512*page_size 对齐,page_size通常情况下是4kb,如果取值不是其倍数,向上取整

### Xmx

堆的最大值

和`MaxHeapSize`等价

### Xms

设置堆的最小值(堆的初始值)
和`InitialHeapSize`等价

### Xminf/Xmaxf

等价于`MinHeapFreeRatio/MaxHeapFreeRatio`,默认值分别为40/80

G1下作用于整个heap,其他算法作用于老生代,GC后根据使用情况对堆内存进行扩/缩容

### MinHeapDeltaBytes

尝试扩容/缩容的时候,决定是否要做或尝试扩容的时候最小扩多少,默认为192k

<!--more-->

## MaxDirectMemorySize

DirectByteBuffer对象会关联堆外内存

## CodeCache

存储JVM动态生成的代码,如果这部分内存不够会影响代码转化成机器码,影响代码执行效率.

### InitialCodeCacheSize

是CodeCache的初始大小,CodeCache增长后不会下降

### ReservedCodeCacheSize

设置CodeCache最大的内存值,默认值是48M(分层编译需要的更多),不能超过2G.

和`XmaxjitCodeSize`等价

### CodeCacheMinimumFreeSpace

表示当前CodeCache的可用大小不足该值时,会进行code cache full处理.会输出`CodeCache is full`日志,该日志仅打印一次

## Thread Size

JVM线程分为java线程和非java线程.GC线程,VM Thread属于非java线程.

linux下线程的最小值为228k

### Xss

设置Java线程栈的大小,单位为KB和`ThreadStackSize`参数等价,64位机器中默认为1M

### VMThreadStackSize

设置JVM中线程栈的大小

### CompilerThreadStackSize

设置编译线程的大小,64位机器中默认为4M

## Metaspace

使用jstat查看Metaspace内存的使用率,分母是committed的size,而不是Reserved的内存

### CompressedClassSpaceSize

JVM启动时分配的用于专门存类元数据class部分的内存大小.默认1G

### InitialBootClassLoaderMetaspaceSize

主要指定BootClassLoader的存储非class部分的数据的第一个Metachunk的大小.64位下默认为4M

### MetaspaceSize

### MaxMetaspaceSize

## Perm

### PermSize

Perm内存初始值大小,也是最小值

### MaxPermSize

表示Perm内存最大值

## Eden/Survivor相关

- From Space
- To Space

GC发生的时候会将Eden和From Space里的可达对象往To Space里拷贝或晋升为老年代

### SurvivorRatio

表示Eden/一个Survivor的比值,默认是8,最小值1

### MinSurvivorRatio

### InitialSurvivorRatio

表示新生代初始可用内存/survivor的比值,默认情况下为8.至少为3.只有在启动的时候有用.

## New Size

新生代大小

### Xmn

等于同时设置`NewSize`和`MaxNewSize`

### NewSize

设置新生代有效内存初始大小,新生代有效内存最小值,新生代缩容可达的最小值

### MaxNewSize

### NewRatio

当前老生代可用内存/当前新生代可用内存比值,默认为2.

## 类加载/卸载

`-XX:+TraceClassLoading` 可以显示类加载信息,`-XX:+TraceClassUnloading` 显示类卸载信息

## -XX:MaxTenuringThreshold

设置晋升到老年代所需要的GC次数
