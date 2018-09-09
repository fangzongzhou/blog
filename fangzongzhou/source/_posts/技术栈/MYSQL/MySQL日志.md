---
title: MySQL日志
date: 2018-09-07 19:51:26
categories:
- 计算机
- 数据库
tags:
- MySQL
---
## general_log
全量日志
```
show variables like 'general%';

+------------------+----------------------------------------------------+
| Variable_name    | Value                                              |
+------------------+----------------------------------------------------+
| general_log      | OFF                                                |
| general_log_file | /usr/local/var/mysql/fangzongzhoudeMacBook-Pro.log |
+------------------+----------------------------------------------------+

set global general_log=1;
set global general_log=0;
```

## 错误日志
只记录数据库报错

## binlog
记录增删改的记录

## slowlog
只记录超过阈值的慢查询
