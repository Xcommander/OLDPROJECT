@echo off
ping sz.tencent.com >a.txt
pause
::�������������
ping sz2.tencent.com >>a.txt
goto xlc
ping sz3.tencent.com >>a.txt
:xlc
if "%1"=="" echo "�������Ϊ��"
if "%1"=="xlc" echo "�������Ϊ��xlc��"
::call adb.bat
netstat -a -n >> a.txt
type a.txt | find "600" && echo "�в����˰ɣ�"
dir C:\ >a.txt && dir D:\ >>a.txt
dir a.ttt /a & dir a.txt || exit
pause && exit