---
title: 编译android与tar打包命令
date: 2019-12-31 16:15:02
tags:
---
``` bash
//test.sh
make update-api -j$(grep -c ^processor /proc/cpuinfo)
make -j$(grep -c ^processor /proc/cpuinfo) 2>&1 | tee build_All.log
make otapackage -j$(grep -c ^processor /proc/cpuinfo) 2>&1 | tee build_ota.log

OUTPUT_FILE="packages-$(date "+%Y-%m-%d-%H-%M-%S"-ROM)"
mkdir $OUTPUT_FILE
tar -zcvf ${OUTPUT_FILE}.tar.gz $OUTPUT_FILE
```
