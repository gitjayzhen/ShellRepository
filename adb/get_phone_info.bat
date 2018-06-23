@ECHO OFF 

ECHO [读取手机信息]

ECHO -------------------------------

adb shell cat /system/build.prop>%~dp0\phone.info

FOR /F "tokens=1,2 delims==" %%a in (phone.info) do (

 IF %%a == ro.build.version.release SET androidOS=%%b

 IF %%a == ro.product.model SET model=%%b

 IF %%a == ro.product.brand SET brand=%%b

)

del /a/f/q %~dp0\phone.info

ECHO.

ECHO.手机品牌: %brand%

ECHO.手机型号: %model%

ECHO.系统版本: Android %androidOS%

ECHO.-------------------------------

ECHO.手机品牌: %brand%>>"%~dp0\Phone_%model%.txt"

ECHO.手机型号: %model%>>"%~dp0\Phone_%model%.txt"

ECHO.系统版本: Android %androidOS%>>"%~dp0\Phone_%model%.txt"

ECHO [暂停5秒自动关闭...]

ping -n 5 127.0.0.1>nul

@ECHO ON