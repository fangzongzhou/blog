---
title: 通过Logstash解析Logs
date: 2020-09-28 00:55:01
categories:
- 技术文档
- Logstash
tags:
- Logstash
---

上一节中,通过创建一个基本的Logstash pipline测试你的Logstash安装成功.在真实场景中,一个Logstash往往更复杂些,典型的Logstash pipline往往有一个或多个input,filter,和output插件.&nbsp;&nbsp;

在本节中,你将创建一个使用Filebeat来采集Apache web logs作为输入,从这些日志中创建具体的,重命名过的属性,并将这些解析过的数据写入到Elasticsearch集群中.你将在一个配置文件中定义这个pipline,而不是在一个命令行中.

本例中,你可以从这里[下载数据集](https://download.elastic.co/demos/logstash/gettingstarted/logstash-tutorial.log.gz),解压这个文件.

## 配置Filebeat发送日志到Logstash

在你创建Logstash pipline前,你需要配置Filebeat发送日志到Logstash.  

[Filebeat](https://github.com/elastic/beats/tree/master/filebeat)客户端是一个轻量的开源工具,它可以完成从你的服务器文件收集日志并将它们转发到你的Logstash实例的过程.专为可靠性和低延迟设计,Filebeat只在主机上占用少量资源,[Beats input](https://www.elastic.co/guide/en/logstash/7.9/plugins-inputs-beats.html) 插件将Logstash 实例资源需求最小化.  

> 典型的使用场景下,Filebeat运行在一个独立于那些运行了logstash实例的机器上,就本教程而言,Logstash实例和Filebeat运行在同一机器上.  

Logstash默认安装时包含了[Beats input](https://www.elastic.co/guide/en/logstash/7.9/plugins-inputs-beats.html)插件,Beats input使得Logstash可以接收Elastic Beats框架的事件,这意味着任何Beats框架编写的beat(例如Packetbeat 和 Metricbeat)都可以发送数据到Logstash  

从 [Filebeat下载页](https://www.elastic.co/downloads/beats/filebeat)下载合适的软件包,安装到你的数据源机器.你也可以参照[Filebeat快速开始](https://www.elastic.co/guide/en/beats/filebeat/7.9/filebeat-installation-configuration.html)获取更多的安装引导.  

下载Filebeat后,你需要先配置它.打开位于你安装目录下的`filebeat.yml`文件,用下文中的内容替换.确保`path`指向之前已经下载好的示例Apache log文件,`logstash-tutorial.log`.  

```yaml
filebeat.inputs:
- type: log
  paths:
    - /path/to/file/logstash-tutorial.log
output.logstash:
  hosts: ["localhost:5044"]
```

保存配置

为了简化配置,没有像实际使用场景一样指定TLS/SSL配置.

在数据源机器上,通过以下命令运行Filebeat

```bash
sudo ./filebeat -e -c filebeat.yml -d "publish"
```

> 如果你以root身份运行Filebeat, 你需要修改配置文件的归属人.

Filebeat将尝试连接5044端口.在Logstash使用有效的Beats插件启动之前，该端口上将没有任何响应,因此,现在看到的关于该端口连接失败的任何消息都是正常的.

## 为Filebeat配置logstash

下一步,你将创建一个使用Beats input插件接收Beats event的pipline.

下边的内容相当于配置pipline的框架:

```text
# The # character at the beginning of a line indicates a comment. Use
# comments to describe your configuration.
input {
}
# The filter part of this file is commented out to indicate that it is
# optional.
# filter {
#
# }
output {
}
```

这个框架是没有实际作用的,因为input和output部分没有定义任何有效的部分.

首先,复制并黏贴框架配置到Logstash根目录下的`first-pipline.conf`文件中.

接下来,添加下边内容到你的配置文件的input section中,使你的Logstash实例使用Beats作为输入.

```conf
    beats {
        port => "5044"
    }
```

你稍后将会配置一个写入到elasticsearch中的logstash,现在,你可以将下边的配置添加到output section中,在你运行logstash时,output将会打印到控制台中.

```conf
    stdout { codec => rubydebug}
```

当你完成上边的配置时, `first-pipline.conf`的内容应该为:

```conf
input {
    beats {
        port => "5044"
    }
}
# The filter part of this file is commented out to indicate that it is
# optional.
# filter {
#
# }
output {
    stdout { codec => rubydebug }
}

```

为了验证你的配置,运行下边命令

```bash
bin/logstash -f first-pipeline.conf --config.test_and_exit
```

`--config.test_and_exit`选项将解析你的配置文件,并报告所有可能出现的错误

如果配置文件通过了配置检测,使用下边的命令开启Logstash:

```bash
bin/logstash -f first-pipeline.conf --config.reload.automatic
```

`--config.reload.automatic`选项可以开启自动加载配置,以后再修改配置文件就不用重启Logstash了.

当Logstash启动时，您可能会看到有关Logstash的一个或多个警告消息，关于忽略了pipes.yml文件。您可以放心地忽略此警告。 Pipelines.yml文件用于在单个Logstash实例中运行[多个pipeline](https://www.elastic.co/guide/en/logstash/current/multiple-pipelines.html)。对于此处显示的示例，您正在运行单个pipeline.

如果你的pipeline工作正常,你应该在控制台能看到和下边内容类似的输出:

```text
{
    "@timestamp" => 2017-11-09T01:44:20.071Z,
        "offset" => 325,
      "@version" => "1",
          "beat" => {
            "name" => "My-MacBook-Pro.local",
        "hostname" => "My-MacBook-Pro.local",
         "version" => "6.0.0"
    },
          "host" => "My-MacBook-Pro.local",
    "prospector" => {
        "type" => "log"
    },
    "input" => {
        "type" => "log"
    },
        "source" => "/path/to/file/logstash-tutorial.log",
       "message" => "83.149.9.216 - - [04/Jan/2015:05:13:42 +0000] \"GET /presentations/logstash-monitorama-2013/images/kibana-search.png HTTP/1.1\" 200 203023 \"http://semicomplete.com/presentations/logstash-monitorama-2013/\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36\"",
          "tags" => [
        [0] "beats_input_codec_plain_applied"
    ]
}
```

## 使用Grok filter插件解析web日志

现在你有了一个可以运行的从Filebeat中读取日志行的pipeline了.然而,你会注意到日志的消息格式并不理想.你想通过解析日志获取到特定的字段.为了这个目的,你可以使用Gork filter 插件.

gork插件是Logstash默认提供的插件之一,有关如何管理Logstash插件,请参阅[插件管理器的详细文档](https://www.elastic.co/guide/en/logstash/current/working-with-plugins.html).

使用gork,您可以将非结构化的日志数据解析为结构化和可查询的内容.&nbsp;

由于grok过滤器插件会在传入的日志数据中查找模式，因此配置插件需要您做出有关如何识别用例感兴趣的模式的决策。 Web服务器日志示例中的代表行如下所示：

```log
83.149.9.216 - - [04/Jan/2015:05:13:42 +0000] "GET /presentations/logstash-monitorama-2013/images/kibana-search.png
HTTP/1.1" 200 203023 "http://semicomplete.com/presentations/logstash-monitorama-2013/" "Mozilla/5.0 (Macintosh; Intel
Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36"
```

该行开头的IP地址很容易识别，括号中的时间戳也很容易识别。要解析这种数据，可以使用`％{COMBINEDAPACHELOG}` grok模式，该模式使用以下模式从Apache日志中构造

| Information         | Fidld Name  |
| ------------------- | ----------- |
| IP Address          | clientip    |
| User ID             | ident       |
| User Authentication | auth        |
| timestamp           | timestamp   |
| HTTP Verb           | verb        |
| Request body        | request     |
| HTTP Version        | httpversion |
| HTTP Status Code    | response    |
| Bytes served        | bytes       |
| Referrer URL        | referrer    |
| User agent          | agent       |

> 如果您需要构建grok模式的帮助，请尝试使用Grok Debugger。 Grok调试器是基本许可证下的X-Pack功能，因此可以免费使用.

编辑 `first-pipeline.conf` 文件并使用下边的内容替换整个filter部分:

```conf
filter {
    grok {
        match => { "message" => "%{COMBINEDAPACHELOG}"}
    }
}
```

完成替换后,整个文件应该是:

```conf
input {
    beats {
        port => "5044"
    }
}
filter {
    grok {
        match => { "message" => "%{COMBINEDAPACHELOG}"}
    }
}
output {
    stdout { codec => rubydebug }
}
```

保存更改。由于您启用了自动重新加载配置，因此无需重新启动Logstash即可获取更改。但是，您需要强制Filebeat从头读取日志文件。为此，请转到运行Filebeat的终端窗口，然后按Ctrl + C关闭Filebeat。然后删除Filebeat注册表文件。例如，运行：

```bash
sudo rm data/registry
```

由于Filebeat会将其收集的每个文件的状态存储在注册表中,因此删除注册表文件会强制Filebeat从头读取其收集的所有文件.

接下来,使用下边的命令重启Filebeat:

```bash
sudo ./filebeat -e -c filebeat.yml -d "publish"
```

Logstash应用grok模式后,event将表现成如下的json形式:
```json
{
        "request" => "/presentations/logstash-monitorama-2013/images/kibana-search.png",
          "agent" => "\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36\"",
         "offset" => 325,
           "auth" => "-",
          "ident" => "-",
           "verb" => "GET",
     "prospector" => {
        "type" => "log"
    },
     "input" => {
        "type" => "log"
    },
         "source" => "/path/to/file/logstash-tutorial.log",
        "message" => "83.149.9.216 - - [04/Jan/2015:05:13:42 +0000] \"GET /presentations/logstash-monitorama-2013/images/kibana-search.png HTTP/1.1\" 200 203023 \"http://semicomplete.com/presentations/logstash-monitorama-2013/\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36\"",
           "tags" => [
        [0] "beats_input_codec_plain_applied"
    ],
       "referrer" => "\"http://semicomplete.com/presentations/logstash-monitorama-2013/\"",
     "@timestamp" => 2017-11-09T02:51:12.416Z,
       "response" => "200",
          "bytes" => "203023",
       "clientip" => "83.149.9.216",
       "@version" => "1",
           "beat" => {
            "name" => "My-MacBook-Pro.local",
        "hostname" => "My-MacBook-Pro.local",
         "version" => "6.0.0"
    },
           "host" => "My-MacBook-Pro.local",
    "httpversion" => "1.1",
      "timestamp" => "04/Jan/2015:05:13:42 +0000"
}
```

## 通过Geoip filter插件增强数据

除解析日志数据以进行更好的搜索外，filter插件还可以从现有数据中获取补充信息。例如,[geoip](https://www.elastic.co/guide/en/logstash/7.9/plugins-filters-geoip.html)插件查找IP地址,从地址中获取地理位置信息,并将该位置信息添加到日志中.

通过添加下边的内容到`first-pipeline.conf`文件的 filter section中,让Logstash实例使用geoip filter plugin:

```conf
    geoip {
        source => "clientip"
    }
```

geoip插件配置需要你指定包含ip地址的字段的名称,在本例中,`clientip`字段包含ip地址

由于filter是顺序计算的,确保geoip部分在grok后,并且它们都嵌套在filter下.

完成配置后,完整的配置文件内容如下:

```conf
input {
    beats {
        port => "5044"
    }
}
 filter {
    grok {
        match => { "message" => "%{COMBINEDAPACHELOG}"}
    }
    geoip {
        source => "clientip"
    }
}
output {
    stdout { codec => rubydebug }
}
```

保存配置,为了强制Filebeat从开始读取日志文件,你应该像前边操作的一样,关闭filebeat,删除注册文件,并通过下边的命令重启

```bash
sudo ./filebeat -e -c filebeat.yml -d "publish"
```

可以看到,现在event中包含了地理位置信息

```json
{
        "request" => "/presentations/logstash-monitorama-2013/images/kibana-search.png",
          "agent" => "\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36\"",
          "geoip" => {
              "timezone" => "Europe/Moscow",
                    "ip" => "83.149.9.216",
              "latitude" => 55.7485,
        "continent_code" => "EU",
             "city_name" => "Moscow",
          "country_name" => "Russia",
         "country_code2" => "RU",
         "country_code3" => "RU",
           "region_name" => "Moscow",
              "location" => {
            "lon" => 37.6184,
            "lat" => 55.7485
        },
           "postal_code" => "101194",
           "region_code" => "MOW",
             "longitude" => 37.6184
    }
```

