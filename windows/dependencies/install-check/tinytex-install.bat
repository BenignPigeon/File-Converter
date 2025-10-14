@echo off
setlocal enabledelayedexpansion

where tlmgr >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] TinyTeX not found — installing via Chocolatey...
    where choco >nul 2>&1
    if %errorlevel% neq 0 (
        echo [INFO] Chocolatey not found — running choco-install-check.bat...
        if exist "%~dp0choco-install-check.bat" (
            call choco-install-check.bat
        ) else (
            echo [ERROR] choco-install-check.bat not found. Install Chocolatey manually.
            pause
            exit /b 1
        )
    )
    powershell -Command "Start-Process cmd -ArgumentList '/c choco install tinytex -y --no-progress' -Verb RunAs -Wait"
    if %errorlevel% neq 0 (
        echo [ERROR] TinyTeX installation failed.
        pause
        exit /b 1
    )
    echo TinyTeX installed successfully.
) else (
    echo TinyTeX is already installed.
)
exit /b
