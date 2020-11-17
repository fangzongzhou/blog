---
title: Java内存屏障
date: 2020-10-16 09:52:32
categories:
- Java
- 并发编程
tags:
---

硬件层的内存屏障分为两种：`Load Barrier` 和 `Store Barrier`即读屏障和写屏障.

内存屏障有两个作用:

- 组织屏障两侧指令重排序
- 强制把写缓冲区/高速缓存中的数据写回主内存,让缓存中相应的数据失效

对于Load Barrier来说，在指令前插入Load Barrier，可以让高速缓存中的数据失效，强制从新从主内存加载数据

对于Store Barrier来说，在指令后插入Store Barrier，能让写入缓存中的最新数据更新写入主内存，让其他线程可见

## Java内存屏障

Java的内存屏障通常所谓的四种即`LoadLoad`,`StoreStore`,`LoadStore`,`StoreLoad`实际上也是`Load Barrier` 和 `Store Barrier`两种的组合，完成一系列的屏障和数据同步功能

<!--more-->
- LoadLoad屏障：对于这样的语句Load1; LoadLoad; Load2，在Load2及后续读取操作要读取的数据被访问前，保证Load1要读取的数据被读取完毕
- StoreStore屏障：对于这样的语句Store1; StoreStore; Store2，在Store2及后续写入操作执行前，保证Store1的写入操作对其它处理器可见
- LoadStore屏障：对于这样的语句Load1; LoadStore; Store2，在Store2及后续写入操作被刷出前，保证Load1要读取的数据被读取完毕
- StoreLoad屏障：对于这样的语句Store1; StoreLoad; Load2，在Load2及后续所有读取操作执行前，保证Store1的写入对所有处理器可见

StoreLoad屏障的开销是四种屏障中最大的.它兼具其它三种内存屏障的功能
