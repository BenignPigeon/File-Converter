@echo off
setlocal enabledelayedexpansion

:: Define paths
set "batFilesLocal=%LOCALAPPDATA%\Bat-Files\File-Converter"
set "desktopFolder=%USERPROFILE%\Desktop"
set "startMenuFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Bat-Files"
set "shortcutName=File Converter"
set "uninstallRegistryKey=HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\File Converter"

echo Uninstalling File Converter...

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
if exist "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\File-Converter" (
    echo Deleting uninstall registry key...
    reg delete "%uninstallRegistryKey%" /f /va
    echo Uninstall registry key deleted.
) else (
    echo Uninstall registry key not found.
)

echo Uninstallation complete.

pause
exit /b
