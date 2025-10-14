@echo off
setlocal enabledelayedexpansion

:updater
cls

:: Go to the folder containing update scripts
cd update-check || (
    echo Folder "update-check" not found!
    exit /b 1
)

:: Count all .bat files
set count=0
for %%f in (*.bat) do (
    set /a count+=1
)

if %count%==0 (
    echo No update scripts found in update-check.
    cd..
    exit /b 1
)

:: Initialize success flag
set success=true
set index=0

:: Loop through all .bat files and execute them
for %%f in (*.bat) do (
    set /a index+=1
    echo.
    echo Running update [!index!/%count%]: %%f
    call "%%f"
    if errorlevel 1 (
        echo Error occurred during %%f.
        set success=false
    )
)

:: Report final result
echo.
if !success!==true (
    echo All of the installed dependencies are updated.
) else (
    echo Encountered error^(s^) during update checks.
    echo Try updating again or update the dependencies manually.
)

echo.
echo.
cd..
echo All installed packages have been updated!
pause
exit /b
