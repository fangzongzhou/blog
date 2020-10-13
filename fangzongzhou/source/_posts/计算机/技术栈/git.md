---
title: git
date: 2018-08-01 00:10:40
categories:
tags:
---


## 工作区，暂存区，本地仓库
**基本的 Git 工作流程如下：**
1. 在工作目录中修改某些文件。
2. 对修改后的文件进行快照，然后保存到暂存区域。
3. 提交更新，将保存在暂存区域的文件快照永久转储到 Git 目录中。

## 基础使用
- 初始化一个新的代码仓库，做一些适当配置；- 开始或停止跟踪某些文件；
- 暂存或提交某些更新。
- 让 Git 忽略某些文件，或是名称符合特定模式的文件；
- 如何既快且容易地撤消犯下的小错误；
- 如何浏览项目的更新历史，查看某两次更新之间的差异；
- 如何从远程仓库拉数据下来或者推数据上去。

<!-- more -->
### install
Ubuntu:

```
sudo apt-get install git
```

### config
配置用户名及邮箱：
```
git config --global user.name "fangzongzhou"
git config --global user.email "fangzongzhou@fzz.com"
--global 参数表示机器所有仓库都能用该用户参数
```

### 获取版本仓库
版本仓库有.git文件，用来记录git数据

直接初始化版本仓库
```
git init 创建仓库
```

从远程仓库clone
```

git clone git://github.com/schacon/grit.git
git clone git://github.com/schacon/grit.git mygrit
```


### 文件管理

![image](https://raw.githubusercontent.com/fangzongzhou/file/master/img/git/filelifecycle.png)
```
git status 查看仓库状态
```

添加内容到下一次提交中
```
git add filename
git add *.c
```

```
git commit 将文件提交到仓库,提交暂存区的所有修改
git commit -m 提交文件要加提交说明，否则没有意义
git commit -a -m 'added new benchmarks' 直接add所有被管理的文件并提交
```

```
git diff 比对文件变化，工作区和暂存区的文件比对
git diff file
git diff --staged 暂存区和仓库对比
```

```
git log  查看提交日志（由近到远）
git log --pretty=oneline
git log --graph --pretty=oneline --abbrev-commit 显示分支合并的log历史
```
## 版本管理
```
git reset 版本回退命令
git reset --hard HEAD^ 回退到上一版本
git reset --hard 版本号 回退到版本号的版本
git reset HEAD file 把文件暂存区的修改回退到工作区
git reflog 记录版本库每次命令（时光机）
```


```
git remote add origin https://github.com/fangzongzhou/qwer.git 添加远程仓库连接
git push -u origin master 将本地仓库推送到远程，并且建立联系
git push origin master 推送本地master分支到远程仓库，不用再加-u参数
```




## 分支管理

```
git checkout -b dev 创建并切换分支
git checkout -b dev origin/dev 拉取远程分支并创建对应的本地分支
git checkout -- file 丢弃工作区的修改
git checkout dev 切换到dev分支
git checkout -b branch-name origin/branch-name 在本地创建和远程对应的分支

git branch dev 创建分支
git branch 查看分支
git branch -r 查看远程所有分支
git branch -d dev 删除dev分支
git branch --set-upstream branch-name origin/branch-name 本地分支和远程分支建立联系

```


```
git merge dev 合并dev分支到当前分支（快进方式）
git merge --no-ff -m "merge with no-ff" dev 以普通模式合并，合并后有历史分支（快速合并则没有）
```

```
git stash 保存工作内容
git stash pop 恢复保存内容
git stash list 查看保存内容
git stash apply 应用保存列表
```
```
git branch -D <name> 强制删除分支名
```
```
git remote 查看远程信息
git remote -v 显示详细远程信息,可以看到自己是否有推送权限
```

```
git push origin branch-name 推送本地分支
git pull 拉取远程较新的分支
git fetch origin 远程分支名x:本地分支名x（不会建立本地分支和远程分支的映射关系）

```


## tag
tag就是一个让人容易记住的有意义的名字，它跟某个commit绑在一起。

Tag可以认为是一个快照、一个记录点

tag标签应该打在一个稳定的commit上。

- 命令```git tag <name>```用于新建一个标签，默认为HEAD，也可以指定一个commit id；
- ``` git tag -a <tagname> -m "blablabla..." ```可以指定标签信息；
- ```git tag -s <tagname> -m "blablabla..."```可以用PGP签名标签；
- 命令```git tag```可以查看所有标签。

```
git push origin <tagname> 推送某个标签到远程
git push origin --tags 一次推送所有标签到远程
git checkout -b version2 v2.0.0 检出标签到一个分支
```

查看订单list并过滤
```
git tag -l 'r*'
```
