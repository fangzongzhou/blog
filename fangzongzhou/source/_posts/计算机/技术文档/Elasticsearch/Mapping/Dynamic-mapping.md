---
title: Dynamic_mapping
categories:
- Elasticsearch
tags:
- Elasticsearch
date: 2021-03-10 07:40:56
---

Elasticsearch最重要的特性之一是它尝试让你摆脱束缚,尽可能快地开始探索数据.索引一个文档,你不必先创建索引,定义映射类型,字段.你只需要进行索引文档,索引,类型和字段将自动展示出来

```dsl
PUT data/_doc/1 
{ "count": 5 }
```

自动检测并添加新字段被称为 `dynamic mapping`.可以为不同的目的通过以下方式自定义配置规则:

- Dynamic field mappings : 管理动态字段检测的规则
- Dynamic templates : 为动态添加的字段配置mapping的自定义规则

> 注意: Index templates 允许你为新索引配置默认mapping,settings,和aliases,无论索引是自动创建的还是显式创建的

## Dynamic field mapping

当Elasticsearch在document中感知到一个新的field,默认情况下会将field添加到type mapping中,由`dynamic`参数控制这种行为

<!--more-->
你可以通过将`dynamic`参数设置成`true`或`runtime`,明确指示Elasticsearch基于创建的文档动态创建字段.

启用dynamic field mapping后,Elasticsearch将通过下表中的规则决定如何为每个field进行类型映射

> 仅在下表中出现的数据类型Elasticsearch才会进行数据监测,其他数据类型,你必须进行显式映射

| JSON data type                                               | "dynamic":"true"                                 | "dynamic":"runtime"                              |
| ------------------------------------------------------------ | ------------------------------------------------ | ------------------------------------------------ |
| null                                                         | No field added                                   | No field added                                   |
| true or false                                                | boolean                                          | boolean                                          |
| double                                                       | float                                            | double                                           |
| integer                                                      | long                                             | long                                             |
| object                                                       | object                                           | object                                           |
| array                                                        | Depends on the first non-null value in the array | Depends on the first non-null value in the array |
| string that passes date detection                            | date                                             | date                                             |
| string that passes numeric detection                         | float or long                                    | double or long                                   |
| string that doesn’t pass date detection or numeric detection | text with a .keyword sub-field                   | keyword                                          |

你可以在文档和对象级别禁用`dynamic mapping`.通过设置`dynamic`参数为`false`忽略新field,当Elasticsearch遇到未知field时,将严格拒绝document

> 使用PUT mapping API为已经存在的field更新`dynamic`配置

### Date detection

如果启用了`date_detection`(默认启用),则将检查新的field字符串,查看它是否与`dynamic_date_formats`指定的日期模式匹配.如果找到匹配项,则会将新的field添加为具有相应日期格式的date类型

`dynamic_date_formats`默认值为 `[ "strict_date_optional_time","yyyy/MM/dd HH:mm:ss Z||yyyy/MM/dd Z"]`

例如:

```dsl
PUT my-index-000001/_doc/1
{
  "create_date": "2015/09/02"
}

GET my-index-000001/_mapping
```

### Disabling date detection

动态日期检测可以通过将`date_detection`设置为`false`来禁用

```dsl
PUT my-index-000001
{
  "mappings": {
    "date_detection": false
  }
}

PUT my-index-000001/_doc/1 
{
  "create": "2015/09/02"
}
```

### 定制检测日期