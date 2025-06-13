:: Check if eml2pdf is installed
python -c "import eml2pdf" 2>nul
if %errorlevel% == 0 (
    echo Updating EML2PDF...
    pip install --upgrade eml2pdf
    if %errorlevel% neq 0 (
        echo Failed to update EML2PDF. Please check the error above.
        
    ) else (
        echo EML2PDF has been successfully updated!
        
    )
) else (
    echo eml2pdf is not installed. Skipping update.
    
)
exit /b