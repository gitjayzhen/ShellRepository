#! /bin/bash
#######createfile in dir#########
createfile()
{
read -p "please input your file:" file
if [ -f "$file" ] ; then
echo "the file is exist"
else
read -p "create? create input yes,not create input no" a
case $a in
"yes")cd $1
touch $file
;;
"no")
echo "quit1"
;;
*)
echo "input error"
;;
esac
fi
}
read -p "please input your dir:" dir
if [ -d "$dir" ] ; then
echo "the dir exist"
createfile $dir
else
echo "there is no dir"
fi
