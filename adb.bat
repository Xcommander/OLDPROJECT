@echo off
ping sz.tencent.com >a.txt
pause
::按下任意键继续
ping sz2.tencent.com >>a.txt
goto xlc
ping sz3.tencent.com >>a.txt
:xlc
if "%1"=="" echo "输入参数为空"
if "%1"=="xlc" echo "输入参数为“xlc”"
::call adb.bat
netstat -a -n >> a.txt
type a.txt | find "600" && echo "中病毒了吧！"
dir C:\ >a.txt && dir D:\ >>a.txt
dir a.ttt /a & dir a.txt || exit
pause && exit