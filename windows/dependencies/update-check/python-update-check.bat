:python_install_check
:: Check if python is installed
python --version >nul 2>nul
if %errorlevel% == 0 (
    echo Python is not installed. Installing Python using winget...
    winget upgrade Python.Python.3 --silent
    if %errorlevel% neq 0 (
        echo Failed to update Python. Please check the error above.
       
    ) else (
        echo Python has been successfully updated!
        
    )
) else (
    echo Python is not installed. Skipping update. 
)
exit /b