---
title: NodeJs
date: 2018-07-05 21:42:41
categories:
- 计算机
tags:
---

```
node -v
```


## nvm(node version manager)


## 基本使用
```
node *.js
```

<!-- more -->

## http服务
```
var http = require('http');

http.createServer(function (request, response) {


    response.writeHead(200, {'Content-Type': 'text/plain'});

    // 发送响应数据
    response.end('Hello World\n');
}).listen(8888);


console.log('Server running at http://127.0.0.1:8888/');
```

## 异步处理
NodeJs通过回调函数实现异步处理

- 同步处理
```
var fs = require("fs");

var data = fs.readFileSync('input.txt');

console.log(data.toString());
console.log("程序执行结束!");

```
- 异步处理
```
var fs = require("fs");

fs.readFile('input.txt', function (err, data) {
    if (err) return console.error(err);
    console.log(data.toString());
});

console.log("程序执行结束!");
```

## 事件驱动
```
var events = require('events'); // 引入 events 模块

var eventEmitter = new events.EventEmitter();// 创建 eventEmitter 对象

// 创建事件处理程序
var connectHandler = function connected() {
   console.log('连接成功。');

   // 触发 data_received 事件
   eventEmitter.emit('data_received');
}

eventEmitter.on('connection', connectHandler);// 绑定 connection 事件处理程序

// 使用匿名函数绑定 data_received 事件
eventEmitter.on('data_received', function(){
   console.log('数据接收成功。');
});

eventEmitter.emit('connection'); // 触发 connection 事件

console.log("程序执行完毕。");
```
