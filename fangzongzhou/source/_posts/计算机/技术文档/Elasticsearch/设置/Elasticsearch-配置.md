---
title: Elasticsearch-配置
date: 2018-09-30 16:47:25
categories:
- 技术文档
- Elasticsearch
tags:
- Elasticsearch
---
Elasticsearch提供了不错的默认配置，只需要进行很少的配置即可。多数设置可以在运行的集群上通过[Cluster Update Settings] API来进行修改。

配置文件应该包含节点特定的配置（`node.name` `paths`）或是节点加入集群需要的配置(`cluster.name` `network.host`)

### 配置文件位置

Elasticsearch有三个配置文件：

- `elasticsearch.yml` 用来配置Elasticsearch
- `jvm.options` 用来配置Elasticsearch的JVM配置
- `log4j2.properties` 来配置Elasticsearch的日志

这些文件在配置目录下，默认依赖于你的文档分发位置（tar.gz 或zip）或包分发（Debian或RPM包）位置.
<!--more-->
对于文档分发，配置目录默认在 `$ES_HOME/config` 下。可以通过设置环境变量`ES_PATH_CONF`来进行修改：

```conf
ES_PATH_CONF=/path/to/my/config ./bin/elasticsearch
```

或者，也可以通过命令行或shell脚本来`export` `ES_PATH_CONF`.

对包安装来说，配置文件目录默认在`/etc/elasticsearch`下。这里配置目录也可以通过修改环境变量来进行修改，

### 配置文件格式

配置的格式是YAML，这里是一个修改数据和日志文件路径的例子：

```conf
path:
    data: /var/lib/elasticsearch
    logs: /var/log/elasticsearch
```

配置还可以平铺成下边的形式：

```conf
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
```

### 环境变量替换

配置文件中使用注解`${...}`来标识的变量将会使用环境变量来进行替换：

```conf
node.name:    ${HOSTNAME}
network.host: ${ES_NETWORK_HOST}
```
