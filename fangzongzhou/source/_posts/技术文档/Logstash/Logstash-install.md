---
title: Logstash-install
date: 2020-09-24 16:21:06
categories:

- 技术文档
- Logstash

tags:

- Logstash
---

## 下载二进制文件安装

[下载地址](https://www.elastic.co/downloads/logstash)

## 通过包仓库安装

### APT

```bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt-get install apt-transport-https

echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

sudo apt-get update && sudo apt-get install logstash
```

### YUM

```bash
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

```

添加下边内容到你的 /etc/yum.repos.d/ 目录下一个以 `.repo` 为后缀的文件, 例如 `logstash.repo`

```config
[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
```

```bash
sudo yum install logstash
```

### macOs

```bash
brew tap elastic/tap
brew install elastic/tap/logstash-full
//配置开机自动启动
brew services start elastic/tap/logstash-full
logstash
```
