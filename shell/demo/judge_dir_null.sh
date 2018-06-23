#! /bin/bash
#判断目录是否为空
director="/etc/abc"
com=`ls $director`
if [ "$director -z" ] ; then
echo "$director is null"
else
echo "$director is not null"
fi



DIRECTORY="/root/dir4"
com="`ls $DIRECTORY`"
if [ "$com" == "" ] ; then
	echo "$DIRECTORY is empty"
else
	echo "$DIRECTORY is not empty"
fi
