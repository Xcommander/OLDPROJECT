@echo off
setlocal enabledelayedexpansion
::�����趨-----start
set zip=C:\Program Files\WinRAR\WinRAR.exe
set apk_where=X
set path_out=D:\
::�����趨-----end
set path_in=%apk_where%:\out.txt.apk
set path_out_file=%path_out%out.txt
set package_name_pre=com.android.
echo %path_out_file%
call :judge_file
call :readfile
set apk_name=%file%.apk
set apk_location_where=%apk_where%:\%file%.apk
echo Ҫ�����apkΪ:%apk_name%
call :change_upper_to_lower %file%
set package_name=%package_name_pre%%apk_lower%
echo %package_name%
call :excute_adb
goto :eof




::�ж�out.txt�ļ��Ƿ����,���ҽ�ѹ�����apk�ļ�
:judge_file
if exist "D:\out.txt" (
	echo ����out.txt�ļ�����ʼɾ��
	del D:\out.txt
	echo ��ʼ��ѹ.......
	call :unzip
) else (
	echo ������out.txt�ļ�����ʼ��ѹ.......
	call :unzip
)
goto :eof


::��ѹout.txt.apk�ļ�
:unzip
if not exist %path_in% (
	echo �����ڱ�������ļ��������µ���
	goto :end
) else (
	"%zip%" e %path_in% %path_out%
)
goto :eof


::��ȡout.txt�ļ�
:readfile
for /f "delims=" %%i in (%path_out_file%) do (
	set apk_location=%%i
	::��ȡ%%i·�������һ��\����ļ���
	set file=%%~ni
)
goto :eof


::ִ�����adbָ��
:excute_adb
adb remount
call :handle_num %apk_name% 0
set apk_num=%num%
call :handle_num %apk_location% 0
echo %apk_location%
set path_num=%num%
::�����õ��˱���Ƕ��,Ҳ���Ǳ����ӳ���չ
set path_apk=!apk_location:~0,-%apk_num%!
set apk_arm=%path_apk%arm
set apk_arm_64=%path_apk%arm64
echo %apk_arm%
echo %apk_arm_64%
::��ʼɾ�����odex
adb shell rm -rf %apk_arm%
adb shell rm -rf %apk_arm_64%
::push ���ֻ�ȥ
adb push %apk_location_where%  %apk_location%
::ǿ��ֹͣӦ��
adb shell am force-stop %package_name%
::�������
adb shell pm clear %package_name%
::����Ӧ��
adb shell am start %package_name%
goto :eof


::��������ִ�
:handle_num
set str=%1
set num=%2
call :cal_num
goto :eof


::�����ִ��ĳ���
:cal_num
if not "%str%"=="" (
	set /a num+=1
	set str=%str:~1%
	goto Cal_num
) else (
	::echo %num%
	goto :eof
	)

::ת����Сд
:change_upper_to_lower
set str=aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ
for %%i in (%str%) do (
	set var=%%i
	set !var:~0,1!=%%i
	
)
set tmp=%1
for /l %%i in (0,1,50) do (
	set tx=!tmp:~%%i,1!
	if "!tx!"=="" goto :eof
	::�������%x:~0,1%�е�x�����ִ�Сд���ģ�����%x:~0,1%��%X:~0,1%Ч����һ����
	call set ty=%%!tx!:~0,1%%
	set apk_lower=!apk_lower!!ty!
	)
:end
