:choco_install_check
:: Check if Chocolatey is installed
choco -v >nul 2>nul
if %errorlevel% neq 0 (
    echo Chocolatey is not installed. Installing Chocolatey using winget...
    winget install --id chocolatey.chocolatey -e --source winget --silent
    if %errorlevel% neq 0 (
        echo Failed to install Chocolatey. Please install chocolatey manually.
		pause
		exit /b
    )
    echo Chocolatey installed successfully.
) else (
    echo Chocolatey is already installed.
)

exit /b