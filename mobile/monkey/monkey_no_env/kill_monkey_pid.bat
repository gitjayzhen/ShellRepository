@ECHO OFF
for /f "tokens=2" %%i in ('adb shell ps^| findstr "monkey"') do (
set YK_PID=%%i
echo
)
echo found com.yykk.phone PID is  %YK_PID%

IF NOT "%YK_PID%" == "" (
echo 准备kill掉monkey的进程
adb shell kill %YK_PID%
)

ping 127.0.0.1 -n 3 >nul
echo on
