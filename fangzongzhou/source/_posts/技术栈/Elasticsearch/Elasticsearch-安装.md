---
title: Elasticsearch-安装
date: 2018-09-30 16:23:44
categories:
- 技术文档
- Elasticsearch
tags:
- Elasticsearch
---
Elasticsearch提供以下格式的安装包


包类型 | 适用情况
---|---
[zip/tar.gz](https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-targz.html) | 适用于任何操作系统的安装，是最简单的安装方式 
[deb](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html) | 适用于Debian，Ubuntu和其他基于Debian的操作系统，
[rpm](https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html) | 适用于Red Hat,Centos,OpenSuSE和其他基于RPM的系统
[msi](https://www.elastic.co/guide/en/elasticsearch/reference/current/windows.html) | 适用于Windows 64位操作系统
[docker](https://www.elastic.co/guide/en/elasticsearch/reference/6.4/docker.html) | 通过镜像运行Elasticsearch容器
<!--more-->
### 部署管理工具
Elasticsearch提供了以下配置管理工具来简化大规模部署

工具 | git地址
--- | ---
Puppet | [puppet-elasticsearch](https://github.com/elastic/puppet-elasticsearch)
Chef | [cookbook-elasticsearch](https://github.com/elastic/cookbook-elasticsearch)
Ansible | [ansible-elasticsearch](https://github.com/elastic/ansible-elasticsearch)