:: Check if ffmpeg is installed
ffmpeg -version >nul 2>nul
if %errorlevel% == 0 (
    echo Updating FFmpeg...
    winget upgrade FFmpeg --accept-source-agreements --accept-package-agreements --silent
    if %errorlevel% neq 0 (
        echo Failed to update FFmpeg. Please check the error above.
        
    ) else (
        echo FFmpeg has been successfully updated!
        
    )
) else (
    echo FFmpeg is not installed. Skipping update.
    
)
exit /b