echo "------------------------------------upload apk------------------------------------"

#cd $WORKSPACE
#cd HZXTM\build\outputs\apk

local_dir=${WORKSPACE}/HZXTM/build/outputs/apk
#gradle 4.0 以上的版本，apk文件路径有改动，打开下面这一行
#local_dir=${WORKSPACE}/HZXTM/build/outputs/apk/${PRODUCT_FLAVORS}/${BUILD_TYPE}

ftp_dir=${WORKSPACE}/HZXTM/build/outputs
ls $local_dir
remote_dir=/x-app/android
SERVER_IP=192.168.18.85
USER=ota
PASSWARD=ota

#ftp -inv << END > $ftp_dir/ftp.error
#ftp -n<<!
#    open $SERVER_IP
#    user $USER $PASSWARD
#    binary
#    hash
#    cd $remote_dir
#    lcd $local_dir
#    prompt
    #put $local_dir/$FTILE_NAME $FTILE_NAME
#    mput *
#    close
#    bye
#END

/Users/admin/otaTemp/ftp -v -n $SERVER_IP << END > $ftp_dir/ftp.error
user $USER $PASSWARD
binary
hash
cd $remote_dir
lcd $local_dir
prompt
mput *
close
bye
END