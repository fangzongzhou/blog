---
title: 系统监控-CPU负载
date: 2018-07-31 12:00:42
categories:
tags:
---
## uptime
直接查看系统负载
```
fangzongzhou@fangzongzhoudeMacBook-Pro ~ $ uptime
12:33  up 8 days, 12:38, 3 users, load averages: 1.48 2.26 2.26
```
## w
显示负载同时提供登录用户及操作信息
```
fangzongzhou@fangzongzhoudeMacBook-Pro ~ $ w
12:35  up 8 days, 12:40, 4 users, load averages: 1.82 2.04 2.16
USER     TTY      FROM              LOGIN@  IDLE WHAT
fangzongzhou console  -                22 718  8days -
fangzongzhou s005     -                12:33       1 ssh relay
fangzongzhou s001     -                10:55       - w
fangzongzhou s012     -                 1:17    1:40 -bash
```

## top
top命令不仅可以查看当前系统的平均负载，还可以查看不同进程对于CPU、内存等资源的使用情况
```
Processes: 320 total, 2 running, 318 sleeping, 1999 threads                                                                                                                                        12:37:34
Load Avg: 1.96, 2.00, 2.13  CPU usage: 6.34% user, 7.0% sys, 86.65% idle    SharedLibs: 140M resident, 43M data, 11M linkedit. MemRegions: 156313 total, 2099M resident, 75M private, 812M shared.
PhysMem: 7974M used (2574M wired), 217M unused. VM: 2491G vsize, 1098M framework vsize, 129462055(0) swapins, 132310913(0) swapouts.   Networks: packets: 12841955/8271M in, 12138688/4363M out.
Disks: 10855494/625G read, 8453048/602G written.

PID    COMMAND      %CPU  TIME     #TH   #WQ  #PORTS MEM    PURG   CMPRS  PGRP  PPID  STATE    BOOSTS           %CPU_ME %CPU_OTHRS UID  FAULTS     COW     MSGSENT    MSGRECV    SYSBSD     SYSMACH
66561  kcm          0.0   00:00.02 6     6    25     2196K  0B     0B     66561 1     sleeping *0[1]            0.00000 0.00000    0    1789       144     214        64         889        372
66557  top          11.6  00:02.00 1/1   0    24     5480K  0B     0B     66557 64837 running  *0[1]            0.00000 0.00000    0    12080+     109     627410+    313666+    41802+     407805+
```
**参数介绍**
- us：非nice用户进程占用CPU的比率
- sy：内核、内核进程占用CPU的比率；
- ni：如果一些用户进程修改过优先级，这里显示这些进程占用CPU时间的比率；
- id：CPU空闲比率，如果系统缓慢而这个值很高，说明系统慢的原因不是CPU负载高；
- wa：CPU等待执行I/O操作的时间比率，该指标可以用来排查磁盘I/O的问题，通常结合wa和id判断
- hi：CPU处理硬件终端所占时间的比率；
- si：CPU处理软件终端所占时间的比率；

## iostat
查看系统分区IO使用情况
```
fangzongzhou@fangzongzhoudeMacBook-Pro ~ $ iostat
              disk0       cpu    load average
    KB/t  tps  MB/s  us sy id   1m   5m   15m
   66.60   26  1.70   7  5 88  1.62 1.81 2.00
```
