@ECHO OFF

ECHO.[快速手机截屏]

ECHO.-------------------------------

ECHO.[Exce ] 手机截屏

adb shell screencap -p /sdcard/screen.png

ECHO.[Tips ] 拷贝截屏图片至电脑

adb pull /sdcard/screen.png "C:\Users\jayzhen\Desktop\screen.png"

ren "C:\Users\jayzhen\Desktop\screen.png"  "%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%.png"

adb shell rm /sdcard/screen.png

ECHO [暂停2秒自动关闭...]

ping -n 2 127.0.0.1>nul

@ECHO ON