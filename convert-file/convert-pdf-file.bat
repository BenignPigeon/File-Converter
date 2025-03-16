:select_conversion_for_pdf
cls
echo What do you want to convert the PDF to?
echo 1. PDF ^(OCR^)
echo 2. DOCX
echo 3. PNG
echo 4. Back
echo.
set /p format_choice="Enter your choice (1-3): "
if "%format_choice%"=="1" goto convert_pdf_ocr
if "%format_choice%"=="2" goto convert_pdf_to_docx
if "%format_choice%"=="3" goto convert_pdf_to_png
if "%format_choice%"=="4" exit /b

echo Invalid choice, try again.
timeout /t 2 >nul
goto select_conversion_for_pdf

:convert_pdf_ocr
if /i "%has_pdf_ocr_dependencies%" neq "true" (
		call :pdf_ocr_dependency_check
	)
	
:: Check if output_path is enabled
if "%output_path_enabled%"=="1" (
    for %%F in ("%file_path%") do set "DOCX_PATH=%output_path%\%%~nF_ocr.pdf"
) else (
    for %%F in ("%file_path%") do set "DOCX_PATH=%%~dpnF_ocr.pdf"
)

:: Run Python conversion
python -m ocrmypdf -l eng --deskew "!file_path!" "!DOCX_PATH!"
echo Success!
echo.
echo Would you like to convert another file?
exit /b

:pdf_ocr_dependency_check
cls
echo Checking dependencies...

cd ..\dependencies\install-check
call python-install-check.bat
call pip-install-check.bat
call tesseract-install-check.bat
call ocr-my-pdf-install-check.bat
 
cd ..\..\convert-file
pause

:: Mark dependencies as installed in the config file
powershell -Command "(Get-Content '%config_file%') | ForEach-Object {if ($_ -match '^has_pdf_ocr_dependencies=') {'has_pdf_ocr_dependencies=true'} else {$_}} | Set-Content '%config_file%'"
exit /b

:convert_pdf_to_docx

if /i "%has_pdf_to_docx_dependencies%" neq "true" (
		call :pdf_to_docx_dependency_check
	)


:: Check if output_path is enabled
if "%output_path_enabled%"=="1" (
    for %%F in ("%file_path%") do set "DOCX_PATH=%output_path%\%%~nF.docx"
) else (
    for %%F in ("%file_path%") do set "DOCX_PATH=%%~dpnF.docx"
)

:: Run Python conversion
python -c "from pdf2docx import Converter; cv = Converter(r'!file_path!'); cv.convert(r'!DOCX_PATH!'); cv.close(); print('Conversion complete! Output:', r'!DOCX_PATH!')"

echo.
echo Would you like to convert another file?
exit /b

:pdf_to_docx_dependency_check
cls
echo Checking dependencies...

cd ..\dependencies\install-check
call python-install-check.bat
call pip-install-check.bat
call pdf-to-docx-install-check

cd ..\..\convert-selection
pause

:: Mark dependencies as installed in the config file
powershell -Command "(Get-Content '%config_file%') | ForEach-Object {if ($_ -match '^has_pdf_to_docx_dependencies=') {'has_pdf_to_docx_dependencies=true'} else {$_}} | Set-Content '%config_file%'"
exit /b

:convert_pdf_to_png

if /i "%has_pdf_to_png_dependencies%" neq "true" (
		call :pdf_to_png_dependency_check
	)


:: Check if output_path is enabled
if "%output_path_enabled%"=="1" (
    for %%F in ("%file_path%") do set "PNG_PATH=%output_path%\%%~nF"
) else (
    for %%F in ("%file_path%") do set "PNG_PATH=%%~dpnF"
)

:: Ensure the output folder exists
if not exist "%PNG_PATH%" (
    mkdir "%PNG_PATH%"
)

:: Run ImageMagick conversion to convert PDF to PNG (pages are named page_1.png, page_2.png, etc.)
magick convert -density 300 -background white -alpha remove "%file_path%" "%PNG_PATH%\page_%d.png"

echo Conversion complete. All pages are saved in: %PNG_PATH%

echo.
echo Would you like to convert another file?
exit /b

:pdf_to_png_dependency_check
cls
echo Checking dependencies...

cd ..\dependencies\install-check
call image-magick-install-check.bat
call choco-install-check.bat
call ghostscript-install-check

cd ..\..\convert-selection
pause

:: Mark dependencies as installed in the config file
powershell -Command "(Get-Content '%config_file%') | ForEach-Object {if ($_ -match '^has_pdf_to_png_dependencies=') {'has_pdf_to_png_dependencies=true'} else {$_}} | Set-Content '%config_file%'"

cls
exit /b