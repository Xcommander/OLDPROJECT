@echo off&setlocal enabledelayedexpansion
set str=aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ
::��һ����������ת��������a=aA
for %%i in (%str%) do set "var=%%i" & set !var:~0,1!=%%i

set "TS="
set /P TS=����������ַ���
for /l %%i in (0 1 100) do (
		::ȡ�ڼ����ִ�
        set "T3=!TS:~%%i,1!"
        if "!T3!"=="" goto :Res
        if defined !T3! (
                set T2=!T3:~0,1!
                if "!T3!"=="!T2!" (
				::����������ת������һ���ǽ�set T2=%%a:~1,1%%,�ڶ��������ӳ٣�set T2=%a:~1,1%,��ʵ�õ������α����ӳ٣�ÿ�α����ӳ����õı��������˱仯����һ����������T3���ڶ�����������a
				call set T2=%%!T3!:~1,1%%
				)
				) else set "T2=!T3!"
        set Res=!Res!!T2!
)
:Res
echo.&echo ת��ǰ��!TS!
echo ת����!Res!