@echo off

:convert_word_file
cls
echo What do you want to convert the %ext% to?
echo 1. pdf
echo 2. png
echo 3. Back
echo.
set /p format_choice="Enter your choice (1-3): "
if "%format_choice%"=="1" goto convert_word_to_pdf
if "%format_choice%"=="2" goto convert_word_to_png
if "%format_choice%"=="3" exit /b

echo invalid choice try again...
timeout /t 2 >nul
goto convert_word_file

:convert_word_to_pdf
if "%output_path_enabled%"=="1" (
		echo Output path enabled.
		for %%F in ("%file_path%") do set "document_path=%output_path%\%%~nF.pdf"
	) else (
		echo Using same directory
		for %%F in ("%file_path%") do set "document_path=%%~dpnF.pdf"
	)
	
echo please be patient
echo loading...

powershell -Command "$word = New-Object -ComObject Word.Application; $doc = $word.Documents.Open('!file_path!'); $doc.SaveAs('!document_path!', 17); $doc.Close(); $word.Quit()"

echo completed
exit /b

:convert_word_to_png
:: Convert Word to PDF
echo Converting Word to PDF...

:: Check if output path is enabled
if "%output_path_enabled%"=="1" (
    echo Output path enabled.
    for %%F in ("%file_path%") do set "document_path=%output_path%\%%~nF.pdf"
) else (
    echo Using same directory
    for %%F in ("%file_path%") do set "document_path=%%~dpnF.pdf"
)

echo Please be patient...
echo Loading...

:: PowerShell command to convert Word to PDF
powershell -Command "$word = New-Object -ComObject Word.Application; $doc = $word.Documents.Open('!file_path!'); $doc.SaveAs('!document_path!', 17); $doc.Close(); $word.Quit()"

echo Word document converted to PDF successfully!

:: Now, Convert PDF to PNG using ImageMagick
:: Check if output path is enabled
if "%output_path_enabled%"=="1" (
    for %%F in ("%document_path%") do set "PNG_PATH=%output_path%\%%~nF"
) else (
    for %%F in ("%document_path%") do set "PNG_PATH=%%~dpnF"
)

:: Ensure the output folder exists
if not exist "%PNG_PATH%" (
    mkdir "%PNG_PATH%"
)

:: Run ImageMagick conversion to convert PDF to PNG (pages are named page_1.png, page_2.png, etc.)
echo Converting PDF to PNG...
magick convert -density 300 -background white -alpha remove "%document_path%" "%PNG_PATH%\page_%d.png"

echo Conversion complete. All pages are saved in: %PNG_PATH%

exit /b