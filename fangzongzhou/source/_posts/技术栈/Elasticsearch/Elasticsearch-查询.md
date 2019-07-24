---
title: Elasticsearch-查询
date: 2018-09-26 15:12:17
categories:
- 技术文档
- Elasticsearch
tags:
- Elasticsearch
---

## Query 介绍

Elasticsearch 提供一个可用来执行查询指令的JSON风格的语言。参照 [Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/6.4/query-dsl.html) ,这个查询语句十分全面，并且在你第一次看上去感觉很恐怖，最好通过基本的示例来进行学习。

返回我们的上个例子，执行这个查询：

```dsl
GET /bank/_search
{
  "query": { "match_all": {} }
}
```

`query` 部分告诉我们查询是如何定义的，`match_all` 部分简单的定义了我们想要进行的查询。`match_all`是用来简单的对指定的索引进行全文档查询。
<!-- more-->
除`query`参数外，我们也可以通过其他参数对查询结果产生影响，在上一章节中我们通过`sort`,这里我们将通过`size`:

```dsl
GET /bank/_search
{
  "query": { "match_all": {} },
  "size": 1
}
```

这里注意，如果`size`没有指定，它的默认值是10

这个例子做一个`match_all`操作，并返回10-19的文档

```dsl
GET /bank/_search
{
  "query": { "match_all": {} },
  "from": 10,
  "size": 10
}
```

`from` 参数声明了文档从哪个位置开始索引，`size`参数声明了从from开始要返回的文档数量。这个特性当查询结果实现了分页时是很有用的。注意，如果from没有指定，默认值是0.

这个例子执行match_all操作，并且将结果以账户金额倒序的方式进行排序，返回前十个结果

```dsl
GET /bank/_search
{
  "query": { "match_all": {} },
  "sort": { "balance": { "order": "desc" } }
}
```

## 执行查询

我们已经看到了一些基本的查询参数，让我们对Query DSL进行一些更深入的了解，首先我们来看下返回文档的字段。默认的，整个json文档会作为查询的一部分被返回，它被称作source（_source字段在查询的hits中) . 如果我们不希望整个源文档被返回，我们可以只返回源文档中的部分字段。

这个例子展示了如何返回两个字段，`account_number`和`balance`（在_source中的字段)

```dsl
GET /bank/_search
{
  "query": { "match_all": {} },
  "_source": ["account_number", "balance"]
}
```

注意，上边的例子简化了`_source`的字段。它仍然只返回一个`_source`字段，但在它里边，只包含`account_number`和`balance`字段

如果你使用过SQL平台，上边的例子和`SQL SELECT FROM`字段列表有着很相似的概念。

现在我们转移到query部分。之前，我们已经看过了`match_all` 查询匹配所有文档。现在我们介绍一个新的叫做<code>[match query](https://www.elastic.co/guide/en/elasticsearch/reference/6.4/query-dsl-match-query.html)</code> 的查询，它可以被看做最近本的搜索查询（针对字段或字段集合进行查询）

这个例子返回结果为account numbered 20的结果

```dsl
GET /bank/_search
{
  "query": { "match": { "account_number": 20 } }
}
```

这个例子返回所有address中包含"mill"的账号

```dsl
GET /bank/_search
{
  "query": { "match": { "address": "mill" } }
}
```

这个例子返回所有address中包含"mill"或'Lane'的账号

```dsl
GET /bank/_search
{
  "query": { "match": { "address": "mill lane" } }
}
```

这个例子是match的一个变体（match_phrase)，它返回所有address中包含短语"mill lane"的账号

```dsl
GET /bank/_search
{
  "query": { "match_phrase": { "address": "mill lane" } }
}
```

现在我们介绍<code>[bool query](https://www.elastic.co/guide/en/elasticsearch/reference/6.4/query-dsl-bool-query.html)</code>。bool query 允许我们在大的查询语句中使用bool逻辑编写小的查询

---

这个例子写了两个`match`query,并返回所有address中包含'mill'和'lane'的account

```dsl
GET /bank/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "address": "mill" } },
        { "match": { "address": "lane" } }
      ]
    }
  }
}
```

在上边的例子中，`bool must` 从句声明的所有查询全部正确，对应的文档才会被视为匹配。

---

相比之下，这个例子中有两个`match `它的查询结果返回address中包含'mill'或‘lane’的accounts

```dsl
GET /bank/_search
{
  "query": {
    "bool": {
      "should": [
        { "match": { "address": "mill" } },
        { "match": { "address": "lane" } }
      ]
    }
  }
}
```

上例中，`bool should`声明的两个从句中的任意一个为true即可被认为满足匹配条件

---

这个例子中的查询由两个`match`组成，只有当address中不包含'mill'或'lane'任意一个时才会返回该accounts

```dsl
GET /bank/_search
{
  "query": {
    "bool": {
      "must_not": [
        { "match": { "address": "mill" } },
        { "match": { "address": "lane" } }
      ]
    }
  }
}
```
上例中`bool must_not` 从句声明的一系列查询必须没有任何一个为true才能被认为匹配。

我们可以同时在bool query中组合`must`,`should`和`must_not`从句，而且，我们可以在这些`bool`从句中组合这些bool查询来实现任何复杂的多层级bool逻辑

这个例子返回所有40岁并且不生活在ID的所有账号。
```
GET /bank/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "age": "40" } }
      ],
      "must_not": [
        { "match": { "state": "ID" } }
      ]
    }
  }
}
```
