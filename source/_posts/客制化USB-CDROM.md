---
title: 客制化USB CDROM的显示名称
date: 2017-09-25 14:50:59
tags:
---
该盘符的显示与code无关。是制作iso镜像文件的卷标。制作iso镜像的工具可在网上自行下载，把卷标客制化后，镜像文件的文件名修改为iAmCdRom.iso替换原来的镜像文件，rebuild project即可。
iAmCdRom.iso路径：alps/system/mobile_toolkit

Attention:
1.iso镜像文件不能太小，否则会导致无法识别。这是缘于扇区大小的限制。建议几百K以上。
2.制作iso文件时指定盘符名。以PowerISO为例（非MTK软件，请自行获取）。