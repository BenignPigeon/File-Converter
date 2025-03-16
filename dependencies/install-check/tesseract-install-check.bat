:tesseract_install_check
:: Check if tesseract is installed
tesseract --version >nul 2>nul
if %errorlevel% neq 0 (
    echo Tesseract is not installed. Installing Tesseract using winget...
    winget install --id tesseract-ocr.tesseract -e --source winget --silent
    if %errorlevel% neq 0 (
        echo Failed to install Tesseract. Please install Tesseract manually and ensure it's in your PATH.
		pause
		exit /b
    )
    echo Tesseract installed successfully.
) else (
    echo Tesseract is already installed.
)
exit /b