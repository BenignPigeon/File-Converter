:: Check if Chocolatey is installed
echo Checking if Chocolatey is installed...
choco -v >nul 2>nul
if %errorlevel% == 0 (
    echo Ghostscript needs to update in a separate window...
    powershell -Command "Start-Process cmd.exe -ArgumentList '/c choco upgrade chocolatey -y' -Verb RunAs"
	
    if %errorlevel% neq 0 (
        echo Failed to update Chocolatey. Please check the error above.
        pause
    ) else (
        echo Chocolatey has been successfully updated!
        
    )
) else (
    echo Chocolatey is not installed. Skipping update.
    
)
exit /b