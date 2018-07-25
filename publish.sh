#!/bin/bash

hexo d -p -g;
git add .;
git commit -m "$date更新";
git push origin hexo;
