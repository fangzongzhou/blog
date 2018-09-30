---
title: Search_API
date: 2018-09-26 13:35:37
categories:
tags:
---

让我们通过一些简单的查询来开始.这里是两个进行查询的基本方式；一种是通过[REST request URL](https://www.elastic.co/guide/en/elasticsearch/reference/6.4/search-uri-request.html)发送查询参数，另一种是通过[https://www.elastic.co/guide/en/elasticsearch/reference/6.4/search-request-body.html](https://www.elastic.co/guide/en/elasticsearch/reference/6.4/search-request-body.html)发送查询参数。request body 的方式允许你通过更有表现力并且更为可读的JSON格式来定义你的查询，我们将会通过一个例子来讲解request URL查询，但在接下来的教程中，我们将仅仅使用request body的方式进行查询。

REST API从_search终端获取数据，这里的例子返回所有bank索引的文档。

```
GET /bank/_search?q=*&sort=account_number:asc&pretty
```
让我们一起来剖析这个查询的调用.我们在bank索引中查询（_search endpoint）,`q=*`参数标明Elasticsearch匹配索引中的所有文档。`sort=account_number:asc`参数表明使用`account_number` 属性来对文档做升序排列，`pretty`参数同样的是为了告诉Elasticsearch来返回一个美化后的json结果。

结果为(部分展示)：
```
{
  "took" : 63,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1000,
    "max_score" : null,
    "hits" : [ {
      "_index" : "bank",
      "_type" : "_doc",
      "_id" : "0",
      "sort": [0],
      "_score" : null,
      "_source" : {"account_number":0,"balance":16623,"firstname":"Bradshaw","lastname":"Mckenzie","age":29,"gender":"F","address":"244 Columbus Place","employer":"Euron","email":"bradshawmckenzie@euron.com","city":"Hobucken","state":"CO"}
    }, {
      "_index" : "bank",
      "_type" : "_doc",
      "_id" : "1",
      "sort": [1],
      "_score" : null,
      "_source" : {"account_number":1,"balance":39225,"firstname":"Amber","lastname":"Duke","age":32,"gender":"M","address":"880 Holmes Lane","employer":"Pyrami","email":"amberduke@pyrami.com","city":"Brogan","state":"IL"}
    }, ...
    ]
  }
}
```

从结果中，我们看到了以下部分：
- `took`- 以毫秒形式展示的Elasticsearch执行搜索的时间
- `timed_out` - 告知我们查询是否超时
- `_shards` - 告知我们查找的分片数，里边包含了成功和失败搜索分片数
- `hits` - 查找结果
- `hits.total` - 符合查找条件的所有文档数
- `hits.hits` - 实际查找结果的数据（默认前十个文档）
- `hits.sort` - 结果排序的键（使用得分排序时没有）
- `hits._score` 和 `max_score` - 现在忽略这些属性

这里是可以获得同样执行结果的可供替代的request body方法
```
GET /bank/_search
{
  "query": { "match_all": {} },
  "sort": [
    { "account_number": "asc" }
  ]
}

```
一旦获取到查询结果，Elasticsearch的这次请求将完全结束，不会在结果中保留任何形式的服务器端资源或游标，这在Elasticsearch中是非常重要的。这是和其他平台（sql）间一个鲜明的差异，在这类平台上当你初始化获取了部分数据并且你想持续地获取剩余数据时，你可以使用服务器端提供的有状态的游标来完成。
