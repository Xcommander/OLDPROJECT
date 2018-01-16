@echo off&setlocal enabledelayedexpansion
set str=aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ
::这一步将进行了转换，例如a=aA
for %%i in (%str%) do set "var=%%i" & set !var:~0,1!=%%i

set "TS="
set /P TS=请输入测试字符：
for /l %%i in (0 1 100) do (
		::取第几个字串
        set "T3=!TS:~%%i,1!"
        if "!T3!"=="" goto :Res
        if defined !T3! (
                set T2=!T3:~0,1!
                if "!T3!"=="!T2!" (
				::进行了两步转换，第一步是将set T2=%%a:~1,1%%,第二步变量延迟，set T2=%a:~1,1%,其实用到了两次变量延迟，每次变量延迟引用的变量发生了变化，第一次是引用了T3，第二次是引用了a
				call set T2=%%!T3!:~1,1%%
				)
				) else set "T2=!T3!"
        set Res=!Res!!T2!
)
:Res
echo.&echo 转换前：!TS!
echo 转换后：!Res!