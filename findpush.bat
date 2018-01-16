@echo off
set location=T:\华硕需求\apk\高德定位\3rd_party\autonavi-7.5.8.S017\autonavi\lib\armeabi
set dLocation=system/priv-app/autonavi/arm64/
for /f "delims=" %%a in ('dir /b %location%') do ( 
adb push %location%\%%a %dLocation%
)

pause