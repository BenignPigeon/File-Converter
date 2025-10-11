setlocal enabledelayedexpansion
@echo off
if /i "%has_pandoc%" neq "true" (
    echo Checking dependencies...
    cd ..\dependencies\install-check
    call pandoc-install-check.bat
    cd ..\..\convert-file

    :: Check if has_pandoc is not true and update the line
        for /f "tokens=1,* delims==" %%a in (%config_file%) do (
            if /i "%%a"=="has_pandoc" (
                set "line=%%a=%%b"
                if /i "%%b" neq "true" (
                    powershell -Command "(Get-Content '%config_file%') | ForEach-Object {if ($_ -match '^has_pandoc=') {'has_pandoc=true'} else {$_}} | Set-Content '%config_file%'"
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
        for %%F in ("%file_path%") do set "pdf_path=%output_path%\%%~nF.pdf"
    ) else (
        echo Using same directory
        for %%F in ("%file_path%") do set "pdf_path=%%~dpnF.pdf"
    )

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

:: Resolve full absolute paths
for %%F in ("!file_path!") do set "abs_input=%%~fF"
for %%F in ("!pdf_path!") do set "abs_output=%%~fF"

:: Check lualatex is available
where lualatex >nul 2>&1
if %errorlevel% neq 0 (
    echo lualatex not found! Check TinyTeX installation and PATH.
    pause
    exit /b 1
)

:: Run Pandoc
pandoc "!abs_input!" -o "!abs_output!" --pdf-engine=lualatex -V mainfont="Cambria Math"
if %errorlevel% neq 0 (
    echo Conversion failed.
) else (
    echo Conversion successful.
)

exit /b