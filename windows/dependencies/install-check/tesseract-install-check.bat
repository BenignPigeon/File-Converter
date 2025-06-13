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
        
    SET "TESSERACT_PATH=C:\Program Files\Tesseract-OCR"

    :: Check if the path exists
    IF NOT EXIST "%TESSERACT_PATH%\tesseract.exe" (
        echo Failed to install Tesseract. Please install Tesseract manually and ensure it's in your PATH.
        pause
        exit /b
    )

    :: Add to user PATH if not already present
    echo %PATH% | find /I "%TESSERACT_PATH%" >nul
    IF %errorlevel% neq 0 (
        echo Adding Tesseract to user PATH...
        setx PATH "%PATH%;%TESSERACT_PATH%"
        echo Tesseract path added.
    )


    echo Tesseract installed successfully.
) else (
    echo Tesseract is already installed.
)
exit /b