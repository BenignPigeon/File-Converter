@echo off
setlocal enabledelayedexpansion

where pandoc >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Pandoc not found — installing via winget...
    where winget >nul 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] winget not available. Please install "App Installer" from Microsoft Store.
        pause
        exit /b 1
    )
    call winget install --id JohnMacFarlane.Pandoc --silent --accept-source-agreements --accept-package-agreements
    if %errorlevel% neq 0 (
        echo [ERROR] Pandoc installation failed.
        pause
        exit /b 1
    )
    echo Pandoc installed successfully.
) else (
    echo Pandoc is already installed.
)
exit /b
