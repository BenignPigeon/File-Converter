@echo off

:convert_excel_file
cls
echo What do you want to convert the %ext% to?
echo 1. pdf
echo 2. Back 
echo.
set /p format_choice="Enter your choice (1-2): "
if "%format_choice%"=="1" goto excel_to_pdf
if "%format_choice%"=="2" exit /b 99

echo invalid choice try again...
timeout /t 2 >nul
goto convert_excel_file


:excel_to_pdf
if "%output_path_enabled%"=="1" (
		echo Output path enabled.
		for %%F in ("%file_path%") do set "document_path=%output_path%\%%~nF.pdf"
	) else (
		echo Using same directory
		for %%F in ("%file_path%") do set "document_path=%%~dpnF.pdf"
	)
	
:: Check if file path is correct
if not exist "%file_path%" (
	echo ERROR: File path does not exist.
	pause
	goto convert_excel_file
)

::conversion command
powershell -Command "$excel = New-Object -ComObject Excel.Application; $excel.Visible = $false; $wb = $excel.Workbooks.Open('!file_path!'); $wb.ExportAsFixedFormat(0, '!document_path!'); $wb.Close($false); $excel.Quit()"


echo Conversion complete.
echo.
exit /b