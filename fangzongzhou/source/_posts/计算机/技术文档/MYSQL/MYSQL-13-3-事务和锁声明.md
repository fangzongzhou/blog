---
title: MYSQL_13.3_事务和锁声明
date: 2018-08-20 22:27:31
categories:
- 技术文档
- MySQL
tags:
- 翻译
---
# 13.3_事务和锁声明
[原文地址](https://dev.mysql.com/doc/refman/8.0/en/sql-syntax-transactions.html)

MYSQL通过像<code>[SET autocommit](https://dev.mysql.com/doc/refman/8.0/en/commit.html)</code>，<code>[START TRANSACTION](https://dev.mysql.com/doc/refman/8.0/en/commit.html)</code>，<code>[COMMIT](https://dev.mysql.com/doc/refman/8.0/en/commit.html)</code>和<code>[ROLLBACK](https://dev.mysql.com/doc/refman/8.0/en/commit.html)</code>支持本地事务(通过指定的客户端会话)，<code>[XA transaction]()</code>也能很好地支持MySQL参与到分布式事务中
