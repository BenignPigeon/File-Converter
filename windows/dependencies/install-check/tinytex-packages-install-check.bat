@echo off
setlocal enabledelayedexpansion

where tlmgr >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] tlmgr not found. Installing TinyTeX first...
    if exist "%~dp0tinytex-install-check.bat" (
            call tinytex-install-check.bat
        ) else (
            echo [ERROR] tinytex-install-check.bat not found. Install TinyTex manually.
            pause
            exit /b 1
        )
    pause
    exit /b 1
)

for /f "tokens=2 delims=:" %%A in ('tlmgr info collection-latexrecommended ^| findstr /C:"installed:"') do set "INSTALLED=%%A"
set "INSTALLED=!INSTALLED: =!"

if /i "!INSTALLED!"=="Yes" (
    echo LaTeX Collection is already installed.
) else (
    echo Installing LaTeX recommended collection...
    powershell -Command "Start-Process cmd -ArgumentList '/c tlmgr install collection-latexrecommended' -Verb RunAs -Wait"
    if !errorlevel! neq 0 (
        echo [ERROR] Installation failed.
        pause
        exit /b 1
    )
    echo LaTeX Collection installed successfully.
)
exit /b
