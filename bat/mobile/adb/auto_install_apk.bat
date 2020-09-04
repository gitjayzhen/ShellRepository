@ECHO OFF

ECHO [安装APK]

ECHO -------------------------------

ECHO [等待插入手机...]

adb wait-for-device

ECHO [覆盖安装] %~nx1

adb install -r %1

ECHO [暂停5秒自动关闭...]

ping -n 5 127.0.0.1>nul

@ECHO ON