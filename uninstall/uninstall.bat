@echo off
setlocal enabledelayedexpansion

:: Detect if running from temp location with 'temp' argument
if "%~1"=="temp" goto proceed_uninstall

:: --- Copy to TEMP and Overwrite ---
set "tempUninstaller=%TEMP%\uninstaller_temp.bat"
copy /Y "%~f0" "%tempUninstaller%" >nul

:: Create VBScript to delete temp batch after delay (overwrite-safe)
set "vbsFile=%TEMP%\del_temp.vbs"
(
    echo WScript.Sleep 1000
    echo Set fso = CreateObject("Scripting.FileSystemObject")
    echo fso.DeleteFile "%tempUninstaller%", True
) > "%vbsFile%"

:: Open the terminal window and run temp batch with 'temp' flag
start "" cmd /C "%tempUninstaller% temp"

:: Run VBScript after batch exits (deletes temp batch file)
start "" cscript //B "%vbsFile%" >nul 2>&1

exit /b

:: --- Uninstaller Starts Here ---
:proceed_uninstall
echo Uninstalling File Converter...

:: Define paths
set "batFilesLocal=%LOCALAPPDATA%\Bat-Files\File-Converter"
set "desktopFolder=%USERPROFILE%\Desktop"
set "startMenuFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Bat-Files"
set "shortcutName=File Converter"
set "uninstallRegistryKey=HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\File-Converter"

:: Step 1: Delete the File-Converter folder
if exist "%batFilesLocal%" (
    echo Deleting "%batFilesLocal%"...
    rmdir /S /Q "%batFilesLocal%"
    echo File-Converter folder deleted.
) else (
    echo File-Converter folder not found.
)

:: Step 2: Delete the File Converter shortcut on the Desktop
if exist "%desktopFolder%\%shortcutName%.lnk" (
    echo Deleting "%desktopFolder%\%shortcutName%.lnk"...
    del "%desktopFolder%\%shortcutName%.lnk"
    echo Shortcut on Desktop deleted.
) else (
    echo Shortcut on Desktop not found.
)

:: Step 3: Delete the File Converter shortcut in the Start Menu
if exist "%startMenuFolder%\%shortcutName%.lnk" (
    echo Deleting "%startMenuFolder%\%shortcutName%.lnk"...
    del "%startMenuFolder%\%shortcutName%.lnk"
    echo Shortcut in Start Menu deleted.
) else (
    echo Shortcut in Start Menu not found.
)

:: Step 4: Remove the uninstall registry key
reg delete "%uninstallRegistryKey%" /f >nul 2>&1
echo Uninstall registry key deleted (if it existed).

echo Uninstallation complete.
exit /b
