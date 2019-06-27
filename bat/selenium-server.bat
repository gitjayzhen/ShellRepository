@echo off
if "%1" == "h" goto begin
mshta vbscript:createobject("wscript.shell").run("%~nx0 h",0)(window.close)&&exit
                               :begin
                               chcp 65001
                               setlocal enabledelayedexpansion
:: 设置端口号
set port=5037   
:: 设置当前目录下的文件名
set filepath="node.log"
:: 设置taskkill /f /pid !pid!
for /f "tokens=1-5" %%a in ('netstat -ano ^| findstr LISTENING ^| findstr ":%port%"') do (
    if "%%e%" == "" (
        set pid=%%d
    ) else (
        set pid=%%e
    )
    echo !pid! service is running
	taskkill /f /pid !pid!
	goto delefile
	echo ===================
)
:: 查看是否有某个文件并将其删除,并检查
:delefile
if exist %filepath% (
	echo %filepath% is exist
	del %filepath%
	goto delefile
) else (
	echo %filepath% is not exist
)
:: 启动node服务，不同的情况不同设置 注意不同的项目有不同的路径
start /b java -jar selenium-server-standalone-2.53.1.jar -Dwebdriver.chrome.driver="driver/chromedriver.exe" -browser browserName="chrome" -log node.log