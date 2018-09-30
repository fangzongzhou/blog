---
title: Elasticsearch-Mapping
date: 2018-09-30 17:56:48
categories:
- 技术文档
- Elasticsearch
tags:
- Elasticsearch
---
Mapping是定义文档和其包含的字段的存储和索引的过程，可以使用它来定义：
- 哪些string字段应该被看做全文字段
- 哪些字段包含数字，日期或地理位置
- 是否应将文档中所有字段的值索引到[catch-all](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-all-field.html)字段中
- 日期数据的[格式](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-date-format.html)
- [动态添加字段](https://www.elastic.co/guide/en/elasticsearch/reference/current/dynamic-mapping.html)控制映射的自定义规则

### 字段数据类型
每个字段都有一个数据类型，它可以是：
- 一个简单类型，例如：`text`,`keyword`,`date`,`long`,`double`,`boolean`或`ip`
- 支持json分层特性的类型，例如：`object`或`nested`
- 或是一些专业类型`geo_point`,`geo_shape`或`completion`

它在因为各种目的而需要采用不同方式来索引相同的字段时是很有用的。例如，一个string字段在全文查找时应该被作为一个text来进行索引，在排序或聚合时应该作为一个keyword来进行索引。或者，你也可以使用standard analyzer ，english analyzer ，french analyzer来索引一个string字段。

这是multi-fields的目的，多数数据类型通过fields参数支持multi-fields


#### 避免mappings爆炸的设置
在一个索引中定义过多的字段会导致mapping 爆炸，这会导致内存不足错误或其他因此导致的异常情况。这个问题比预计的要常见的多。例如：考虑这样一种情况，每个新文档都引入一个新的字段。这在动态mapping中很常见，每当有文档添加新的字段时，他们都会最终成为索引mapping。在数据量小时不需要担心，但随着数据量的增长，这回成为一个严重的问题。下面的设置允许你限制字段手动或动态创建的mappings的数量:
- `index.mapping.total_fields.limit` 在一个索引中字段的最大数量，默认为1000
- `index.mapping.depth.limit` 一个字段的最大深度，这是测量对象深度的指标。例如：如果所有字段都被定义在根节点一级，它的深度为1。如果有一个对象mapping，这时深度为2.该配置默认值为20
- `index.mapping.nested_fields.limit` 一个索引中嵌套字段的最大限制，默认为50。索引一个包含100个嵌套字段的文档实际上索引了101个文档，因为每个嵌套文档都被当做一个独立隐藏文档来被索引。

### 动态mapping
字段和mapping 类型在被使用前不需要被定义。归功于动态mapping，新字段会在索引一个文档时被自动添加，新字段会被添加到顶级mapping、内部object和nested字段中。

可以定制化配置动态mapping规则，它们将应用在新字段的mapping中。

### 显示映射
你应该比Elasticsearch的推测更了解你的数据，入门时动态mapping很有用，但是有时你需要显示指定mapping。

你可以在创建索引时创建字段mapping，还可以通过[PUT mapping API](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-put-mapping.html)添加一个字段到已经存在的索引中。

### 更新已经存在的字段的mappings
除了文档外，存在的字段mappings不能被更新，修改mapping意味着已经存在的文档索引会失效。你可以创建一个拥有正确mappings的新索引，并将你的数据从新索引到你新建的索引中。如果你只是想重命名一个字段并不改变它的mappings，使用alias字段是更好的做法。

### 示例mapping
在创建索引时可以声明mapping：
```
PUT my_index 
{
  "mappings": {
    "doc": { 
      "properties": { 
        "title":    { "type": "text"  }, 
        "name":     { "type": "text"  }, 
        "age":      { "type": "integer" },  
        "created":  {
          "type":   "date", 
          "format": "strict_date_optional_time||epoch_millis"
        }
      }
    }
  }
}
```
- 创建一个叫做my_index的索引
- 添加一个叫做doc的mapping类型
- 声明字段或配置
- 为每个字段声明数据类型和mapping

