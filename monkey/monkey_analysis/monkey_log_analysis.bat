@ECHO OFF

ECHO.:::::::::::::::::::::::::::::::::::::::::::::::::

ECHO.::             分析Monkey日志                  ::

ECHO.:::::::::::::::::::::::::::::::::::::::::::::::::

REM 方法一：手动设置Monkey日志路径

SET monkeyLogFile=F:\Monkey\1.0.0\20140825181801_monkey.log



REM 方法二：直接将Monkey日志拖到此bat文件上

IF NOT "%1"=="" SET monkeyLogFile=%1



ECHO.[ INFO ] Monkey日志: %monkeyLogFile%

ECHO.[ INFO ] 开始分析

SET blnException=0

ECHO.

ECHO.

REM 如果觉得分析太快，没有感觉，把下面注释去掉假装分析中，有停顿感

REM ping -n 2 127.0.0.1>nul



::ANR日志

FOR /F "delims=" %%a IN ('FINDSTR /C:"ANR" %monkeyLogFile%') DO ( 

    SET strANR=%%a

)



::崩溃日志

FOR /F "delims=" %%a IN ('FINDSTR /C:"CRASH" %monkeyLogFile%') DO ( 

    SET strCRASH=%%a

)

    

::异常日志

FOR /F "delims=" %%a IN ('FINDSTR /C:"Exception" %monkeyLogFile%') DO ( 

    SET strException=%%a

)



::正常

FOR /F "delims=" %%a IN ('FINDSTR /C:"Monkey finished" %monkeyLogFile%') DO ( 

    SET strFinished=%%a

)



IF NOT "%strANR%" == "" (

    ECHO.[ INFO ] 分析Monkey日志存在: ANR

    ECHO.[ INFO ] ------------------------------------

    ECHO.         "%strANR%"

    SET /a blnException+=1

    ECHO.

)



IF NOT "%strCRASH%" == "" (

    ECHO.[ INFO ] 分析Monkey日志存在: CRASH

    ECHO.[ INFO ] ------------------------------------

    ECHO.         "%strCRASH%"

    SET /a blnException+=1

    ECHO.

)



IF NOT "%strException%" == "" (

    ECHO.[ INFO ] 分析Monkey日志存在: 异常

    ECHO.[ INFO ] ------------------------------------

    ECHO.         "%strException%"

    SET /a blnException+=1

)



IF NOT "%strFinished%" == "" (

    ECHO.[ INFO ] 分析Monkey日志存在: 执行成功标记

    ECHO.[ INFO ] ------------------------------------

    ECHO.         "%strFinished%"

    ECHO.

) ELSE (

    IF %blnException% EQU 0 ECHO.[ INFO ] 分析Monkey日志结果: Monkey执行异常中断，请重新执行Monkey脚本!

    ECHO.

)



REM 如果blnException不为0，说明存在异常，改变字体为淡紫色

IF %blnException% NEQ 0 ( 

    Color 0D

    ECHO.[ INFO ] 分析Monkey日志结果:存在异常日志，请手工再仔细检查！

    ECHO.

) ELSE (

    ECHO.[ INFO ] 分析Monkey日志结果:正常

    ECHO.

)

ECHO.

ECHO.[ EXIT ] 按任意键关闭窗口...

PAUSE>nul