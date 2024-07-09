ip=$1
user=$2
pw=$3
process=$4
echo "start install mem"
sshpass -p $pw scp -o StrictHostKeyChecking=no -r install.sh $user@$ip:~/
if [ "$process"s == s ];then
    sshpass -p $pw ssh -o StrictHostKeyChecking=no $user@$ip "sh ~/install.sh ; rm ~/install.sh"
else
    sshpass -p $pw ssh -o StrictHostKeyChecking=no $user@$ip "sh ~/install.sh ; sh ~/mem/addmem_wtt.sh $process ; rm ~/install.sh"
fi
echo "stop install mem"
