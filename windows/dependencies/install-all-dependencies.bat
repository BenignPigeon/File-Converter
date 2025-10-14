@echo off
setlocal enabledelayedexpansion

:: Go to the folder containing dependency install scripts
cd install-check || (
    echo Folder "install-check" not found!
    exit /b 1
)

:: Get a list of all .bat files
set count=0
for %%f in (*.bat) do (
    set /a count+=1
)

if %count%==0 (
    echo No dependency scripts found in install-check.
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
    echo Running [!index!/%count%]: %%f
    call "%%f"
    if errorlevel 1 (
        echo Error occurred during %%f.
        set success=false
    )
)

:: Report final result
echo.
if !success!==true (
    echo All of the required dependencies are installed.
) else (
    echo Encountered error^(s^) during installation checks.
    echo Try installing again or install the dependencies manually.
)

cd..
pause
exit /b
