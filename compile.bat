@echo off
setlocal enabledelayedexpansion

:zip_prompt
:: Step 1: Prompt the user for zipping the output folder
set /p zipChoice=Do you want to zip the output folder? (Y/N): 
if /i not "!zipChoice!"=="Y" if /i not "!zipChoice!"=="N" (
    echo Invalid input. Please enter Y or N.
    echo.
    goto zip_prompt
)

:: Step 2: Set working directory and load universal parameters
cd dependencies
call universal-parameters.bat
:: You don't need cd.. as that's already in universal parameters.

:: Make sure %programVersion% was set
if not defined programVersion (
    echo Error: programVersion is not defined. Please check universal-parameters.bat
    pause
    exit /b 1
)

:: Define the output folder name on Desktop
set "desktopFolder=%USERPROFILE%\Desktop"
set "outputFolder=%desktopFolder%\File-Converter-v%programVersion%"
set "targetBinSubfolder=%outputFolder%\bin\File-Converter"

:: Step 3: Create the versioned output folder and bin subfolder structure
echo Creating output folder: %outputFolder%
if exist "%outputFolder%" rmdir /s /q "%outputFolder%"
mkdir "%outputFolder%"
mkdir "%targetBinSubfolder%"

:: Step 4: Copy everything except compile.bat and .git to output folder
echo Copying files (excluding compile.bat and .git)...
robocopy "." "%outputFolder%" /E /XD ".git" "File-Converter-*" /XF "compile.bat" /NFL /NDL

:: Step 5: Keep installer.bat in root and move everything else to bin\File-Converter
echo Organizing files - keeping installer.bat in root, moving everything else to bin\File-Converter...
pushd "%outputFolder%"

:: First, move installer.bat to a temporary location if it exists
if exist "installer.bat" (
    move "installer.bat" "installer.bat.temp" >nul
)

:: Move all folders except bin to bin\File-Converter
for /d %%D in (*) do (
    if /i not "%%D"=="bin" if /i not "%%D"=="installer.bat.temp" (
        robocopy "%%D" "bin\File-Converter\%%D" /E /MOVE /NFL /NDL
    )
)

:: Move all files except installer.bat to bin\File-Converter
for %%F in (*) do (
    if /i not "%%~nxF"=="installer.bat.temp" (
        move "%%F" "bin\File-Converter\" >nul
    )
)

:: Move installer.bat back to root if it was saved
if exist "installer.bat.temp" (
    move "installer.bat.temp" "installer.bat" >nul
)

popd

echo.
echo Compilation complete: %outputFolder%
echo.

:: Step 6: Zip the folder if user selected Y (without creating a subfolder inside the zip)
if /i "%zipChoice%"=="Y" (
    echo Zipping the folder...
    
    :: Use PowerShell to zip without the parent folder being included in the zip file, overwrite if exists
    powershell Compress-Archive -Path "%outputFolder%\*" -DestinationPath "%outputFolder%.zip" -Force
    
    echo Zipping complete: %outputFolder%.zip

    :: Delete the unzipped folder after zipping
    echo Deleting the unzipped folder...
    rmdir /s /q "%outputFolder%"
    echo Folder deleted: %outputFolder%
)
