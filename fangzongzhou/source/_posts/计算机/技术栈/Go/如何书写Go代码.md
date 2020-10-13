---
title: 如何书写Go代码
date: 2018-09-13 00:43:20
categories:
- 计算机
- 文档
- GO
tags:
- GO文档
---
https://golang.google.cn/doc/code.html
## 介绍
本文档演示了如何开发一个简单的Go包，Go tool，以及标准的fetch，build和install的方式和命令。

go tool 要求你通过一种特殊的方式管理代码，请仔细阅读文档，它解释了通过go应用最简单的启动和运行的方式。

## 代码管理
### 概述
- Go 开发者通常将代码保存在一个workspace中
- 一个workspace包含多个版本控制仓库（例如：通过git管理）
- 每个repository包含一个或多个package
- 每个package在一个文件夹下包含多个GO源文件
- 包路径直接标明了它的引用路径

请注意，这与其他编程环境不同，在这些环境中，每个项目都有一个单独的工作区，工作区与版本控制repository紧密相关。

### Workspaces
workspace根目录由两个目录构成
- `src` 包含Go 源文件
- `bin` 包含可执行命令文件

go tool能直接为bin目录build和install二进制可执行文件

<!--more-->
src子目录通常包含多个版本控制仓库，用来跟踪它们源包的开发。

为了让你了解实际场景中workspace的样子，这里给出一个示例：
```
bin/
    hello                          # command executable
    outyet                         # command executable
src/
    github.com/golang/example/
        .git/                      # Git repository metadata
	hello/
	    hello.go               # command source
	outyet/
	    main.go                # command source
	    main_test.go           # test source
	stringutil/
	    reverse.go             # package source
	    reverse_test.go        # test source
    golang.org/x/image/
        .git/                      # Git repository metadata
	bmp/
	    reader.go              # package source
	    writer.go              # package source
    ... (many more repositories and packages omitted) ...


```

上边的树形图展示了一个包含了两个repositorie的workspace，example repository 包含了两个命令（hello和outyet）和一个library（stringUtil），image repository 包含一个bmp包和其他几个包

典型的workspace包含了很多源码库，这些库里又各自包含很多包和命令。多数go开发者将源代码和依赖放在同一个workspace里。

注意，不要通过符号链接将文件或目录链接到你的workspace。

命令和库是从不同的源包进行构建的，我们将稍后讨论

### GOPATH 环境变量
GOPATH 环境变量声明了你的workspace地址，默认情况下它是你home目录下的叫go的文件目录。

如果你想在另一个路径下工作，你需要将set GOPATH该目录的路径，（一种常见的方式是设置GOPATH=$HOME），注意GOPATH一定不能是Go的安装目录。

命令 `go env GOPATH` 会打印当前生效的GOPATH；如果没有设置环境变量，将打印默认路径地址。

为了方便，可以将workspace的bin目录添加到你的PATH中
```
export PATH=$PATH:$(go env GOPATH)/bin
```

下文中为了简洁我们将使用 `$GOPATH` 代替 `$(go env GOPATH)`,如果你没有设置GOPATH，为了确保下文中书写的脚本能正确运行，你可以使用`$HOME/go`来替代或是运行：
```
export GOPATH=$(go env GOPATH)
```
想了解更多关于GOPATH环境变量的信息，可以参见`go help gopath`

想要使用自定义workspace地址，请设置GOPATH环境变量

### 导入路径
一个import path是一个能唯一标识一个包的字符串，一个包的导入路径相当于它在workspace或远程仓库的定位。那些标准库的包会被分配一个短的导入路径，例如“fmt”和”net/http",对于你自己的包来说，你必须选择一个不大可能和标准库未来新包及其他外部包冲突的基础路径。

如果你将代码保存在某个代码仓库中，那么你应该使用该代码仓库的根路径作为你的基础路径，例如：你在GitHub上有个账号github.com/user,那这就该是你的基本路径。

注意，构建代码前无需将代码发布到远程仓库，这只是为了日后的发布所养成的好习惯，你可以选择任意路径名称，只要它对标准库和更大的go生态系统来说是唯一的。

我们将使用`github.com/user`做为你的基础路径，在你的workspace中创建一个目录，源代码将放在里边。
```
mkdir -p $GOPATH/src/github.com/user
```

### 你的第一个程序
编译并运行一个简单的程序，首先选择一个包路径（github.com/user/hello）并在你的workspace中创建对应的包目录
```
mkdir $GOPATH/src/github.com/user/hello
```
下一步，在你的目录下创建一个hello.go文件，包含下边代码：
```
package main

import "fmt"

func main() {
	fmt.Println("Hello, world.")
}
```
现在你可以使用go tool 来构建安装你的应用
```
go install github.com/user/hello
```
注意，你可以在你系统的任意位置运行该命令，在你生明了GOOATH后，go tool将会在workspace下查找该路径包含的源码

如果你在该目录下，你也可以省略包路径
```
$ cd $GOPATH/src/github.com/user/hello
$ go install
```
这个命令将构建hello命令，产生一个可执行的二进制文件。同时安装该二进制文件到你的workspace的bin目录中，在本示例中，文件地址为`$GOPATH/bin/hello`, 也就是 `$HOME/go/bin/hello`.

go tool 只有在发生错误时才会打印输出，所以，如果在执行该命令没有任何输出表示它们已经执行成功。

