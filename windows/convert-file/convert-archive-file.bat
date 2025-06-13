@echo off
if /i "%has_7zip%" neq "true" (
    echo Checking dependencies...
    cd ..\dependencies\install-check
    call 7zip-install-check.bat
    
    cd ..\..\convert-file
    pause
)

:convert_archive_file
cls
echo What do you want to convert the %ext% to?
echo 1. ZIP file
echo 2. Extract contents to folder
echo 3. Back
echo.

echo file path %file_path%
:: Check if output_path is enabled
if "%output_path_enabled%"=="1" (
    echo Output path enabled.
    for %%F in ("%file_path%") do set "new_folder_path=%output_path%\%%~nF"
) else (
    echo Using same directory.
    for %%F in ("%file_path%") do set "new_folder_path=%%~dpnF"
)

set /p format_choice="Enter your choice (1-3): "
if "%format_choice%"=="1" goto convert_to_zip
if "%format_choice%"=="2" goto extract_files
if "%format_choice%"=="3" exit /b 99

echo Invalid choice, try again...
timeout /t 2 >nul
goto convert_archive_file

:convert_to_zip
cls
echo Converting %file_name% to ZIP...

:: Create a temporary folder for extraction
set "temp_extract_folder=%temp%\%file_name%_extract"
mkdir "%temp_extract_folder%"

:: Extract the TAR contents to the temporary folder
7z x "%file_path%" -o"%temp_extract_folder%" > nul

:: Now create the ZIP file with the extracted contents
7z a "%new_folder_path%.zip" "%temp_extract_folder%\*"

:: Clean up the temporary folder after creating the ZIP
rmdir /s /q "%temp_extract_folder%"

echo Conversion complete: %new_folder_path%.zip
exit /b

:extract_files
cls
echo Extracting %file_name%...

7z x "%file_path%" -o"%new_folder_path%"
echo Extraction complete
echo.
exit /b