---
title: ccache
date: 2017-09-21 17:02:16
tags:
---
### 介绍
> 
ccache（“compiler cache”的缩写）是一个编译器缓存，该工具会高速缓存编译生成的信息，并在编译的特定部分使用高速缓存的信息， 比如头文件，这样就节省了通常使用cpp解析这些信息所需要的时间。如果某头文件中包含对其他头文件的引用，ccache会用那个文件的 cpp-parsed版本来取代include声明。ccache只是将最终的文本拷贝到文件中，使得它可以立即被编译，而不是真正去读取、理解并解释其内容。ccache是以空间换取速度，ccache非常适合经常make clean（或删除out目录）后重新编译的情况。

配置方法如下:

* 1、在~/.bashrc中添加(或者/etc/profile文件中):
``` mk
#ccache
export USE_CCACHE=1
export CCACHE_DIR=/<path_of_your_choice>/.ccache
```
默认情况下cache（缓存）会保存在~/.ccache目录下，如果主目录位于NFS或其他非本地文件系统上， 设置cache目录位置:export CCACHE_DIR=<path-to-your-cache-directory>
> 
注:配置.bashrc后注意source改文件，否则cache（缓存）会保存在~/.ccache目录下，而不是你设置的目录。

* 2、使用android源码prebuilts目录下面的ccache工具初始化该文件夹
推荐的cache目录大小为50-100GB，在命令行执行以下命令:
``` bash
prebuilt/linux-x86/ccache/ccache -M 50G
```
以上命令需要在你所下载的代码的根目录下面执行
该设置会保存到CCACHE_DIR中，且该命令是长效的，不会因系统重启而失效。使用ccache第一次编译后能够明显提高make clean以后再次的编译速度。

* 3、查看ccahe使用情况
``` bash
$ watch -n1 -d prebuilts/misc/linux-x86/ccache/ccache -s
```
以上命令需要在你所下载的代码的根目录下面执行
> 
备注:使用ccache之后,第一次编译会时间久一点,之后每次编译速度都会有提升