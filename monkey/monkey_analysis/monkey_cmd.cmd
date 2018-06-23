:loop

adb2 shell monkey  -p sogou.mobile.explorer --monitor-native-crashes  --pct-touch 80 --pct-motion 15 --pct-nav 5 -s %random% -v  --throttle 200 320000 >common\%random%.log

@ping -n 15 127.1 >nul

adb2 reboot

@ping -n 120 127.1 >nul

@goto loop