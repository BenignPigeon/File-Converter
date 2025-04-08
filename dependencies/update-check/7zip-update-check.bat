:7zip_install_check
:: Check if 7zip is installed
7zip --version >nul 2>nul
if %errorlevel% == 0 (
    echo Updating 7Zip using winget...
    winget upgrade --id 7zip.7zip --silent
    if %errorlevel% neq 0 (
        echo Failed to update 7Zip. Please check the error above.
       
    ) else (
        echo 7Zip has been successfully updated!
        
    )
) else (
    echo 7Zip is not installed. Skipping update. 
)
exit /b

