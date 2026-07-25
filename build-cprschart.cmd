@echo off
setlocal

set "BUILD_CONFIG=%~1"
if "%BUILD_CONFIG%"=="" set "BUILD_CONFIG=Debug"

set "BUILD_PLATFORM=%~2"
if "%BUILD_PLATFORM%"=="" set "BUILD_PLATFORM=Win32"

set "ROOT=%~dp0"
set "PROJECT=%ROOT%CPRS-Chart\CPRSChart.dproj"

if not exist "%PROJECT%" (
  echo CPRSChart.dproj was not found at "%PROJECT%".
  exit /b 1
)

if not defined BDS (
  if exist "D:\Embarcadero\Studio\23.0\bin\rsvars.bat" (
    call "D:\Embarcadero\Studio\23.0\bin\rsvars.bat"
  ) else if exist "%ProgramFiles(x86)%\Embarcadero\Studio\23.0\bin\rsvars.bat" (
    call "%ProgramFiles(x86)%\Embarcadero\Studio\23.0\bin\rsvars.bat"
  ) else (
    echo Delphi rsvars.bat was not found. Run this from an initialized RAD Studio command prompt or update this script.
    exit /b 1
  )
)

set "MSBUILD=msbuild"
where msbuild >nul 2>nul
if errorlevel 1 set "MSBUILD=%WINDIR%\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"

set "BUILD_LOG=%TEMP%\cprschart-build-%RANDOM%.log"
"%MSBUILD%" "%PROJECT%" /t:Build /p:Config=%BUILD_CONFIG% /p:Platform=%BUILD_PLATFORM% /v:minimal >"%BUILD_LOG%" 2>&1
set "BUILD_EXIT=%ERRORLEVEL%"
type "%BUILD_LOG%"

findstr /C:"does not support command line compiling" "%BUILD_LOG%" >nul 2>nul
if not errorlevel 1 (
  del "%BUILD_LOG%" >nul 2>nul
  exit /b 1
)

del "%BUILD_LOG%" >nul 2>nul
exit /b %BUILD_EXIT%
