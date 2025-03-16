:convert_selection
cls
echo Converting selection e.g. pages (1-3,4,6,8)
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

:: Check file type dynamically
if /i "%ext%" == "pdf" (
	:: Check if dependencies are already marked as installed
	if /i "%has_pdf_to_docx_dependencies%"=="true" (
		call pdf-to-docx-cs.bat :pdf_to_docx
	) else (
		call pdf-to-docx-cs.bat :dependency_check
	)
)
if /i "%ext%" == "pptx" (
echo Converting a selection of a powerpoint file is not yet supported, we will convert it all.
)
if /i "%ext%" == "docx" (
echo Converting a selection of a word file is not yet supported, we will convert it all.
)

cd ..\convert-file
call convert-file.bat :check_file_type_for_conversion
