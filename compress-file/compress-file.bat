:compress_file

cls
echo Select your file...

:: Use Explorer method if chosen
if "%method%" neq "cmd" (
    for /f "delims=" %%a in ('powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog; $FileBrowser.InitialDirectory = [Environment]::GetFolderPath('Desktop'); $FileBrowser.Filter = 'All Files (*.*)|*.*'; if($FileBrowser.ShowDialog() -eq 'OK') { $FileBrowser.FileName }"') do set "file_path=%%a"
) else (
    set /p "file_path=Enter the full path of the file or enter back to go back: "
)

:: Check if the user pressed Cancel/Entered nothing (file_path is empty)
if "%file_path%"=="" (
    echo No file selected, returning to menu...
    timeout /t 2 >nul
    exit /b
)

:: Remove surrounding quotes if present
set file_path=%file_path:"=%

echo.
echo Selected file: %file_path%

:: If user enters "back", return to menu
if /i "%file_path%"=="back" (
    exit /b
)

:: Extract full file extension (handles multiple dots properly)
for %%F in ("%file_path%") do (
    set "file_name=%%~nxF"
    set "ext=%%~xF"
)

:: Remove the leading dot from the extension
set "ext=%ext:~1%"

:: Convert to lowercase for consistency
for %%A in ("%ext%") do set "ext=%%~A"

:: Debug: Print detected extension
echo Detected file extension: %ext%
goto check_file_type_for_compression

:check_file_type_for_compression

for %%I in (%supported_image_formats%) do (
    if /i "%ext%"=="%%I" (
        call compress-image.bat
		goto compress_file_again
    )
)

for %%I in (%supported_video_formats%) do (
    if /i "%ext%"=="%%I" (
		call compress-video.bat
		goto compress_file_again
    )
)
echo Unsupported file type for compression!

echo.
echo Returning to menu...
pause
goto exit /b

:compress_file_again

REM Check error level returned from subscript
if %errorlevel%==99 (
    exit /b
)

set /p "retry=Would you like to try again? (Y/N): "
if /i "%retry%"=="Y" goto compress_file
if /i "%retry%"=="N" exit /b
echo Invalid choice. Please enter Y or N.
echo.
timeout /t 2 >nul
goto compress_file_again
