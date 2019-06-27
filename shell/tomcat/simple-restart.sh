#! /bin/bash
p='/data/webautoservice/tomcat'
file=$p/ROOT.war
echo "this is file--->"$file
if [ ! -e $file ];then
	echo "this is ROOT.war is not fail"
	exit -1
fi
rm -rf $p/webapps/
mkdir $p/webapps
cp $file $p/webapps/

tomcatpath=${p}'/bin'  
echo 'operate restart tomcat: '$tomcatpath  
pid=`ps aux | grep $tomcatpath | grep -v grep | grep -v retomcat | awk '{print $2}'`  
echo 'exist pid:'$pid  
  
if [ -n "$pid" ]  
then  
{  
   echo ===========shutdown================  
   $tomcatpath'/shutdown.sh'  
   sleep 2  
   pid=`ps aux | grep $tomcatpath | grep -v grep | grep -v retomcat | awk '{print $2}'`  
   if [ -n "$pid" ]  
   then  
    {  
      sleep 2  
      echo ========kill tomcat begin==============  
      echo $pid  
      kill -9 $pid  
      echo ========kill tomcat end==============  
    }  
   fi  
   sleep 2  
   echo ===========startup.sh==============  
   $tomcatpath'/startup.sh'  
 }  
else  
echo ===========startup.sh==============  
$tomcatpath'/startup.sh'  
  
fi



