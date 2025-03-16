:ocr_my_pdf_install_check
:: Check if ocrmypdf is installed
python -c "import ocrmypdf" 2>nul
if %errorlevel% == 0 (
    echo OCRmyPDF not found. Installing now...
    pip install --upgrade ocrmypdf
    if %errorlevel% neq 0 (
        echo Failed to update OCRmyPDF. Please check the error above.
       
    ) else (
        echo OCRmyPDF has been successfully updated!
        
    )
) else (
    echo OCRmyPDF is not installed. Skipping update. 
)
exit /b