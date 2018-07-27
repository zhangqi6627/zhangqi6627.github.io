---
title: ubuntu安装docker
date: 2018-07-27 09:49:38
tags:
---
操作系统要求：
需要以下Ubuntu系统的64位版本:
```
Bionic 18.04 (LTS)
Artful 17.10
Xenial 16.04 (LTS)
Trusty 14.04 (LTS)
```

### 1.卸载老版本的docker（如果之前没有安装可以略过）
```
sudo apt-get remove docker docker-engine docker.io
```

### 2.更新软件源
```
sudo apt-get update
```

### 3.安装所需的软件包
```
sudo apt-get install apt-transport-https ca-certificates curl  software-properties-common
```

### 4.添加fingerprint
```
sudo apt-key fingerprint 0EBFCD88
```

### 5.添加repository
```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

### 6.再次更新软件源
```
sudo apt-get update
```

### 7.安装docker
```
sudo apt-get install docker-ce
```

### 8.测试docker是否安装成功
```
sudo docker run hello-world
```