@ECHO OFF

COLOR 0A

ECHO.:::::::::::::::::::::::::::::::::::::::::::::::::
ECHO.::                                             ::
ECHO.::          手机录屏(安卓4.4及以上)            ::
ECHO.::                                             ::
ECHO.:::::::::::::::::::::::::::::::::::::::::::::::::

::**************在此修改目录**************************
SET pcDir=C:\Users\%username%\Pictures
SET phoneDir=/sdcard
::**************在此修改目录**************************

:recordstart

ECHO.[ HELP ] 操作步骤：
ECHO.         1、输入录制时间[回车]
ECHO.         2、按提示开始录制
SET /a SCTIME=10
ECHO.
SET /P SCTIME=[ INFO ] 请输入录制时间(默认10S):

:MyLoop

SET CONFIRM=TF

SET /P CONFIRM=[ INFO ] 确认开始录制？[Enter]

IF NOT "%CONFIRM%"=="TF" GOTO MyLoop

ECHO.

ECHO.[ EXEC ] 开始录制视频(Time: %SCTIME%S)

adb shell screenrecord --time-limit %SCTIME% %phoneDir%/screenrecord.mp4

:: 获取得小时,格式为：24小时制，10点前补0
SET c_time_hour=%time:~0,2%
IF /i %c_time_hour% LSS 10 (
SET c_time_hour=0%time:~1,1%
)

ECHO.[ INFO ] 录制结束
ECHO.
ECHO.[ EXEC ] 拷贝录屏至电脑
adb pull %phoneDir%/screenrecord.mp4 "%pcDir%\%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%.mp4"
ECHO.[ EXEC ] 打开视频保存目录
start %pcDir%
adb shell rm %phoneDir%/screenrecord.mp4
:BATend

ECHO.

ECHO.[ INFO ] 暂停3秒自动关闭...

ping -n 3 127.0.0.1>nul
