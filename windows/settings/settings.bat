@echo off

:settings
:: Assign method to display_method (or show blank if not set)
set "display_method=%method%"
if "%display_method%"=="" set "display_method=blank"

cls
echo Settings
echo ========
echo 1. About Project
echo 2. Report Issue
echo 3. Output Settings
echo 4. Change Folder Selection Method (Current: %display_method%)
echo 5. Update Dependencies
echo 6. Install All Dependencies
echo 7. Update File Converter to Latest Version
echo 8. Config File Settings
echo 9. Back to Main Menu
echo.
set /p settings_choice="Enter your choice (1-9): "
if "%settings_choice%"=="1" (
call about.bat
goto settings
)
if "%settings_choice%"=="2" (
start https://github.com/BenignPigeon/File-Converter/issues
goto settings
)
if "%settings_choice%"=="3" goto output_settings
if "%settings_choice%"=="4" goto selection_method_settings
if "%settings_choice%"=="5" (
cd ..\dependencies
call update-all-dependencies.bat

::after updating
cd ..\settings
goto settings
)
if "%settings_choice%"=="6" (
cd ..\dependencies
call install-all-dependencies.bat

::after installing
cd ..\settings
goto settings
)
if "%settings_choice%"=="7" (
    @echo off
    start cmd /c powershell "irm '%programUpdater%' |iex"
    exit
)
if "%settings_choice%"=="8" goto config_file_settings
if "%settings_choice%"=="9" exit /b

echo Invalid choice, try again.
timeout /t 2 >nul
goto settings

:config_file_settings
cls
echo Config File Settings
echo ==============
echo 1. Open Folder
echo 2. Open File
echo 3. Back to settings
echo.

set /p "config_file_choice=Enter your choice (1-3): "

if "%config_file_choice%"=="1" (
    explorer "%config_file%\.."
    exit /b
)
if "%config_file_choice%"=="2" (
    start "" "%config_file%"
    exit /b
)
if "%config_file_choice%"=="3" exit /b

echo Invalid choice, try again.
timeout /t 2 >nul
goto config_file_settings

:output_settings
cls
echo Output Settings
echo ==============
echo 1. Enable/Disable custom output path
echo 2. Set output path
echo 3. Back to settings
echo.
echo Current Status: 
if "%output_path_enabled%"=="1" (
    echo Custom output path is enabled: %output_path%
) else (
    echo Custom output path is disabled. Default path is the same directory as the pdf file.
)
echo.

:output_settings_loop
set /p "output_choice=Enter your choice (1-3): "

if "%output_choice%"=="1" (
    if "%output_path_enabled%"=="1" (
        set "output_path_enabled=0"
        echo Custom output path disabled. Default path will be used.
        echo.
    ) else (
        if not defined output_path (
            echo Please set an output path first.
            goto output_settings
        )
        set "output_path_enabled=1"
        echo Custom output path enabled: %output_path%
        echo.
    )

    :: Write the updated config back to the file after toggling using PowerShell
    powershell -Command "(Get-Content '%config_file%') | ForEach-Object {if ($_ -match '^output_path_enabled=') {'output_path_enabled=!output_path_enabled!'} else {$_}} | Set-Content '%config_file%'"

    goto output_settings_loop
)

if "%output_choice%"=="2" (
    goto set_output_path
)

if "%output_choice%"=="3" (
    goto settings
)

echo Invalid choice. Please try again.
echo.
goto output_settings_loop

:set_output_path
cls
echo Set Output Path
echo ==============
echo Enter the full path to the output directory
echo Example: C:\Path\To\Output
echo Tip: You can paste the path copied from Windows Explorer
echo Type 'back' to return to settings
echo.
if "%method%"=="explorer" (
    for /f "delims=" %%I in ('powershell -Command "Add-Type -AssemblyName 'System.Windows.Forms'; $folder = New-Object -ComObject Shell.Application; $folder = $folder.BrowseForFolder(0, 'Select Output Folder', 0, 0).Self.Path; $folder"') do set "output_path=%%I"
) else (
    set /p "output_path=Output path: "
)

:: Check if output_path is blank
if "%output_path%"=="" (
    echo Error: No folder selected or blank input.
    goto output_path_blank
)

if /i "%input_path%"=="back" goto output_settings

rem Check if directory exists
if not exist "!output_path!" (
    set "output_path="
    echo "Error: Directory not found: !output_path!."
    goto output_path_does_not_exist
)

:: Save the new output_path to config file using PowerShell
powershell -Command "(Get-Content '%config_file%') | ForEach-Object {if ($_ -match '^output_path=') {'output_path=!output_path!'} else {$_}} | Set-Content '%config_file%'"

echo Output path set successfully to: !output_path!
pause >nul
goto output_settings

echo Press any key to return to settings...
pause >nul
goto output_settings

:output_path_blank
    set /p "retry3=Would you like to try again? (Y/N): "
    if /i "%retry3%"=="Y" goto set_output_path
    if /i "%retry3%"=="N" goto output_settings
    echo Invalid choice. Please enter Y or N.
	echo.
    goto output_path_blank

:output_path_does_not_exist
    set /p "retry4=Would you like to try again? (Y/N): "
    if /i "%retry4%"=="Y" goto set_output_path
    if /i "%retry4%"=="N" goto output_settings
    echo Invalid choice. Please enter Y or N.
	echo.
    goto output_path_does_not_exist

:selection_method_settings
cls
echo Toggle Folder Selection Method (Current: %method%)
echo ================================
echo 1. Explorer Method 
echo 2. CMD Method
echo 3. Back
echo.
goto selection_method

:selection_method
set /p selection_method="Enter your choice (1-3): "
if "%selection_method%"=="1" (
    set "method=explorer"
	echo set method to explorer
	echo.
)
if "%selection_method%"=="2" (
    set "method=cmd"
	echo set method to cmd
	echo.
)
if "%selection_method%"=="3" (
    goto settings
)

:: Update only the "method" line in the config file
powershell -Command "(Get-Content '%config_file%') | ForEach-Object {if ($_ -match '^method=') {'method=%method%'} else {$_}} | Set-Content '%config_file%'"

goto selection_method
