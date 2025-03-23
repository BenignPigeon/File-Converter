@echo off
if not "%~1"=="" goto %~1

:convert_file
cls
echo Select your file...

:: Use Explorer method if chosen
if "%method%"=="explorer" (
    for /f "delims=" %%a in ('powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog; $FileBrowser.InitialDirectory = [Environment]::GetFolderPath('Desktop'); $FileBrowser.Filter = 'All Files (*.*)|*.*'; if($FileBrowser.ShowDialog() -eq 'OK') { $FileBrowser.FileName }"') do set "file_path=%%a"
) else (
    set /p "file_path=Enter the full path of the file or enter back to go back: "
)

:: Check if the user pressed Cancel/Entered nothing (file_path is empty)
if "%file_path%"=="" (
    echo No file selected, returning to menu...
    timeout /t 2 >nul
    goto menu
)

:: Remove surrounding quotes if present
set file_path=%file_path:"=%

echo.
echo Selected file: %file_path%

:: If user enters "back", return to menu
if /i "%file_path%"=="back" (
    goto menu
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
goto check_file_type_for_conversion

:check_file_type_for_conversion

:: Check file type dynamically
if /i "%ext%"=="pdf" (
	call convert-pdf-file.bat
	goto :convert_again
)
if /i "%ext%"=="eml" (
	call convert-eml-file.bat
	goto :convert_again
)
for %%I in (%supported_word_formats%) do (
    if /i "%ext%"=="%%I" (
        call convert-word-file.bat
		goto :convert_again
    )
)
for %%I in (%supported_powerpoint_formats%) do (
    if /i "%ext%"=="%%I" (
        call convert-powerpoint-file.bat
		goto :convert_again
    )
)
for %%I in (%supported_excel_formats%) do (
    if /i "%ext%"=="%%I" (
        call convert-excel-file.bat
		goto :convert_again
    )
)
:: Check if the file is an image from the list of supported image formats
for %%I in (%supported_image_formats%) do (
    if /i "%ext%"=="%%I" (
        call convert-image-file.bat
		goto :convert_again
    )
)
for %%I in (%supported_audio_formats%) do (
    if /i "%ext%"=="%%I" (
        call convert-audio-file.bat
		goto :convert_again
    )
)
for %%I in (%supported_video_formats%) do (
    if /i "%ext%"=="%%I" (
		call convert-video-file.bat
		goto :convert_again
    )
)
echo Unsupported file type!
goto convert_file_dialogue_again

:convert_again
set /p "retry=Would you like to convert another document? (Y/N): "
if /i "%retry%"=="Y" call convert-file.bat
if /i "%retry%"=="N" exit /b
echo Invalid choice. Please enter Y or N.
echo.
timeout /t 2 >nul
goto convert_again