现在你可以在命令行中输入文件全路径来运行该程序
```
$ $GOPATH/bin/hello
Hello, world.
```
或者，你已经添加了` $GOPATH/bin`到你的PATH中，那么你只需要输入二进制文件的文件名
```
$ hello
Hello, world.
```
如果你使用代码控制系统，那么现在是你初始化仓库的合适时机，添加这个文件，并且提交你的第一次修改，当然，这是可选项，你不被要求必须使用代码控制系统来写go代码
```
$ cd $GOPATH/src/github.com/user/hello
$ git init
Initialized empty Git repository in /home/user/work/src/github.com/user/hello/.git/
$ git add hello.go
$ git commit -m "initial commit"
[master (root-commit) 0b4507d] initial commit
 1 file changed, 1 insertion(+)
  create mode 100644 hello.go
```
将代码push到远程仓库需要读者提前练习

### 你第一个library

我们来写一个library，并通过hello来使用它

同样的，第一步我们先选择一个包路径（github.com/user/stringutil），创建包目录

```
mkdir $GOPATH/src/github.com/user/stringutil
```
接下来，在该目录下创建一个包含如下内容的叫做reverse.go的文件
```
// Package stringutil contains utility functions for working with strings.
package stringutil

// Reverse returns its argument string reversed rune-wise left to right.
func Reverse(s string) string {
	r := []rune(s)
	for i, j := 0, len(r)-1; i < len(r)/2; i, j = i+1, j-1 {
		r[i], r[j] = r[j], r[i]
	}
	return string(r)
}
```
然后通过go build 测试包的编译
```
go build github.com/user/stringutil
```
如果你现在就在该工作目录下，可以直接通过`go build`来进行编译，而不用指定目录

这不会产生一个文件，相反，它将编译的包保存在本地的缓存中

在确定stringutil包构建完成后，修改你的hello.go 文件来使用它
```
package main

import (
	"fmt"

	"github.com/user/stringutil"
)

func main() {
	fmt.Println(stringutil.Reverse("!oG ,olleH"))
}
```
install 这个hello程序
```
go install github.com/user/hello
```
运行这个新版的程序，你将看到一个倒转的字符串
```
$ hello
Hello, Go!
```

通过以上步骤，你的workspace看起来将会是这个样
```
bin/
    hello                 # command executable
src/
    github.com/user/
        hello/
            hello.go      # command source
        stringutil/
            reverse.go    # package source
```

### 包名

go源码文件的第一行命令必须是
```
package name
```
这里name是包导入的默认名称，一个包中的文件必须有相同的包名

go约定以导入路径的最后一个元素作为包名，以路径"crypto/rot13"导入的包应该被命名为rot13.

可执行文件必须使用package main 作为包名

不要求所有文件的包名都是不同的，只要他们的导入路径是唯一的即可

参照[ Effective Go ](https://golang.org/doc/effective_go.html#names) 了解更过的命名规范

### 测试
go 有一个由go test命令及测试包组成的轻量测试框架

你可以通过创建一个_test.go结尾的文件来写一个测试，该文件包含名为TestXXX且带有签名func（t * testing.T）的函数。该框架会运行所有的这些函数，如果函数调用任何诸如t.Error 或 t.Fail之类的函数，则认为测试失败。

通过创建含有如下内容的$GOPATH/src/github.com/user/stringutil/reverse_test.go文件为stringutil添加测试
```
package stringutil

import "testing"

func TestReverse(t *testing.T) {
	cases := []struct {
		in, want string
	}{

	}
	for _, c := range cases {
		got := Reverse(c.in)
		if got != c.want {
			t.Errorf("Reverse(%q) == %q, want %q", c.in, got, c.want)
		}
	}
}
```
然后运行go test
```
$ go test github.com/user/stringutil
ok  	github.com/user/stringutil 0.165s
```
如果你直接在包目录下运行go tool，你可以省略路径
```
$ go test
ok  	github.com/user/stringutil 0.165s
```
运行[go help test](https://golang.org/cmd/go/#hdr-Test_packages) 并参照 [testing package documentation](https://golang.org/pkg/testing/) 了解更过细节

### 远程包
导入路径用来描述如何使用诸如Git或Mercurial之类的代码控制系统来获取包源代码。 go工具使用此属性自动从远程存储库获取包。例如，本文档中描述的示例保存在GitHub github.com/golang/example上托管的Git存储库中。如果您在包的导入路径中包含存储库的URL，那么go将自动获取，构建和安装它：
```
$ go get github.com/golang/example/hello
$ $GOPATH/bin/hello
Hello, Go examples!
```
如果工作空间中不存在指定的包，则get将其放在GOPATH指定的第一个工作空间内。 （如果包已经存在，则跳过远程提取，其行为与go install相同。）

执行过上边的go get命令后，workspace将会变成下边的样子
```
bin/
    hello                           # command executable
src/
    github.com/golang/example/
	.git/                       # Git repository metadata
        hello/
            hello.go                # command source
        stringutil/
            reverse.go              # package source
            reverse_test.go         # test source
    github.com/user/
        hello/
            hello.go                # command source
        stringutil/
            reverse.go              # package source
            reverse_test.go         # test source
```

在GitHub上托管的hello命令依赖同一存储库中的stringutil包。 hello.go文件中的导入使用相同的导入路径，因此go get命令也能够找到并安装依赖包。
```
import "github.com/golang/example/stringutil"
```

这些约定能极大的简化别人使用你的包的难度， Go Wiki 和 godoc.org 提供外部工程的包列表

更多通过go tool使用远程仓库的信息请参见[go help importpath.](https://golang.org/cmd/go/#hdr-Remote_import_paths)
<!--todo-->
