@ECHO OFF

COLOR 0A

ECHO.:::::::::::::::::::::::::::::::::::::::::::::::::::::
ECHO.::                                                 ::
ECHO.:: Mobile video recording (android 4.4 and above)  ::
ECHO.::                                                 ::
ECHO.:::::::::::::::::::::::::::::::::::::::::::::::::::::

::**************在此修改目录**************************
SET pcDir=C:\Users\%username%\Pictures
SET phoneDir=/sdcard
::**************在此修改目录**************************

:recordstart

ECHO.[ HELP ] steps :
ECHO.          1 set time [enter] 
ECHO.          2 Follow the instructions to start recording 
SET /a SCTIME=10
ECHO.
SET /P SCTIME=[ INFO ] please inter record time limit(defaul 10s):

:MyLoop

SET CONFIRM=TF

SET /P CONFIRM=[ INFO ] Confirm to start recording?[Enter]

IF NOT "%CONFIRM%"=="TF" GOTO MyLoop

ECHO.

ECHO.[ EXEC ] Start recording video(Time: %SCTIME%S)

adb shell screenrecord --time-limit %SCTIME% %phoneDir%/screenrecord.mp4

:: 获取得小时,格式为：24小时制，10点前补0
SET c_time_hour=%time:~0,2%
IF /i %c_time_hour% LSS 10 (
SET c_time_hour=0%time:~1,1%
)

ECHO.[ INFO ] End of the recording
ECHO.
ECHO.[ EXEC ] Copy the recording screen to the computer
adb pull %phoneDir%/screenrecord.mp4 "%pcDir%\%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%.mp4"
ECHO.[ EXEC ] Open the video save directory
start %pcDir%
adb shell rm %phoneDir%/screenrecord.mp4
:BATend

ECHO.

ECHO.[ INFO ] Pause for 3 seconds and close automatically...

ping -n 10 127.0.0.1>nul