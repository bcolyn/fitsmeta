@echo off
SET THEFILE=D:\Source\Home\fitsmeta\fitsmeta.exe
echo Linking %THEFILE%
C:\lazarus\fpc\3.0.4\bin\x86_64-win64\ld.exe -b pei-x86-64  --gc-sections  -s --subsystem windows --entry=_WinMainCRTStartup    -o D:\Source\Home\fitsmeta\fitsmeta.exe D:\Source\Home\fitsmeta\link.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occurred while assembling %THEFILE%
goto end
:linkend
echo An error occurred while linking %THEFILE%
:end
