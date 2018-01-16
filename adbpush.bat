@echo off
setlocal enabledelayedexpansion
::参数设定-----start
set zip=C:\Program Files\WinRAR\WinRAR.exe
set apk_where=X
set path_out=D:\
::参数设定-----end
set path_in=%apk_where%:\out.txt.apk
set path_out_file=%path_out%out.txt
set package_name_pre=com.android.
echo %path_out_file%
call :judge_file
call :readfile
set apk_name=%file%.apk
set apk_location_where=%apk_where%:\%file%.apk
echo 要导入的apk为:%apk_name%
call :change_upper_to_lower %file%
set package_name=%package_name_pre%%apk_lower%
echo %package_name%
call :excute_adb
goto :eof




::判断out.txt文件是否存在,并且解压打包的apk文件
:judge_file
if exist "D:\out.txt" (
	echo 存在out.txt文件，开始删除
	del D:\out.txt
	echo 开始解压.......
	call :unzip
) else (
	echo 不存在out.txt文件，开始解压.......
	call :unzip
)
goto :eof


::解压out.txt.apk文件
:unzip
if not exist %path_in% (
	echo 不存在编译相关文件，请重新导出
	goto :end
) else (
	"%zip%" e %path_in% %path_out%
)
goto :eof


::读取out.txt文件
:readfile
for /f "delims=" %%i in (%path_out_file%) do (
	set apk_location=%%i
	::获取%%i路径中最后一个\后的文件名
	set file=%%~ni
)
goto :eof


::执行相关adb指令
:excute_adb
adb remount
call :handle_num %apk_name% 0
set apk_num=%num%
call :handle_num %apk_location% 0
echo %apk_location%
set path_num=%num%
::这里用到了变量嵌套,也就是变量延迟扩展
set path_apk=!apk_location:~0,-%apk_num%!
set apk_arm=%path_apk%arm
set apk_arm_64=%path_apk%arm64
echo %apk_arm%
echo %apk_arm_64%
::开始删除相关odex
adb shell rm -rf %apk_arm%
adb shell rm -rf %apk_arm_64%
::push 到手机去
adb push %apk_location_where%  %apk_location%
::强制停止应用
adb shell am force-stop %package_name%
::清除数据
adb shell pm clear %package_name%
::重启应用
adb shell am start %package_name%
goto :eof


::处理各个字串
:handle_num
set str=%1
set num=%2
call :cal_num
goto :eof


::计算字串的长度
:cal_num
if not "%str%"=="" (
	set /a num+=1
	set str=%str:~1%
	goto Cal_num
) else (
	::echo %num%
	goto :eof
	)

::转换大小写
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
	::这个利用%x:~0,1%中的x不区分大小写来的，例如%x:~0,1%和%X:~0,1%效果是一样的
	call set ty=%%!tx!:~0,1%%
	set apk_lower=!apk_lower!!ty!
	)
:end
