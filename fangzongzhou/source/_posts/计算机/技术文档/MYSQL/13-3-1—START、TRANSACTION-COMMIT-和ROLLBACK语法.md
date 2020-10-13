---
title: '13.3.1—START、TRANSACTION,COMMIT,和ROLLBACK语法'
date: 2018-08-23 21:29:57
categories:
- 技术文档
- MySQL
tags:
- 翻译
---

## 13.3.1—START、TRANSACTION,COMMIT,和ROLLBACK语法
[原文地址](https://dev.mysql.com/doc/refman/8.0/en/commit.html)

```
START TRANSACTION
    [transaction_characteristic [, transaction_characteristic] ...]

transaction_characteristic:
    WITH CONSISTENT SNAPSHOT
  | READ WRITE
  | READ ONLY

BEGIN [WORK]
COMMIT [WORK] [AND [NO] CHAIN] [[NO] RELEASE]
ROLLBACK [WORK] [AND [NO] CHAIN] [[NO] RELEASE]
SET autocommit = {0 | 1}
```
控制事务的声明
- `START TRANSACTION` / `BEGIN` 开始一个新的事务
- `COMMIT` 提交当前事务，使修改持久化
- `ROLLBACK` 回滚当前事务，取消当前事务内做的修改
- `SET autocommit`为当前会话开启或关闭autocommit模式

MySQL默认开启autocommit模式，这意味着一旦你执行一个更新（修改）表的声明，MySQL会持久化地在disk上存储这些更新，这些修改不能被回滚。

想要使一系列声明操作失效，可以使用`START TRANSACTION`：
```
START TRANSACTION;
SELECT @A:=SUM(salary) FROM table1 WHERE type=1;
UPDATE table2 SET summary=@A WHERE type=1;
COMMIT;
```
<!--more-->
使用 START TRANSACTION,autocommit会处于无效状态。直到使用COMMIT 或 ROLLBACK 结束当前事务，autocommit mode会恢复之前的状态。

START TRANSACTION 允许使用几个修饰语来控制事务特性，多个修饰语可以使用逗号进行分割。
- `WITH CONSISTENT SNAPSHOT`修饰语能为存储引擎开启一致性读，这只适用于`InnoDB`,效果与`START TRANSACTION`后边跟着一个对任意InnoDB表的`SELECT`相同，这个修饰语不改变当前事务的隔离级别，所以，只有在当前处在一个允许持续读的隔离级别时才能提供一个持久快照，除了`REPEATABLE READ`，在其他的隔离级别下，此修饰语都将被忽略，当它被忽略时，会有警告产生
- `READ WRITE` 和 `READ ONLY`使事务进入一个允许或禁止在本事务中对数据表进行修改的模式，`READ ONLY`限制事务使得它不能修改或锁定其他事务可以访达的数据表，其他事务可以修改或锁定它们。
&#13;
只有读取操作时MySQL会对InnoDB表的查询开启额外的优化，声明`READ ONLY`能确保在无法自动探明只读状态时能应用这些优化。
&#13;
如果没有显式说明，将使用默认模式（read/write），同一个声明中不允许同时出现`READ WRITE` 和 `READ ONLY`
&#13;
在只读模式下，仍然可以通过DML语句操作被`TEMPORARY`关键字声明的表。与永久表一样，使用DDL语句进行修改是不被允许的。
&#13;
更多关于进入事务的模式的信息（包括修改默认模式的方式）可以参见<code>[Section 13.3.7](https://dev.mysql.com/doc/refman/8.0/en/set-transaction.html)</code>
&#13;
如果<code>[read only](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_read_only)</code> 系统变量是开启的，显示通过`START TRANSACTION READ WRITE` 开启一个事务需要<code>[CONNECTION_ADMIN](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_connection-admin)</code>或<code>[SUPER](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_super)</code>权限

> **Important**
>
> 很多APIs被用于MySQL客户端应用（例如JDBC），它们提供了它们自己的方法替代`START TRANSACTION`语句来开启事务。
> 更多相关信息参见[27章 Connectors and APIs](https://dev.mysql.com/doc/refman/8.0/en/connectors-apis.html)

显式禁用autocommit模式，可使用下面的语句；
```
SET autocommit=0;
```
在通过设置`autocommit`变量为0禁用autocommit模式后，修改事务安全的表（例如InnoDB或NDB）将不会立即持久化，你必须使用`COMMIT`来存储变更或使用`ROLLBACK`来忽略修改。

`autocommit`是session变量，并且每一个session都必须设置该变量，如果想要为每一个新建的session都禁用autocommit模式，可以参见[Section 5.1.7 Server System Variables](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html)

`BEGIN` 和 `BEGIN WORK` 被支持作为`START TRANSACTION`的别名来初始化一个事务，`START TRANSACTION`是标准SQL句法，是开启一个`ad-hoc`事务的推荐方式，而`BEGIN`是不支持`ad-hoc`事务的。

> **注意**
>
> 在所有存储项目中（存储程序，函数，触发器和事件），句法分析将`BEGIN [WORK]`作为`BEGIN ... END`块的起始，在上下文中使用`START TRANSACTION`来替代开启一个事务

可选的`WORK`关键词被用来支持`COMMIT`和 `ROLLBACK`，作为 `CHAIN`和 `RELEASE`从句，`CHAIN`和 `RELEASE`可以被用做事务完成的额外控制，系统变量 <code>[completion_type ](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_completion_type)</code> 用来明确事务完成后的默认操作，具体可参见[5.1.7 Server System Variables](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html)

`AND CHAIN` 在当前事务结束后立即开始另一个事务，新的事务有着和刚刚结束的事务相同的隔离级别，同时也使用和结束事务相同的进入模式(READ WRITE 或 READ ONLY)， `RELEASE` 从句会使得服务在当前事务结束后断开当前客户端session连接， `no` 关键字能在事务完成后抑制 `CHAIN` 或 `RELEASE`生效，它在系统变量 [completion_type](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_completion_type) 默认设置为`CHAIN` 或 `RELEASE`时是很有用的。

开始一个事务将导致所有挂起的事务被提交，参见[13.3.3, Statements That Cause an Implicit Commit](https://dev.mysql.com/doc/refman/8.0/en/implicit-commit.html) 获取更多信息

开始一个事务还会导致通过 `LOCK TABLE` 获取的表锁被释放，和执行过 `UNLOCK TABLES` 是一样的效果，但是开启一个事务不会释放通过 `FLUSH TABLES WITH READ LOCK` 获取的全局只读锁

最好的情况下，事务涉及的表应该被单个事务安全的存储引擎管理，否则会出现如下的问题：
- 如果使用的表被多于一个的事务安全引擎管理，并且事务隔离级别不是 `SERIALIZABLE`，很有可能导致在一个事务提交时，另一个正在进行中的使用了相同表的事务只能看到第一个事务做过的修改，混合引擎不能确保事务原子性，将会导致数据结果不一致。（如果混合引擎使用的很少，可以在必要时使用 `SET TRANSACTION ISOLATION LEVEL` 将事务隔离级别设置为 `SERIALIZABLE`
- 如果在事务中使用非事务安全的表，无论autocommit模式处于什么状态，对它们做的修改都会立即生效
- 如果更新事务中的非事务表后使用 `ROLLBACK`，会产生 ` ER_WARNING_NOT_COMPLETE_ROLLBACK` 警告，在事务安全的表中的修改会被回滚，但非事务安全的表不会有改变

每个事务都被存储在一个块的二进制log文件中，那些被回滚的事务不会有日志记录（例外：对非事务表做修改无法回滚。如果一个被回滚的事务包含对非事务表做的修改，则在结束时用 `ROLLBACK` 在结束时记录整个事务，来确保对非事务表的操作被完整复制）参见[Section 5.4.4, “The Binary Log](https://dev.mysql.com/doc/refman/8.0/en/binary-log.html)

可以使用 `SET TRANSACTION` 来修改事务的隔离级别和进入模式，参见 [Section 13.3.7 SET TRANSACTION Syntax](https://dev.mysql.com/doc/refman/8.0/en/set-transaction.html)

回滚可以作为一个缓置操作，可以在没有显示声明时隐式地被调用（例如在错误发生时）因此， `SHOW PROCESSLIST` 为session 展示的数据的回滚操作包含了显示声明的回滚和隐式的回滚。

> **注意**
> &#13;
> 在MySQL 8.0， BEGIN，COMMIT 和 ROLLBACK 不会被  --replicate-do-db 或 --replicate-ignore-db 规则影响
