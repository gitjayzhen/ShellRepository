@ECHO OFF

ECHO.:::::::::::::::::::::::::::::::::::::::::::::::::
ECHO.::                                             ::
ECHO.::        Activity启动跳转时间监控             ::
ECHO.::                                             ::
ECHO.:::::::::::::::::::::::::::::::::::::::::::::::::


ECHO.[ INFO ] 清空日志

adb logcat -c

ECHO.[ INFO ] 监控开始(Ctrl+C结束)

ECHO.[ INFO ] 保存请拷贝输出内容

adb logcat -s ActivityManager | Findstr /C:": Displayed"