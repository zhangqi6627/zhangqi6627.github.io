---
title: repo一个新工程使用步骤
date: 2019-12-31 15:43:32
tags:
---
``` bash
1.下载.git
repo init -u ssh://xxxxx

2.修改default.xml添加自己帐户权限
emacs .repo/manifests/dfault.xml
ssh://192.168.25.15:29419/xxx
改为:
ssh://gerrit-username@192.168.25.15:29419/xxx

3.同步代码
repo sync -j48
or:
repo sync -j48 -c --no-tags

4.切换分支，如切换到dev分支
repo start dev --all

5.注释与提交代码
git commit -s //调出注释格式
git push dev HEAD:refs/for/dev //提交代码

6.修改提交信息
git commit --amend
git push --no-thin dev HEAD:refs/for/dev

7.同步当前目录代码
repo sync .

8.如果当前工程在根目录.repo/manifests/default.xml添加新的工程，可以删除当前目录下的文件及.git,然后在根目录.repo/manifests/default.xml里找到对应路径，如:device/qcom/common
cd device/qcom/common
rm -rf * && rm -rf .git
repo sync device/qcom/common
```
