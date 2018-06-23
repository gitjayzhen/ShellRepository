@echo off &setlocal enabledelayedexpansion
::set your port
set PORT_BASE=5555

::list the device
adb devices |findstr /i "\<device\>" >nul
if "%errorlevel%" neq "0" (
echo "device not found."
goto :eof
)

::set devices serial
for /f "tokens=1" %%i in ('adb devices^|findstr "\<device\>"') do (
set device_serial=%%i
echo
)
echo found devices %device_serial%

::find IP for the phone
for /f "tokens=3 delims= " %%i in ('adb shell ifconfig wlan0') do (
set phone_ip=%%i
)
echo device ip is %phone_ip%

echo "Connecting......"
adb -s %device_serial% tcpip %PORT_BASE%
adb -s %device_serial% connect %phone_ip%:%PORT_BASE%

echo Done
adb devices -l
ping -n 50 127.0.0.1 >&2 >nul
