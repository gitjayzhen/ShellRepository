#! /bin/bash
#计算/etc下有多少文件
pwd
cd /etc
filesname=`ls -l | wc -l`
echo "there are ${filesname} files under /etc"
