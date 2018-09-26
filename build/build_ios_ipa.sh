whoami
#设置输出路径
output=$WORKSPACE/../ios_zzFinance
cd $output
rm -rf output
mkdir output
out=$output/output

cd $WORKSPACE

#工程名
projectName="HouniaoP2P"

#scheme名
buildScheme="HouniaoP2P"

#Info.plist文件路径
project_infoplist_path="./platforms/ios/${projectName}/${projectName}-Info.plist"

#取版本号：1.0.0
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${project_infoplist_path}")
bundleShortVersion=${bundleShortVersion//./-}
#设置日期格式：20161216161616
DATE="$(date +%Y%m%d%H%M%S)"

echo "======================begin build ipa====================="

#拼接ipa文件名：HouniaoP2P_master_V1-0-0_20161216161616_Normal.ipa
IPANAME="${buildScheme}_${branch}_V${bundleShortVersion}_${DATE}_${configuration}.ipa"
dSYMANAME="${buildScheme}_${branch}_V${bundleShortVersion}_${DATE}_${configuration}"

#切换打包方式
flag="0"
if [ "${flag}"x = "0"x ]; then
    
	#文件构建目录
	iPhoneOS="./${configuration}-iphoneos"
	rm -rf ${iPhoneOS}
    
	#集成有Cocopods的用法
	xcodebuild -workspace ./platforms/ios/${projectName}.xcworkspace -scheme ${buildScheme} -configuration ${configuration} clean build SYMROOT='$(PWD)'
    #生成ipa文件
	xcrun -sdk iphoneos PackageApplication ${iPhoneOS}/${projectName}.app -o $out/${IPANAME}

	cd ${iPhoneOS}
	zip -r dSYM.zip ${projectName}.app.dSYM
	cp dSYM.zip ${out}
else 
	archiveName="${projectName}.xcarchive"
	archivePath="$out/${archiveName}"
	xcodebuild clean -configuration ${configuration} -alltargets
	xcodebuild archive -workspace ./platforms/ios/${projectName}.xcworkspace -scheme ${buildScheme} -configuration ${configuration} -archivePath ${archivePath}
	xcodebuild -exportArchive -archivePath ${archivePath} -exportPath $out/${IPANAME}

	cd ${out}
	zip -r dSYM.zip ${archiveName}
fi

echo "======================end build ipa====================="


dir_out=$output

# 新项目需要重新定义目录路径，然后在ota项目中添加对应的配置
ftp_dir="/finance-app/ios"
echo "======================upload====================="
## 调整输出路径
function adjust_outdir
{
	mkdir -p $dir_out
	cp_status=$?
	if [ ${cp_status} -ne 0 ];then
		echo "file directory adjust failed"
	else
		echo "file directory adjust success"
	fi
	return ${cp_status}
}

## 目录递归
function mkdir_recursive
{
	if [ -z $1 -o $1 = "/" ]; then
		return
	fi

	parent_dir=`dirname $1`
	mkdir_recursive $parent_dir

	if [ ! -d $1 ]; then
		echo "mkdir $1"
	fi
}

## 上传ftp工具
function real_upload_ftp
{
SERVER_IP=$1
USER=$2
PASSWARD=$3
UPLOAD_DIR=$4
VERSION=$5
LOCAL_DIR=$6
REMOTE_DIR=$UPLOAD_DIR/$VERSION
REMOTE_OUTDIR=$REMOTE_DIR/output
WAR_PROJ=$LOCAL_DIR/output/$7
WAR_SYM=$LOCAL_DIR/output/dSYM.zip
CONF_DIR=$LOCAL_DIR/conf

updir=$6/output
todir=$REMOTE_OUTDIR

mkdir_base_ftp=`mkdir_recursive $UPLOAD_DIR`
/Users/admin/otaTemp/ftp -inv << END > $LOCAL_DIR/ftp.base.mkdir.error
	open $SERVER_IP
	user $USER $PASSWARD
	type binary 
	prompt
	$mkdir_base_ftp
	close
	bye
END

#sss=`find -f $updir | awk '{if ($0 == "")next;print "mkdir " $0}'` 
#aaa=`find -f $updir 'put %p %P \n'` 
#sss=`mkdir_recursive output`

echo $REMOTE_DIR
echo $REMOTE_OUTDIR
echo ${updir}
echo ${todir}

/Users/admin/otaTemp/ftp -inv << END > $LOCAL_DIR/ftp.error
	open $SERVER_IP
	user $USER $PASSWARD
	type binary 
	prompt
	mkdir $REMOTE_DIR
	cd $REMOTE_DIR
    put $WAR_PROJ $7
    put $WAR_SYM ${dSYMANAME}-dSYM.zip
	close
	bye
END

connect_ftp_code=220
login_success_code=230
directory_fail_code=550
createfile_fail_code=553

#sed -i "s/${connect_ftp_code} bytes/221 bytes/g" ${LOCAL_DIR}/ftp.error
#sed -i "s/${login_success_code} bytes/231 bytes/g" ${LOCAL_DIR}/ftp.error
#sed -i "s/${directory_fail_code} bytes/551 bytes/g" ${LOCAL_DIR}/ftp.error
#sed -i "s/${createfile_fail_code} bytes/554 bytes/g" ${LOCAL_DIR}/ftp.error

exit 0
}

## 上传ftp
#FTP_SH=/home/work/shell/ftp_jenkins.sh
function upload_ftp
{
    snapshot=${IPANAME%.*}
    echo $snapshot 
    
    #chmod +x $FTP_SH
    real_upload_ftp 192.168.18.85 ota ota $ftp_dir $snapshot $output $IPANAME
    upload_status=$?
    if [ ${upload_status} -eq 0 ];then
		echo "[INFO] : files upload by ftp success"
    else
		echo "ERROR : files upload by ftp fail"
    fi
    return ${upload_status}
}

echo '==> start adjust_outdir'
adjust_outdir
adjust_outdir_status=$?
if [ ${adjust_outdir_status} -ne 0 ];then
	echo 'ERROR : adjust_outdir fail'
	exit ${adjust_outdir_status}
fi
echo '==> end adjust_outdir'


echo '==> start upload_ftp'
upload_ftp 
upload_ftp_status=$?
if [ ${upload_ftp_status} -ne 0 ];then
	echo 'ERROR : upload_ftp fail'
	exit ${upload_ftp_status}
fi
echo '==> end upload_ftp'
echo '[INFO] PreScript Execute SUCCESS, congratulation!'
exit 0