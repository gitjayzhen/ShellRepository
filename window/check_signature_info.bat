@ECHO OFF

ECHO.:::::::::::::::::::::::::::::::::::::::::::::::::
ECHO.::                                             ::
ECHO.::             查看APK签名信息                 ::
ECHO.::                                             ::
ECHO.:::::::::::::::::::::::::::::::::::::::::::::::::

Color 0A

ECHO.

ECHO.[ HELP ] 可查看RSA、APK、keystore签名信息

SET C_PATH=%~dp0

REM 方法：直接将APK或RSA文件到bat文件上

IF NOT "%1"=="" SET apkorFile=%1

IF "%~x1"==".RSA" GOTO RSAFile

IF "%~x1"==".rsa" GOTO RSAFile

IF "%~x1"==".apk" GOTO APKFile

IF "%~x1"==".APK" GOTO APKFile

IF "%~x1"==".keystore" GOTO KEYSTOREFile

IF "%~x1"==".KEYSTORE" GOTO KEYSTOREFile

Color 0D

ECHO.[ HELP ] 请将RSA或得APK或者keystore拖至Bat文件上

GOTO BATend


:KEYSTOREFile

DEL "%C_PATH%%~nx1.txt" 2>nul

ECHO.[ INFO ] INPUT：%apkorFile%

ECHO.[ INFO ] OUT: %C_PATH%%~nx1.txt

ECHO.

keytool -list -v -keystore %apkorFile% > "%C_PATH%%~nx1.txt"

type "%C_PATH%%~nx1.txt"

GOTO BATend


:RSAFile

DEL "%C_PATH%%~n1.RSA.txt" 2>nul

ECHO.[ INFO ] INPUT：%apkorFile%

ECHO.[ INFO ] OUT: %C_PATH%%~n1.RSA.txt

ECHO.

keytool -printcert -file %apkorFile% > "%C_PATH%%~n1.RSA.txt"

type "%C_PATH%%~n1.RSA.txt"

GOTO BATend


:APKFile

ECHO.[ INFO ] INPUT：%apkorFile%

ECHO.[ INFO ] OUT: %C_PATH%%~n1.RSA.txt

RD /S /Q %~n1_META-INF 2>nul

::jar tf %apkorFile%|Findstr "RSA"

::解压签名目录

jar -xf %apkorFile% META-INF

::重合名文件夹

REN META-INF %~n1_META-INF

::查看签名文件信息

CD %~n1_META-INF

FOR %%I IN (*.RSA) DO (

    ECHO.[ INFO ] %%I

    ECHO.

    keytool -printcert -file %%I > "%C_PATH%%~n1.RSA.txt"

    type "%C_PATH%%~n1.RSA.txt"

)

CD %~dp1

RD /S /Q %~n1_META-INF 2>nul



:BATend

ECHO.

ECHO.[ EXIT ] 按任意键关闭窗口...

PAUSE>nul
