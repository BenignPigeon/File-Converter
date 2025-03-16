:image_magick_install_check
:: Check if ImageMagick is installed
magick -version >nul 2>nul
if %errorlevel% neq 0 (
    echo ImageMagick is not installed. Installing ImageMagick using winget...
    winget install --id ImageMagick.ImageMagick -e --source winget --silent
    if %errorlevel% neq 0 (
        echo Failed to install ImageMagick. Please install ImageMagick manually.
		pause
		exit /b
    )
    echo ImageMagick installed successfully.
) else (
    echo ImageMagick is already installed.
)

exit /b