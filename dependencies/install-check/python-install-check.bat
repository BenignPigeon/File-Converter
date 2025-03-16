:python_install_check
:: Check if python is installed
python --version >nul 2>nul
if %errorlevel% neq 0 (
    echo Python is not installed. Installing Python using winget...
    winget install --id Python.Python.3 -e --source winget --silent
    if %errorlevel% neq 0 (
        echo Failed to install Python. Please install Python manually and ensure it's in your PATH.
		pause
		exit /b
    )
    echo Python installed successfully.
) else (
    echo Python is already installed.
)

exit /b