:: Check if pdf2docx is installed
python -c "import pdf2docx" 2>nul
if %errorlevel% == 0 (
    echo Updating PDF2DOCX...
    pip install --upgrade pdf2docx
    if %errorlevel% neq 0 (
        echo Failed to update PDF2DOCX. Please check the error above.
        
    ) else (
        echo PDF2DOCX has been successfully updated!
        
    )
) else (
    echo pdf2docx is not installed. Skipping update.
    
)
exit /b