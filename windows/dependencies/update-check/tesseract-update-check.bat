:tesseract_install_check
:: Check if tesseract is installed
tesseract --version >nul 2>nul
if %errorlevel% == 0 (
    echo Updating Tesseract using winget...
    winget upgrade tesseract-ocr.tesseract --silent
    if %errorlevel% neq 0 (
        echo Failed to update Tesseract. Please check the error above.
       
    ) else (
        echo Tesseract has been successfully updated!
        
    )
) else (
    echo Tesseract is not installed. Skipping update. 
)
exit /b

