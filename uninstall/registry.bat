@echo off
setlocal enabledelayedexpansion

:: Define paths using environment variables for user-specific directories
set "uninstallPath=%USERPROFILE%\AppData\Local\Bat-Files\File-Converter\uninstall\uninstaller.bat"
set "startMenuShortcut=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Bat-Files\File-Converter.lnk"
set "appName=File-Converter"
set "iconPath=%USERPROFILE%\AppData\Local\Bat-Files\File-Converter\icon.ico"

:: Step 1: Get the file size of the application (in bytes)
for %%F in ("%USERPROFILE%\AppData\Local\Bat-Files\File-Converter") do (
    set /a "fileSize=%%~zF"
)

:: Step 2: Register uninstaller in the registry for "Apps & Features"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%appName%" /v "DisplayName" /t REG_SZ /d "%appName%" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%appName%" /v "UninstallString" /t REG_SZ /d "\"%uninstallPath%\"" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%appName%" /v "DisplayIcon" /t REG_SZ /d "%iconPath%" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%appName%" /v "NoModify" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%appName%" /v "NoRepair" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%appName%" /v "DisplayVersion" /t REG_SZ /d "%programVersion%" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%appName%" /v "DisplaySize" /t REG_SZ /d "%fileSize%" /f

:: Step 3: Add Right-click Uninstall to the context menu for File Converter shortcut
reg add "HKCU\Software\Classes\*\shell\Uninstall %appName%" /v "MUIVerb" /t REG_SZ /d "Uninstall %appName%" /f
reg add "HKCU\Software\Classes\*\shell\Uninstall %appName%\command" /v "" /t REG_SZ /d "\"%uninstallPath%\"" /f

echo Uninstaller registered in the registry and right-click uninstall option added.
pause
exit /b
