@echo off

:install_all_dependencies
:: Initialize a flag to track success
set success=true

cd install-check

:: Call each installation check and check for errors

call 7zip-install-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during 7Zip installation check.
    set success=false
)

call ffmpeg-install-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during FFmpeg installation check.
    set success=false
)

call python-install-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during Python installation check.
    set success=false
)

call pip-install-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during Pip installation check.
    set success=false
)

call pdf-to-docx-install-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during PDF2DOCX installation check.
    set success=false
)

call image-magick-install-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during ImageMagick installation check.
    set success=false
)

call choco-install-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during Chocolatey installation check.
    set success=false
)

call ghostscript-install-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during Ghostscript installation check.
    set success=false
)

call tesseract-install-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during Tesseract installation check.
    set success=false
)

call ocr-my-pdf-install-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during OCRmyPDF installation check.
    set success=false
)

call pandoc-install-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during Pandoc installation check.
    set success=false
)
call tinytex-packages-install-check.bat
if %errorlevel% neq 0 (
    echo Error occurred during TinyTex packages installation check.
    set success=false
)

@REM call eml-to-pdf-install-check.bat
@REM if %errorlevel% neq 0 (
@REM     echo Error occurred during EML2PDF installation check.
@REM     set success=false
@REM )

:: After all checks, display the success message if no errors occurred
if %success%==true (
    echo.
    echo All of the required dependencies are installed.
) else (
    echo.
	echo Encountered error^(s^) during installation checks.
    echo Try installing again or install the dependencies manually.
)
cd..

pause
exit /b
