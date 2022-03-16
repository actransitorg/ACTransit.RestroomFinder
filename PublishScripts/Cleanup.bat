@echo off
pushd
cd ..
rem attrib -r -h *.* /s
taskkill /pid VBCSCompiler.exe /f 1>nul 2>nul
del nuget.exe 1>nul 2>nul
rd /s /q "dist" 2>nul
if NOT "%1"=="" rd /s /q "%1" 1>nul 2>nul
rd /s /q "packages" 2>nul
rd /s /q ".DS_Store" 2>nul
rd /s /q ".vs" 2>nul
rem del /s /f /q "*.vspscc" 2>nul
del /s /f /q "*.vssscc" 2>nul
rem del /s /f /q "*.suo" 2>nul
del /s /f /q "*.user" 2>nul
del /s /f /q "Backup *.*" 2>nul
del /s /f /q "TestResults" 2>nul
for /D /R %%D in (node_modules) do @if exist "%%D" rd /s/q "%%D"
for /D /R %%D in (packages) do @if exist "%%D" rd /s/q "%%D"
for /D /R %%D in (obj) do @if exist "%%D" rd /s/q "%%D"
for /D /R %%D in (bin) do @if exist "%%D" rd /s/q "%%D"
rem for /D /R %%D in (Debug) do @if exist "%%D" rd /s/q "%%D"
rem for /D /R %%D in (Nuget) do @if exist "%%D" rd /s/q "%%D"
rem for /D /R %%D in (Release) do @if exist "%%D" rd /s/q "%%D"
popd