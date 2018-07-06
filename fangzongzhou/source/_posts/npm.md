---
title: npm
date: 2018-07-05 21:42:12
categories:
tags:
---

## info
```
npm -v //查看版本
sudo npm install npm@latest -g 更新
npm login
npm whoami




```


## install local packages
```
npm install npm@next -g
npm install <package_name>
require('qr-image');
```

## package.json
#### 必要参数

- name
- version

#### create
```
npm init
```
#### modify
```
npm set init.author.email "wombat@npmjs.com"
npm set init.author.name "ag_dubs"
npm set init.license "MIT"
```

#### .npm-init.js
```
~/.npm-init.js

module.exports = {
  customField: 'Custom Field',
  otherCustomField: 'This field is really cool'
}
```
Running npm init with this file in your home directory would output a package.json that included these lines:
```
{
  customField: 'Custom Field',
  otherCustomField: 'This field is really cool'
}
```

-
### dependencies
These packages are required by your application in production.
```
npm install <package_name> [--save-prod]
```
-
### devDependencies
These packages are only needed for development and testing.
```
npm install <package_name> --save-dev
```

## update local package
```
run npm update in the same directory as the package.json file of the application that you want to update
```

## Uninstall Local Packages
```
npm uninstall lodash
npm uninstall --save lodash
```

## Global Packages
```
npm install -g <package>
npm update -g <package>
// 查看需要升级的全局包
npm outdated -g --depth=0
//更新所有包
npm update -g

npm install npm@latest -g
npm uninstall -g <package>
```

## create nodejs model
- creating a package.json file


## Publish & Update a Package
```
npm publish
npm version patch|minor|major
```

## Update the Read Me File
before Update the readme file , must update version ,it mean your version is a Snapshot
