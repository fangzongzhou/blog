---
title: Elasticsearch-索引
date: 2018-09-30 19:45:14
categories:
- 技术文档
- Elasticsearch
tags:
- Elasticsearch
---


Elasticsearch中所有文档都是被存储在一个有一个的索引中

## 创建索引

最基本的创建索引的命令：

```req
PUT twitter
```

使用所有默认配置创建一个叫做Twitter的索引
> 索引名称限制  
这里有几个命名索引的限制。所有限制包含：

- 只能小写字符
- 不能包含\, /, *, ?, ", <, >, |, \` \` (空格字符), ,, #
- 不能以-, _, +开始
- 不能是.或..
- 不能长于255字节

### 索引设置

每个创建的索引可以有一个定义在body中的关联配置：
<!--more-->

```req
PUT twitter
{
    "settings" : {
        "index" : {
            "number_of_shards" : 3, 
            "number_of_replicas" : 2 
        }
    }
}
```

- 默认的`number_of_shards`配置为5
- 默认的number_of_replicas配置为1（每个主分片只有一个备份）

或者是一种更简洁的方式：

```req
PUT twitter
{
    "settings" : {
        "number_of_shards" : 3,
        "number_of_replicas" : 2
    }
}
```

> 不必在setting中显示指定index

想要了解更多关于创建索引时的不同索引配置，请参见[index modules](https://www.elastic.co/guide/en/elasticsearch/reference/current/index-modules.html)

### mappings

创建索引的api允许在创建时提供一个类型映射

```req
PUT test
{
    "settings" : {
        "number_of_shards" : 1
    },
    "mappings" : {
        "type1" : {
            "properties" : {
                "field1" : { "type" : "text" }
            }
        }
    }
}
```

### aliases

创建索引的api还允许在创建索引时指定一个别名集

```req
PUT test
{
    "aliases" : {
        "alias_1" : {},
        "alias_2" : {
            "filter" : {
                "term" : {"user" : "kimchy" }
            },
            "routing" : "kimchy"
        }
    }
}
```

### 等待活跃分片

默认的，索引只有在主拷贝分片处于活跃状态时才会返回响应结果，创建索引的返回结果会标示出发生了什么

```json

{
    "acknowledged": true,
    "shards_acknowledged": true,
    "index": "test"
}
```

`acknowledged` 标示出是否在集群中成功创建了索引，`shards_acknowledged` 标示出在索引中的所有拷贝分片是否在超时前都已经正常启动.这里要注意，即使是索引创建成功，acknowledged,shards_acknowledged也可能都是false。这些值只是表示在超时前操作是否完成。acknowledged是false时，表示我们的新创建索引在超时前为能更新到我们新创建的索引的信息，但通常它都会稍后完成创建动作

## 删除索引

删除索引API用来删除一个已经存在的索引

```req
DELETE /twitter
```

上边的例子删除了一个叫做Twitter的索引。它需要一个明确的索引或是统配表达式。别名不能用作删除一个索引，通配符表达式仅被用作匹配具体索引.

删除索引的api还可以被用于多个索引的删除，可以使用逗号分隔的列表。或是使用_all或*表示所有索引。

为了禁用通过通配符或_all删除所有索引，可以配置action.destructive_requires_name为true，这个配置也可以由集群更新配置api来进行修改.
