---
title: docker加载ylzq
date: 2018-07-27 09:47:22
tags:
---
### 1.下载docker离线包
```
wget http://www.yiluzhuanqian.com/soft/docker_images/ylzq_v2_0.tar
```

### 2.导入镜像
```
docker load  --input ylzq_v2_0.tar
```
运行容器，开始赚钱

### 3.注意这里uid对应的是之前获取到的id。不要填写错误，否则获取不到收益。
```
docker run --name=ylzq2_0 -d -e uid=10014 ylzq:v2.0
```

### 4.检查下是否运行
```
docker ps
```