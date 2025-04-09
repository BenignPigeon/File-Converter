@REM This file will be in a parent directory.

@echo off
setlocal enabledelayedexpansion

:: Define paths using environment variables for user-specific directories
set "uninstallPath=%USERPROFILE%\AppData\Local\Bat-Files\File-Converter\uninstall\uninstall.bat"
set "startMenuShortcut=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Bat-Files\File-Converter.lnk"
set "appName=File-Converter"
set "iconPath=%USERPROFILE%\AppData\Local\Bat-Files\File-Converter\icon.ico"

:: Define paths
set "batFilesLocal=%LOCALAPPDATA%\Bat-Files"
set "startMenuPrograms=%APPDATA%\Microsoft\Windows\Start Menu\Programs"
set "batFilesPrograms=%startMenuPrograms%\Bat-Files"
set "desktopFolder=%USERPROFILE%\Desktop"
set "binFolder=%CD%\bin"

:: Ensure Desktop folder exists, or ask user for correct path
if not exist "%desktopFolder%" (
    echo Desktop doesn't exist at "%desktopFolder%"
    set /p desktopFolder=Enter the full path to your Desktop (e.g. C:\Users\YourName\OneDrive\Desktop): 
    if not exist "!desktopFolder!" (
        echo The path "!desktopFolder!" still does not exist. Exiting...
        pause
        exit /b 1
    )
)

:: Ensure Start Menu folder exists, or ask user for correct path
if not exist "%startMenuPrograms%" (
    echo Start Menu folder doesn't exist at "%startMenuPrograms%"
    set /p startMenuPrograms=Enter the full path to your Start Menu Programs folder (e.g. C:\Users\YourName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs): 
    if not exist "!startMenuPrograms!" (
        echo The path "!startMenuPrograms!" still does not exist. Exiting...
        pause
        exit /b 1
    )

:: Create "Bat Files" folder in LOCAL if it doesn't exist
if not exist "%batFilesLocal%" (
    mkdir "%batFilesLocal%"
)

:: Create "Bat Files" folder in PROGRAMS (Start Menu) if it doesn't exist
if not exist "%batFilesPrograms%" (
    mkdir "%batFilesPrograms%"
)

:: Look for subfolders in "bin" folder and process each subfolder
if exist "%binFolder%" (
    echo Searching for folders in "%binFolder%"...
    for /d %%A in ("%binFolder%\*") do (
        if exist "%%A\*" (
            echo Processing folder "%%A"...

            :: Copy subfolder to Bat-Files directory
            echo Copying contents of "%%A" to "%batFilesLocal%\%%~nA"...
            xcopy "%%A\*" "%batFilesLocal%\%%~nA\" /E /H /K /Y
            if errorlevel 1 (
                echo Error occurred during copy operation. Exiting...
                pause
                exit /b
            )

            :: Copy icon.ico if exists
            if exist "%%A\icon.ico" (
                echo Copying icon from "%%A\icon.ico" to "%batFilesLocal%\%%~nA\icon.ico"...
                copy /Y "%%A\icon.ico" "%batFilesLocal%\%%~nA\icon.ico" >nul
                if errorlevel 1 (
                    echo Error occurred during icon copy. Exiting...
                    pause
                    exit /b
                )
            )

            :: Run uninstall\registry.bat if it exists
            set "uninstallSubfolder=%batFilesLocal%\%%~nA\uninstall"
			cd !uninstallSubfolder!
            set "registryFile=!uninstallSubfolder!\registry.bat"

            if exist "!uninstallSubfolder!\" (
                echo Found uninstall folder: "!uninstallSubfolder!"
                if exist "!registryFile!" (
                    echo Running registry script: "!registryFile!"
                    call "registry.bat"
                    if errorlevel 1 (
                        echo Error occurred while running registry.bat. Continuing...
                    )
                ) else (
                    echo registry.bat not found in uninstall folder. Continuing...
                )
            ) else (
                echo No uninstall folder found in %%~nA. Continuing...
            )

            :: Create shortcuts for .bat files (excluding subdirectories)
            for %%F in ("%%A\*.bat") do (
                set "filePath=%batFilesLocal%\%%~nA\%%~nxF"
                set "fileName=%%~nF"
                set "startInPath=%batFilesLocal%\%%~nA"

                :: Start Menu Shortcut
                if exist "%batFilesLocal%\%%~nA\icon.ico" (
                    powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%batFilesPrograms%\!fileName!.lnk'); $s.TargetPath='!filePath!'; $s.IconLocation='%batFilesLocal%\%%~nA\icon.ico'; $s.WorkingDirectory='!startInPath!'; $s.Save()"
                ) else (
                    powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%batFilesPrograms%\!fileName!.lnk'); $s.TargetPath='!filePath!'; $s.WorkingDirectory='!startInPath!'; $s.Save()"
                )

                :: Desktop Shortcut
                if exist "%batFilesLocal%\%%~nA\icon.ico" (
                    powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%desktopFolder%\!fileName!.lnk'); $s.TargetPath='!filePath!'; $s.IconLocation='%batFilesLocal%\%%~nA\icon.ico'; $s.WorkingDirectory='!startInPath!'; $s.Save()"
                ) else (
                    powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%desktopFolder%\!fileName!.lnk'); $s.TargetPath='!filePath!'; $s.WorkingDirectory='!startInPath!'; $s.Save()"
                )
            )
        )
    )
) else (
    echo Bin folder not found. Exiting...
    pause
    exit /b
)
echo.
echo All shortcuts created successfully.
echo.
exit /b
