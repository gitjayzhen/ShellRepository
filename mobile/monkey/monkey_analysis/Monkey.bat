@ECHO OFF

ECHO.:::::::::::::::::::::::::::::::::::::::::::::::::

ECHO.::                 Monkey测试                  ::

ECHO.:::::::::::::::::::::::::::::::::::::::::::::::::

IF NOT EXIST %~dp0\config.conf GOTO EXIT

ECHO.[ INFO ] 准备Monkey测试

ECHO.[ INFO ] 读取config.conf中信息



REM 从配置文件中获得包名

FOR /F "tokens=1,2 delims==" %%a in (config.conf) do (

    IF %%a == packageName SET packageName=%%b

    IF %%a == appEnName SET appEnName=%%b

    IF %%a == appversion SET appversion=%%b

)



REM 获取日期,格式为：20140808

SET c_date=%date:~0,4%%date:~5,2%%date:~8,2%

REM 获取得小时,格式为：24小时制，10点前补0

SET c_time=%time:~0,2%

    IF /i %c_time% LSS 10 (

SET c_time=0%time:~1,1%

)

REM 组合小时、分、秒，格式为: 131420

SET c_time=%c_time%%time:~3,2%%time:~6,2%

REM 将当运行时间点做为日志文件名

SET logfilename=%c_date%%c_time%





REM 创建当天日期目录及测试APP日志保存目录

IF NOT EXIST %~dp0\%c_date%    md %~dp0\%c_date%

SET logdir="%~dp0\%c_date%\%appEnName%%appversion%"

IF NOT EXIST %logdir% (

    ECHO.[ Exec ] 创建目录：%c_date%\%appEnName%%appversion%

    md %logdir%

)





REM 获得手机信息，显示并保存

adb shell cat /system/build.prop>phone.info

FOR /F "tokens=1,2 delims==" %%a in (phone.info) do (

    IF %%a == ro.build.version.release SET androidOS=%%b

    IF %%a == ro.product.model SET model=%%b

    IF %%a == ro.product.brand SET brand=%%b

)

del /a/f/q phone.info

ECHO.[ INFO ] 读取Phone信息

ECHO.         手机品牌: %brand%

ECHO.         手机型号: %model%

ECHO.         系统版本: Android %androidOS%

ECHO.Phone信息>"%logdir%\%logfilename%_%model%.txt"

ECHO.手机品牌: %brand%>>"%logdir%\%logfilename%_%model%.txt"

ECHO.手机型号: %model%>>"%logdir%\%logfilename%_%model%.txt"

ECHO.系统版本: Android %androidOS%>>"%logdir%\%logfilename%_%model%.txt"



ECHO.

ECHO.[ Exec ] 使用Logcat清空Phone中log

adb logcat -c

REM ECHO.[ INFO ] 暂停2秒...

ping -n 2 127.0.0.1>nul

ECHO.

ECHO.[ INFO ] 开始执行Monkey命令

REM ECHO.[ INFO ] 强制关闭准备测试的APP

adb shell am force-stop %packageName%



:::::::::::::::::Monkey测试命令::::::::::::::::::::::::

::::::::::::修改策略请仅在此区域内修改:::::::::::::::::

ECHO.[ Exec ] adb shell monkey -p %packageName% -s %c_time%  --throttle 500 -v -v -v 10000



adb shell monkey -p %packageName% -s %c_time% --throttle 500 -v -v -v 10000>%logdir%\%logfilename%_monkey.log



::::::::::::修改策略请仅在此区域内修改:::::::::::::::::

::::::::::::::::::::::END::::::::::::::::::::::::::::::

ECHO.[ INFO ] 执行Monkey命令结束

ECHO.



ECHO.[ Exce ] 手机截屏

adb shell screencap -p /sdcard/monkey_run_end.png

ECHO.[ INFO ] 拷贝截屏图片至电脑

adb pull /sdcard/monkey_run_end.png %logdir%

cd %logdir%

ren monkey_run_end.png %logfilename%.png



ECHO.

ECHO.[ Exec ] 使用Logcat导出日志

adb logcat -d >%logdir%\%logfilename%_logcat.log



REM ECHO.

REM ECHO.[ Exec ] 导出traces文件

REM adb shell cat /data/anr/traces.txt>%logfilename%_traces.log





REM 待扩展,上传日志至服务器



:EXIT

ECHO.

ECHO.[ INFO ] 请按任意键关闭窗口...
PAUSE>nul