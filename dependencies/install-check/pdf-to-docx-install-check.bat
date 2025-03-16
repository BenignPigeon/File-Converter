:pdf_to_docx_install_check
:: Check if pdf2docx is installed
python -c "import pdf2docx" 2>nul
if %errorlevel% neq 0 (
    echo Pdf2Docx not found. Installing now...
    pip install pdf2docx
    if %errorlevel% neq 0 (
        echo Failed to install pdf2docx. Please install it manually.
		pause
		exit /b    
    )

echo Pdf2Docx installed successfully.
) else (
    echo Pdf2Docx is already installed.
)

exit /b