@echo off
adb wait-for-devices

rem SSN
adb shell /data/data/PhoneInfoTest 0 1 G6AXGY0001204AM
:WAIT
adb shell /data/data/PhoneInfoTest 0 0

rem IMEI
adb shell /data/data/PhoneInfoTest 1 1 351929080027787
adb shell /data/data/PhoneInfoTest 1 2 351929080027795
:WAIT
adb shell /data/data/PhoneInfoTest 1 0

rem BT MAC
adb shell /data/data/PhoneInfoTest 2 1 38D54703CD21
:WAIT
adb shell /data/data/PhoneInfoTest 2 0

rem WiFi MAC
adb shell /data/data/PhoneInfoTest 3 1 38D5475E93E6
:WAIT
adb shell /data/data/PhoneInfoTest 3 0

rem ISN
adb shell /data/data/PhoneInfoTest 4 1 E281C671106011
:WAIT
adb shell /data/data/PhoneInfoTest 4 0

rem Country code 
adb shell /data/data/PhoneInfoTest 6 1 WW
:WAIT
adb shell /data/data/PhoneInfoTest 6 0

rem Color ID
adb shell /data/data/PhoneInfoTest 7 1 ab
:WAIT
adb shell /data/data/PhoneInfoTest 7 0

rem Customer ID
adb shell /data/data/PhoneInfoTest 8 1 SKD
:WAIT
adb shell /data/data/PhoneInfoTest 8 0

rem Packing code
adb shell /data/data/PhoneInfoTest 9 1 WW
:WAIT
adb shell /data/data/PhoneInfoTest 9 0

rem MEID
adb shell /data/data/PhoneInfoTest 11 1 99000618950346
:WAIT
adb shell /data/data/PhoneInfoTest 11 0


adb reboot
adb wait-for-devices

rem SSN
adb shell getprop ro.serialno

rem IMEI
adb shell getprop persist.radio.device.imei
adb shell getprop persist.radio.device.imei2

rem BT MAC
adb shell getprop ro.btmac

rem WiFi MAC
adb shell getprop ro.wifimac

rem ISN
adb shell getprop ro.isn

rem Country code
adb shell getprop ro.config.versatility

rem Color ID
adb shell getprop ro.config.idcode

rem Customer ID
adb shell getprop ro.config.CID

rem Packing code
adb shell getprop ro.config.revenuecountry

rem MEID
adb shell getprop persist.radio.device.meid

pause
