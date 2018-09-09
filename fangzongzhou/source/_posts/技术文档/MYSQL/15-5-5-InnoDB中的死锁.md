---
title: 15-5-5-InnoDB中的死锁
date: 2018-08-27 16:02:17
categories:
- 技术文档
- MySQL
tags:
- 翻译
---
[原文](https://dev.mysql.com/doc/refman/8.0/en/innodb-deadlocks.html)


[TOC]

死锁是两个不同的事务无法进行的一种情况，因为它们互相持有另一方需要的锁，它们都等待资源可用，但却没有任何一方主动释放自己持有的锁。

多个事务在多个表中使用行锁（通过  `UPDATE` 或 `SELECT ... FOR UPDATE`）可能会导致死锁,在一些语句索引记录的锁范围中，每个事务都会获取锁但由于时序问题不会都获取到锁，此时也会产生死锁。参见例子：[Section 15.5.5.1, “An InnoDB Deadlock Example”.](https://dev.mysql.com/doc/refman/8.0/en/innodb-deadlock-example.html)


为了减少死锁发生的可能，应该使用事务，而不是 `LOCK TABLES`语句；使插入和更新数据的事务足够小，以保证它们不会开启很长时间；当不同的事务需要更新多个表或大量行时，在每个事务中使用相同的操作序列（例如： `SELECT ... FOR UPDATE`）；为在像 `SELECT ... FOR UPDATE` 和 `UPDATE ... WHERE `之类的语句中使用的字段创建索引，事务隔离级别不会影响死锁的发生的可能，因为事务隔离级别影响的是读操作的行为，而导致死锁发生的是写操作。了解更多避免死锁和从死锁状态恢复的信息，可参见[Section 15.5.5.3, “How to Minimize and Handle Deadlocks”.](https://dev.mysql.com/doc/refman/8.0/en/innodb-deadlocks-handling.html)

当死锁监测开启（默认）并有死锁发生时，InnoDB会察觉到并回滚其中的一个事务（被死锁影响的事务）。如果通过 `innodb_deadlock_detect` 配置项禁用死锁监测，在死锁发生时，InnoDB依赖` innodb_lock_wait_timeout `设置来回滚事务。所以，即使你的应用逻辑是正确的，在事务重试时你也必须对这种情况做处理。在InnoDB中可以使用` SHOW ENGINE INNODB STATUS `查看最后的死锁。如果死锁经常发生影响事务结构和应用，可以通过 ` innodb_print_all_deadlocks ` 开启配置将所有死锁日志打印出来。更多关于死锁的发生和处理可参见：[Section 15.5.5.2, “Deadlock Detection and Rollback”](https://dev.mysql.com/doc/refman/8.0/en/innodb-deadlock-detection.html)

### 15.5.5.1 一个死锁的例子
下边的例子展示了当请求锁导致死锁时发生的错误。这个例子需要两个客户端，A和B。

首先，客户端A创建一个表，这个表包含一行数据，此时开启一个事务。通过这个事务，A在share模式下通过select获取一个S锁。
```
mysql> CREATE TABLE t (i INT) ENGINE = InnoDB;
Query OK, 0 rows affected (1.07 sec)

mysql> INSERT INTO t (i) VALUES(1);
Query OK, 1 row affected (0.09 sec)

mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT * FROM t WHERE i = 1 FOR SHARE;
+------+
| i    |
+------+
|    1 |
+------+
```

然后客户端B开启一个事务，并尝试从该表中删除这行数据。
```
mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)

mysql> DELETE FROM t WHERE i = 1;
```
这个删除操作会请求一个X锁。这个锁因为和A持有的S锁冲突而无法获取到，这个请求会被加到该行的锁请求队列中，并且B会被阻塞住。

最后A也尝试从表中删除该数据
```
mysql> DELETE FROM t WHERE i = 1;
ERROR 1213 (40001): Deadlock found when trying to get lock;
try restarting transaction
```

此时死锁就会发生，因为A需要X去删除该数据，这个锁请求因为X被B占用而无法获取到，此时B也在等待着A去释放S，而A因为请求X而无法获取到所以也无法释放S。结果，InnoDB在某个客户端产生了错误并回滚了该事务
```
ERROR 1213 (40001): Deadlock found when trying to get lock;
try restarting transaction
```
此时，另一个客户端获取锁的请求可以被准许然后从表中删除数据。

### 15.5.5.2 死锁监测和回滚
当死锁监测开启时（默认），InnoDB自动监测事务死锁并回滚一个或多个事务来解决死锁。InnoDB会尝试挑选一个小的事务来回滚，一个事物的大小是由插入，更新或删除行的数量决定的。

如果`innodb_table_locks = 1` (默认) 并且 `autocommit = 0`，InnoDB能感知到表锁，在它之上的MySQL层级能感知到行锁。他情况下，当使用` LOCK TABLES` 语句对加锁或使用其他的存储引擎时，InnoDB无法监测到表锁。可以通过设置系统变量` innodb_lock_wait_timeout` 来解决这类情况。

当InnoDB为一个事务执行完全回滚后，所有持有的锁都会被释放。然而，如果只因为错误导致单条语句被回滚，可能会导致语句设置的锁被保留。这是因为InnoDB以一种无法在事后知道由哪条语句设置锁的格式来存储行锁。

如果在事务中一个select语句调用了存储函数，并且函数中的一个语句错误，这个语句回滚。此时，在该语句回滚后，整个事务都会回滚。

如果 InnoDB 的 LATEST DETECTED DEADLOCK 监控输出包含了 “TOO DEEP OR LONG SEARCH IN THE LOCK TABLE WAITS-FOR GRAPH, WE WILL ROLL BACK FOLLOWING TRANSACTION,”， 这表明在wait-for List中的事务数量已经达到了200的限制。当wait-for List 数量超过200会被视为死锁并且事务将尝试检查list中回滚的事务。同样的错误也会发生在锁线程必须在wait-for list中监控超过1,000,000个锁的情况下。

#### 禁用死锁监测
在高并发系统中，死锁监控在大量线程等待同一个锁时会导致服务降速。此时禁用死锁监控并依赖 ` innodb_lock_wait_timeout `设置对发生死锁的事务进行回滚是很有效的。死锁监控可以通过 `innodb_deadlock_detect`配置项来禁用。
