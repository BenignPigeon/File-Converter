setlocal enabledelayedexpansion
@echo off
if /i "%has_latex%" neq "true" (
    echo Checking dependencies...
    cd ..\dependencies\install-check
    call tinytex-install-check.bat
    call tinytex-packages-install-check.bat
    cd ..\..\convert-file

    :: Check if has_latex is not true and update the line
        for /f "tokens=1,* delims==" %%a in (%config_file%) do (
            if /i "%%a"=="has_latex" (
                set "line=%%a=%%b"
                if /i "%%b" neq "true" (
                    powershell -Command "(Get-Content '%config_file%') | ForEach-Object {if ($_ -match '^has_latex=') {'has_latex=true'} else {$_}} | Set-Content '%config_file%'"
                )
            )
        )
)
if /i "%has_tinytex_packages%" neq "true" (
    echo Checking dependencies...
    cd ..\dependencies\install-check
    call tinytex-packages-install-check.bat
    cd ..\..\convert-file

    :: Check if has_tinytex_packages is not true and update the line
        for /f "tokens=1,* delims==" %%a in (%config_file%) do (
            if /i "%%a"=="has_tinytex_packages" (
                set "line=%%a=%%b"
                if /i "%%b" neq "true" (
                    powershell -Command "(Get-Content '%config_file%') | ForEach-Object {if ($_ -match '^has_tinytex_packages=') {'has_tinytex_packages=true'} else {$_}} | Set-Content '%config_file%'"
                )
            )
        )
)

:convert_md_file
cls
echo What do you want to convert the %ext% to?
echo 1. PDF
echo 2. Back
echo.

set /p format_choice="Enter your choice (1-2): "
if "%format_choice%"=="1" goto convert_to_pdf
if "%format_choice%"=="2" exit /b 99

echo Invalid choice, try again...
timeout /t 2 >nul
goto convert_md_file

:convert_to_pdf
cls
echo Converting %file_name% to PDF...

:: Check if output_path is enabled
    if "%output_path_enabled%"=="1" (
        echo Output path enabled.
        for %%F in ("%file_path%") do set "pdf_path=%output_path%%%~pF"
    ) else (
        echo Using same directory
        for %%F in ("%file_path%") do set "pdf_path=%%~dppF"
    )
    :: remove trailing /
    if "!pdf_path:~-1!"=="\" set "pdf_path=!pdf_path:~0,-1!"

:: Detect TinyTeX bin location (adjust these if needed)
if exist "C:\tools\TinyTeX\bin\windows" (
    set "TINYTEX_BIN=C:\tools\TinyTeX\bin\windows"
) else if exist "C:\ProgramData\chocolatey\lib\tinytex\tools\TinyTeX\bin\windows" (
    set "TINYTEX_BIN=C:\ProgramData\chocolatey\lib\tinytex\tools\TinyTeX\bin\windows"
)

:: Add TinyTeX to PATH for this session
if defined TINYTEX_BIN (
    set "PATH=%TINYTEX_BIN%;%PATH%"
)

:: Run command
latexmk -pdf -interaction=nonstopmode -quiet -outdir="!pdf_path!" "!file_path!" 
:: Clear up other files
latexmk -c -outdir="!pdf_path!" "!file_path!"
echo.
echo.
if %errorlevel% neq 0 (
    echo Conversion failed.
) else (
    echo Conversion successful.
)
echo.

exit /b