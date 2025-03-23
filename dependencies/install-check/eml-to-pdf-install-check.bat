:eml_to_pdf_install_check
:: Check if eml2pdf is installed
python -c "import eml2pdf" 2>nul
if %errorlevel% neq 0 (
    echo EML2PDF not found. Installing now...
    pip install eml2pdf
    if %errorlevel% neq 0 (
        echo Failed to install eml2pdf. Please install it manually.
		pause
		exit /b    
    )

echo EML2PDF installed successfully.
) else (
    echo EML2PDF is already installed.
)

exit /b