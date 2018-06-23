#!/bin/bash
checkenv()
{
echo "Oracle 开始安装前的配置"
echo "确定当前登录的是超级管理员 root 用户，如下内容都是在 root 下面进行。"
echo "**********************************************"
#****判断当前用户登录状态*********
if [ "$UID" -eq "0" ];then
echo "经核实当前登录的是超级管理员 root 用户"
else
echo "当前登录不是root 用户,请退出登录."

fi
echo "*********************************************"
}
checkgrp()
{

echo "新建管理组"
groupadd  dba
 
if [ "$(grep dba /etc/group)" != "" ];then
echo "管理组创建成功"
else
echo "管理组创建失败"
exit 1

fi
echo "新建安装组"
groupadd  oinstall
if [ "$(grep oinstall /etc/group)" != "" ];then
echo "安装组创建成功"
else
echo "安装组创建失败"
exit 1
fi

}

addtester()
{
echo "新建用户，用户录属于 dba 和 oinstall"
useradd  tester  -g  oinstall  -G  dba
if [ "$(grep tester /etc/passwd)" != "" ];then
echo "新建用户成功"
else 
echo "新建用户失败"
exit 1

fi
echo "*********************************************"

echo "修改用户tester密码"
passwd  tester
echo "密码修改完成"
}
checkdiroracle()
{
echo "*********************************************"
echo "2.利用 root 用户建立安装目录并分配权限"
echo "新建 oracle 安装目录 "
mkdir -p /oracle/product/10.2.0/db_1
mydirpath="/oracle/product/10.2.0/db_1"
if [ -x "$mydirpath" ];then
echo "Oracle 安装目录创建成功"
else
mkdir -p /oracle/product/10.2.0/db_1
fi
echo "修改 oracle 安装目录属主和属组"
chown  -R  tester.oinstall  /oracle
echo "修改 oracle 安装目录操作权限"
chmod  755  -R  /oracle
echo "******************修改完成*********************"
}
#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
checkenv

checkgrp

addtester

checkdiroracle
