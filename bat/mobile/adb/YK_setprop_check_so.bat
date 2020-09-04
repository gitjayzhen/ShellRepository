@ECHO OFF

echo ------需要手机连接上电脑----------------------------

echo 使用adb shell setprop进行log日志配置：

adb shell setprop debug.adoplayer.log.component 127

adb shell setprop debug.adoplayer.log.level info

adb shell setprop debug.adoplayer.log.option pts

echo -----已配置完成-------------------------------------

echo -----打印配置结果-----------------------------------

adb shell getprop | findstr debug.adoplayer.log

ping 127.0.0.1 -n 1 >nul

echo -----查看so文件是否存在-----------------------------

adb shell ls /sdcard/ | findstr .so$

echo -----3秒后结束执行----------------------------------

ping 127.0.0.1 -n 3 >nul

@ECHO ON
