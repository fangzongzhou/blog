---
title: Elasticsearch基本概念
date: 2018-09-09 16:58:31
categories:
- 技术文档
- Elasticsearch
tags:
- Elasticsearch
---

## 基本概念

这里是Elasticsearch的一些核心概念，理解这些概念能帮助你极大的简化学习过程。

### 近实时（NRT)

Elasticsearch 是一个近实时的搜索平台，从索引文档到被找到会有轻微的延迟（通常是一秒内）。

### 集群

集群是一个或多个节点（服务）的集合，它们共同持有你的所有数据，并通过所有节点提供聚合索引和查询的能力，节点通过唯一的name来进行区分，默认为‘elasticsearch’，这个名称是很重要的，因为一个节点如果被设置为根据名称加入集群，这个节点只能是集群的一部分。

<!-- more-->
确保在不同环境没有重复使用相同的集群名称，否则节点可能加入错误的集群。例如，你可以使用logging-dev, logging-stage, 和 logging-prod 来区分开发，展示，生产环境。

注意，一个集群并只有一个节点时，它是完全正常的，此外你也可以有多个名称各不相同的相互独立的集群。

### 节点

一个节点是作为集群一部分的单个服务，存储你的数据，并参与到集群的索引和搜索中。像集群一样，节点也是通过名称来区分的，名称默认情况下是在启东时生成的随机通用唯一标识符（uuid），如果不想使用默认值，你可以指定它的名称。当你想要识别哪些服务参与集群的通信时，名称是很重要的。

一个节点可以通过配置集群名称来加入一个具体的集群，默认情况下，节点被设置加入名为elasticsearch的集群，这意味着，假定开启的多个可以互相发现的节点，它们会自动加入一个名为elasticsearch的集群

在单集群上，你可以拥有任意数量的节点。然而，如果在你当前运行的网络上没有其他节点，会默认从一个新的名为elasticsearch的集群中开启一个节点。

### 索引
索引是有相同特征的文档的集合。例如，可以有用户数据的索引，商品目录的索引，订单数据的索引。索引通过名字（必须小写）来进行区分，这个名字会在对索引下的文档进行索引，查找，更新，删除操作时起到标注索引的作用。

在单集群的情况下，你可以定义任意数量的索引。

### 文档

文档是可以索引的信息的基本单元。例如：可以有一个顾客的文档，一个产品的文档，一个订单的文档。文档使用json进行表示，json是普遍的数据交换格式。

在一个索引中，你可以存储任意数量的文档。注意，尽管文档体驻留在索引中，但一个文档实际上必须分配一个在索引中的类型。

### 分片和副本

一个索引很可能在单个节点中存储超过硬盘容量的大量数据，例如，一个索引有上亿个文档，占用1t的硬盘容量，单个节点的硬盘可能存储不了，或是从单个节点查找数据很慢。

为解决这个问题，Elasticsearch 提供了可以将索引分到多个片中的分片能力，在创建索引时，可以按需定义分片数量。每个分片都是功能齐全的独立的索引，可以托管在集群的任意节点上。

分片很重要，主要因为如下两个原因：

- 它允许你水片分割、拓展你的容量
- 它允许你通过分片(可能在多个节点上)分布地并行操作，以此来提高性能、吞吐量

分片的分布和文档聚合的机制完全由 Elasticsearch 进行管理，对用户而言是完全透明的。

在可能随时发生以外的网络、云环境中。故障处理机制是很有用的，强烈推荐使用，Elasticsearch允许你制作一个或多个复制分片来拷贝索引分片，来避免节点以任何可能的方式脱机甚至消失。

复制很重要：

- 它在分片、节点故障时提高可用性，因此拷贝分片永远不会被分配到和主分片相同的节点上
- 它允许你拓展搜索、吞吐量，因为可以在所有副本上并行执行搜索

总之，每个索引都可以被分成多个分片，一个索引可以被复制零或多次，复制后，每个索引都将有主分片和复制分片。

可以在索引创建时定义分片和副本的数量。索引创建后，还可以随时修改副本数。可以使用 _shrink 和 _split 来修改现有索引的分片数，然而这不是一件简单的事，最好提前设计好合适的分片数。

默认情况下，每个Elasticsearch 索引被分配5个主分片和1个备份，这意味着如果你在集群中有两个或两个以上的节点，你的索引将有5个主分片和5个备份分片，这一个索引将有10个数据分片。

> 注意：每一个分片都是一个Lucene索引，每个Lucene索引最大限制2,147,483,519 (= Integer.MAX_VALUE - 128) 个文档，你可以使用_cat/shards API 来监控分片大小。
