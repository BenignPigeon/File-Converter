:pip_install_check
:: Check if pip is installed
pip --version >nul 2>nul
if %errorlevel% == 0 (
    echo Pip is not installed. Installing pip...
    python -m ensurepip --upgrade
    if %errorlevel% neq 0 (
        echo Failed to update Pip. Please check the error above.
       
    ) else (
        echo Pip has been successfully updated!
        
    )
) else (
    echo Pip is not installed. Skipping update. 
)
exit /b
	