@echo off
setlocal enabledelayedexpansion

:still_being_implemented
cls
echo EML Conversion is still currently being implemented.
echo Thanks for your patience.
echo.
echo One recommended method of converting an EML file to a PDF is to download Thunderbird mail client.
echo Open the EML with Thunderbird and use the print email to PDF function.
pause
echo.
exit /b

:select_conversion_for_eml
cls
echo What do you want to convert the EML to?
echo 1. PDF 
echo 2. Back
echo.
set /p format_choice="Enter your choice (1-3): "
if "%format_choice%"=="1" goto convert_eml_to_pdf
if "%format_choice%"=="2" exit /b

echo Invalid choice, try again.
timeout /t 2 >nul
goto select_conversion_for_eml

:convert_eml_to_pdf
cls
if /i "%has_eml_to_pdf_dependencies%" neq "true" (
	call :convert_eml_to_pdf_dependency_check
)
cls


:: Check if output_path is enabled
if "%output_path_enabled%"=="1" (
    for %%F in ("%file_path%") do set "DOCX_PATH=%output_path%\%%~nF.pdf"
) else (
    for %%F in ("%file_path%") do set "DOCX_PATH=%%~dpnF.pdf"
)

:: Run Python conversion
python -m subprocess.run(["eml2pdf", "-p", "a4 landscape", "!file_path!", "!OUTPUT_DIR!"])

echo.
echo Would you like to convert another file?
exit /b

:convert_eml_to_pdf_dependency_check
cls
echo Checking dependencies...

cd ..\dependencies\install-check
call python-install-check.bat
call pip-install-check.bat
call eml-to-pdf-install-check.bat
 
cd ..\..\convert-file

:: Mark dependencies as installed in the config file
powershell -Command "(Get-Content '%config_file%') | ForEach-Object {if ($_ -match '^has_eml_to_pdf_dependencies=') {'has_eml_to_pdf_dependencies=true'} else {$_}} | Set-Content '%config_file%'"
exit /b

