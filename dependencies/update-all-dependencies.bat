:updater
cls

:: Initialize a flag to track success
set success=true

cd update-check

:: Call each update check and check for errors
call ffmpeg-update-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during FFmpeg update check.
    set success=false
)

call python-update-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during Python update check.
    set success=false
)

call pip-update-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during Pip update check.
    set success=false
)

call pdf-to-docx-update-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during PDF to DOCX update check.
    set success=false
)

call image-magick-update-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during ImageMagick update check.
    set success=false
)

call choco-update-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during Chocolatey update check.
    set success=false
)

call ghostscript-update-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during Ghostscript update check.
    set success=false
)

call tesseract-update-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during Tesseract update check.
    set success=false
)

call ocr-my-pdf-update-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during OCRmyPDF update check.
    set success=false
)

:: After all checks, display the success message if no errors occurred
if %success%==true (
    echo.
    echo All of the installed dependencies are updated.
) else (
    echo.
	echo Encountered error^(s^) during update checks.
    echo Try updating again or update the dependencies manually.
)
echo.
echo.
echo.
echo.
echo.
cd..
echo All installed packages have been updated!
pause 
exit /b