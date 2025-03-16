@echo off
if not "%~1"=="" goto %~1
echo No valid label passed.
pause
exit /b

:dependency_check
cls

echo Checking dependencies...

cd ..\dependencies\install-check
call python-install-check.bat
call pip-install-check.bat
call pdf-to-docx-install-check

cd ..\..\convert-selection
pause

:: Mark dependencies as installed in the config file

powershell -Command "(Get-Content '%config_file%') | ForEach-Object {if ($_ -match '^has_pdf_to_docx_dependencies=') {'has_pdf_to_docx_dependencies=true'} else {$_}} | Set-Content '%config_file%'"

:: After checking dependencies, return to pdf_to_docx
cls
goto pdf_to_docx

:pdf_to_docx
cls
set /p "pages=Enter page numbers (e.g. 1,2,3 or 1-3): "

:: Parse the pages input into a list that Python can understand
set "pages_list="

:: Loop through each page or range in the input
for %%A in (%pages%) do (
    set "range=%%A"
    
    :: Check if the input contains a range (e.g. 1-2)
    if "!range!" neq "!range:-=!" (
        :: If it's a range, split it into start and end page numbers
        for /f "tokens=1,2 delims=-" %%B in ("!range!") do (
            set /a "start=%%B-1"  :: Subtract 1 for zero-indexed
            set /a "end=%%C-1"    :: Subtract 1 for zero-indexed
            
            :: Add the pages from start to end into the pages_list
            for /l %%D in (!start!,1,!end!) do (
                set "pages_list=!pages_list!%%D,"
            )
        )
    ) else (
        :: If it's a single page number, just add it to the list (adjusted to 0-index)
        set /a "page=%%A-1"  :: Subtract 1 for zero-indexed
        set "pages_list=!pages_list!!page!,"
    )
)

:: Remove trailing comma if present
set "pages_list=!pages_list:~0,-1!"

:: Check if output_path is enabled
if "%output_path_enabled%"=="1" (
    for %%F in ("%file_path%") do set "DOCX_PATH=%output_path%\%%~nF.docx"
) else (
    for %%F in ("%file_path%") do set "DOCX_PATH=%%~dpnF.docx"
)

:: Ensure that the pages_list is passed correctly as a list in Python format
:: Convert the pages_list from comma-separated values into a Python-compatible list
set "python_pages_list=[%pages_list%]"

:: Run Python conversion with pages taken into account
python -c "from pdf2docx import Converter; cv = Converter(r'!file_path!'); cv.convert(r'!DOCX_PATH!', pages=!python_pages_list!); cv.close(); print('Conversion complete! Output:', r'!DOCX_PATH!')"

echo.

goto convert_again

:convert_again
echo Would you like to convert another file?
set /p "retry2=Would you like to try again? (Y/N): "
if /i "%retry2%"=="Y" call convert-selection.bat
if /i "%retry2%"=="N" exit /b
echo Invalid choice. Please enter Y or N.
echo.
timeout /t 2 >nul
goto convert_again