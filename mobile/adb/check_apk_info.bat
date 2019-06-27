@ECHO OFF

ECHO [查看APK包信息]

ECHO -------------------------------

ECHO aapt dump badging %~nx1

aapt dump badging %1 > %~dp0%~n1.txt

ECHO [暂停3秒自动关闭...]

ping -n 3 127.0.0.1>nul
@ECHO ON