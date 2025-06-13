@echo off

:ghostscript_install_check
gswin64c.exe -version >nul 2>nul
if %errorlevel% neq 0 (
    echo Ghostscript is not installed. Installing Ghostscript...

    :: Check if the script is running as Administrator
    net session >nul 2>nul
    if %errorlevel% neq 0 (
        :: Not running as admin, so elevate the process
        echo Elevating privileges to install Ghostscript...
        powershell -Command "Start-Process cmd.exe -ArgumentList '/c choco install ghostscript -y' -Verb RunAs"
        
        :: Wait for the user to finish the installation
        echo Please wait while Ghostscript is being installed...
        pause
    ) else (
        :: Already running as admin, install in the current window
        echo Installing Ghostscript using Chocolatey...
        choco install ghostscript -y
        
        :: Wait for the installation to finish
        echo Please wait while Ghostscript is being installed...
        timeout /t 10 /nobreak >nul
    )

    echo Ghostscript installed successfully.
) else (
    echo Ghostscript is already installed.
)
exit /b
