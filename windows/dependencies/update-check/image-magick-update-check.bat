:: Check if ImageMagick is installed
magick -version >nul 2>nul
if %errorlevel% == 0 (
    echo Updating ImageMagick...
    winget upgrade imagemagick --silent
    if %errorlevel% neq 0 (
        echo Failed to update ImageMagick. Please check the error above.
       
    ) else (
        echo ImageMagick has been successfully updated!
        
    )
) else (
    echo ImageMagick is not installed. Skipping update. 
)
exit /b