exit
echo off
cd %~dp0
echo * Current Directory: %~dp0
echo * Parameters: %*
powershell.exe -ExecutionPolicy Unrestricted .\publish.ps1 %*
rem echo Errorlevel: %ERRORLEVEL%
rem if %ERRORLEVEL%==1 (powershell.exe -ExecutionPolicy Bypass %~dp0publish.ps1 %*)