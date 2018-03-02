#!/bin/bash

hexo d -p -g;
git add .;
git commit -m "更新";
git push origin hexo;
