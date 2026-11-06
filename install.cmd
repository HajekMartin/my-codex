@echo off
setlocal
rem Interactive launcher: preserve output even if PowerShell cannot start the script.
powershell.exe -NoLogo -NoProfile -File "%~dp0scripts\install.ps1"
set "install_exit_code=%errorlevel%"
echo.
if not "%install_exit_code%"=="0" (
    echo Installation failed. Read the error above before closing this window.
)
pause
exit /b %install_exit_code%
