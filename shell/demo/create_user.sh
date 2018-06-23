#!/bin/sh
#########create  dir#########################
createdir()
{
 mydir="/oracle/product/10.2.0/db_1"
 mkdir -p $mydir
 cd /
 if [ -d "$mydir" ] ; then
    echo "directory success!!"
    chown -R tester.oinstall  /oracle
    chmod -R 755 /oracle
 else
    echo "directory fail!!"
 fi


}
##########create group#############
creategrp()
{
   groupadd dba    
   if [ "$(grep "dba" /etc/group | cut -d ":" -f "1")" == "dba" ] ; then
      echo "dba success"
   groupadd  oinstall
   if [ "$(grep "oinstall" /etc/group | cut -d ":" -f "1" )" == "oinstall"  ] ; then
      echo "oinstall success"
      createuser  #create user
   else
      echo "oinstall fail!"
   fi
   else
    echo  "dba fail!"
  fi


}
####################################
createuser()
{
useradd tester -m  -g oinstall -G dba
passwd tester
if [ "$(grep "tester" /etc/passwd | cut -d ":" -f "1")" == "tester"  ] ; then
    echo "tester success!!"
else
   echo "tester fail!!"
fi
}
#####################################
editenv()
{
  cd /home/tester
  sed -i "10aORACLE_BASE=/oracle"  ./.bash_profile
  sed -i "11aORACLE_HOME=$ORACLE_BASE/product/10.2.0/db_1"  ./.bash_profile
  sed -i "12aORACLE_SID=orcl"  ./.bash_profile
  sed -i "13aLD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/lib"  ./.bash_profile
  sed -i "14aPATH=$PATH:$ORACLE_HOME/bin:$HOME/bin"  ./.bash_profile
  sed -i  "15aexport ORACLE_BASE"  ./.bash_profile
  sed -i  "16aexport ORACLE_HOME"  ./.bash_profile
  sed -i  "17aexport ORACLE_SID"  ./.bash_profile
  sed -i  "18aexport LD_LIBRARY_PATH"  ./.bash_profile
  sed -i  "19aexport PATH"  ./.bash_profile
   source ./.bash_profile

}





####################################
if [ "$USER" ==  "root" ] ; then
  echo "I am root!"
  creategrp   #create group
  createdir
  editenv
else 
 echo "I am not root!"
 exit
fi
