#!/bin/bash
#program:tester用户安装oracle数据库

#user: luo shaomu
#history: 2014-8-4
#检查登录帐号是否为超管
function checkUser()
{
	if [ $UID -eq 0 ]; then
		echo "$USER 是超级管理员"
	else
		echo "$USER 不是超级管理员"
		echo "准备切换到root帐号,请输入root帐号密码,然后重新执行该脚本"
		su - root
	fi
}
#检查组是否存在
function checkGroup()
{
	if [ "$(cut -d ":" -f 1 /etc/group | grep "$1")" = "$1" ]; then
		echo "$1 组已经存在,不需要创建"
	else
		echo "$1 组不存在,准备创建$1组"
		groupadd $1
		echo "$1 组正在创建中...."
		echo "$1 组创建成功...."
	fi
}

#检查oracle用户是否存在,并分配到指定的dba,oinstall组中
function checkOracleUser()
{
	if [ "$(cut -d ":" -f 1 /etc/passwd | grep "$1")" = "$1" ]; then
		echo "$1用户已经存在,并修改所属组"
		usermod -g $2 -G $3 $1
		echo "$1用户修改成功,并分配到 $2 $3 组中..."
	else
		echo "$1用户不存在,准备创建该用户..."
		useradd -g $2 -G $3 $1
		echo "$1:123456" | chpasswd
		echo "$1用户创建成功,并分配到 $2 $3 组中..."
	fi
}
#检查oracle安装路径,并修改权限
function checkInstallPath()
{
	if [ ! -d "$1" ]; then
		echo "$1 目录不存在,准备新建该目录..."
		mkdir -p $1
		echo "$1 目录创建成功..."
	fi
	#修改/oracle目录的拥有者和所属组
	chown -R tester:oinstall /oracle
	echo "修改/oracle 拥有者和所属组成功"
	#修改/oracle目录的权限
	chmod -R 755 /oracle
	echo "修改/oracle目录权限成功"
}
function checkOracleInstallUser()
{
	if [ "$USER" = "tester" ]; then
		echo "$USER 是安装Oracle的帐号..."
	else
		echo "$USER 不是安装oracle的帐号,准备切换到安装oracle的帐号"
		if [ $UID -ne 0  ]; then 
			echo "请输入安装oracle帐号的密码"
		fi
		su tester
	fi
}
function checkUserEnviroment()
{
	cd
	sed -i '10aORACLE_BASE=/oracle\nORACLE_HOME=$ORACLE_BASE/product/10.2.0/db_1\nORACLE_SID=orcl\nPATH=$PATH:$HOME/bin:$ORACLE_HOME/bin\nLD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/lib\nexport ORACLE_BASE\nexport ORACLE_HOME\nexport ORACLE_SID\nexport PATH\nexport LD_LIBRARY_PATH\n' ./.bash_profile
	source ./.bash_profile
}
function installOracle()
{
	cd /tmp
	unzip oracle_10201_database_linux32.zip
	cd /tmp/database
	./runInstaller
}

checkOracleInstallUser
checkUserEnviroment
installOracle



