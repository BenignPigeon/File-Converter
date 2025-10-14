@echo off
setlocal enabledelayedexpansion

:: Check if Tesseract is installed
tesseract --version >nul 2>nul
if %errorlevel% neq 0 (
    echo [INFO] Tesseract not installed. Installing via winget...

    where winget >nul 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] winget not found. Please install "App Installer" from Microsoft Store.
        pause
        exit /b 1
    )

    winget -ArgumentList 'install --id tesseract-ocr.tesseract -e --source winget --accept-source-agreements --accept-package-agreements'

    if %errorlevel% neq 0 (
        echo [ERROR] Failed to install Tesseract. Please install manually and ensure it's in your PATH.
        pause
        exit /b 1
    )

    set "TESSERACT_PATH=C:\Program Files\Tesseract-OCR"

    if not exist "%TESSERACT_PATH%\tesseract.exe" (
        echo [ERROR] Tesseract installation path not found: %TESSERACT_PATH%
        echo Please install manually and ensure it's in your PATH.
        pause
        exit /b 1
    )

    :: Safely update user PATH
    for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "USER_PATH=%%B"

    echo %USER_PATH% | find /I "%TESSERACT_PATH%" >nul
    if %errorlevel% neq 0 (
        echo [INFO] Adding Tesseract to user PATH...
        setx PATH "%USER_PATH%;%TESSERACT_PATH%"
        echo [OK] Tesseract path added.
    )

    echo Tesseract installed successfully.
) else (
    echo Tesseract is already installed.
)

exit /b
