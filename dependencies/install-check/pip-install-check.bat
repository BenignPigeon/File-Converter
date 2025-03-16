:pip_install_check
:: Check if pip is installed
pip --version >nul 2>nul
if %errorlevel% neq 0 (
    echo Pip is not installed. Installing pip...
    python -m ensurepip --upgrade
    if %errorlevel% neq 0 (
        echo Failed to install pip. Please install pip manually.
        pause
        exit /b
    )
    echo Pip installed successfully.
) else (
    echo Pip is already installed.
)

exit /b
	