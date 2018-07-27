---
title: docker安装ss
date: 2018-07-27 09:50:20
tags:
---
### 拉取shadowsocks的docker
```
docker pull mritd/shadowsocks
```

### 在docker运行Server端的SS
```
docker run -dt --name ss -p 6443:6443 mritd/shadowsocks -s "-s 0.0.0.0 -p 6443 -m aes-256-cfb -k test123 --fast-open"
```

### 以上命令相当于执行了
```
ss-server -s 0.0.0.0 -p 6443 -m aes-256-cfb -k test123 --fast-open
kcpserver -t 127.0.0.1:6443 -l :6500 -mode fast2
```

### 在docker运行Client端的ss
```
docker run -dt --name ssclient -p 1080:1080 mritd/shadowsocks -m "ss-local" -s "-s 127.0.0.1 -p 6500 -b 0.0.0.0 -l 1080 -m aes-256-cfb -k test123 --fast-open" -x -e "kcpclient" -k "-r SSSERVER_IP:6500 -l :6500 -mode fast2"
```

### 以上命令相当于执行了
```
ss-local -s 127.0.0.1 -p 6500 -b 0.0.0.0 -l 1080 -m aes-256-cfb -k test123 --fast-open 
kcpclient -r SSSERVER_IP:6500 -l :6500 -mode fast2
```

### 参数介绍
```
-m : 参数后指定一个 shadowsocks 命令，如 ss-local，不写默认为 ss-server；该参数用于 shadowsocks 在客户端和服务端工作模式间切换，可选项如下: ss-local、ss-manager、ss-nat、ss-redir、ss-server、ss-tunnel
-s : 参数后指定一个 shadowsocks-libev 的参数字符串，所有参数将被拼接到 ss-server 后
-x : 指定该参数后才会开启 kcptun 支持，否则将默认禁用 kcptun
-e : 参数后指定一个 kcptun 命令，如 kcpclient，不写默认为 kcpserver；该参数用于 kcptun 在客户端和服务端工作模式间切换，可选项如下: kcpserver、kcpclient
-k : 参数后指定一个 kcptun 的参数字符串，所有参数将被拼接到 kcptun 后
```