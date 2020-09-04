@ECHO OFF

ECHO.[Quick cell phone screenshots]

ECHO.-------------------------------

ECHO.[Exce ] Mobile phone screen

SET pcDir=C:\Users\%username%\Pictures\img

adb shell screencap -p /sdcard/screen.png

ECHO.[Tips ] Copy the screenshot to your computer

adb pull /sdcard/screen.png "%pcDir%\%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%.png"

ren "C:\Users\jayzhen\Desktop\screen.png"  "%pcDir%\%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%.png"

adb shell rm /sdcard/screen.png

ECHO [Pause for 3 seconds and close automatically...]

ping -n 2 127.0.0.1>nul

@ECHO ON