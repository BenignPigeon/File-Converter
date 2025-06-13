:ocr_my_pdf_install_check
:: Check if ocrmypdf is installed
python -c "import ocrmypdf" 2>nul
if %errorlevel% neq 0 (
    echo OCRmyPDF not found. Installing now...
    pip install ocrmypdf
    if %errorlevel% neq 0 (
        echo Failed to install ocrmypdf. Please install it manually.
		pause
		exit /b    
    )

echo OCRmyPDF installed successfully.
) else (
    echo OCRmyPDF is already installed.
)

exit /b