@echo off

:convert_powerpoint_file
cls
echo What do you want to convert the %ext% to?
echo 1. pdf
echo 2. png 
echo 3. Back
echo.
set /p format_choice="Enter your choice (1-3): "
if "%format_choice%"=="1" goto powerpoint_to_pdf
if "%format_choice%"=="2" goto powerpoint_to_image
if "%format_choice%"=="3" exit /b

echo invalid choice try again...
timeout /t 2 >nul
goto convert_powerpoint_file


:powerpoint_to_image
echo Starting conversion...

:: Check if file path is correct
if not exist "%file_path%" (
    echo ERROR: File path does not exist.
    pause
    goto convert_powerpoint_file
)


if "%output_path_enabled%"=="1" (
		echo Output path enabled.
		for %%F in ("%file_path%") do set "document_path=%output_path%\%%~nF"
	) else (
		echo Using same directory
		for %%F in ("%file_path%") do set "document_path=%%~dpnF"
	)

echo Saving slides to: %document_path%

:: Confirm folder exists or create it
if not exist "%document_path%" (
    mkdir "%document_path%"
)

:: Run PowerShell script to convert PowerPoint slides to images
powershell -Command "$filePath = '%file_path%'; $documentPath = '%document_path%'; if (!(Test-Path $filePath)) { Write-Host 'File not found'; exit }; if (!(Test-Path $documentPath)) { New-Item -Path $documentPath -ItemType Directory -Force }; $powerpoint = New-Object -ComObject powerpoint.Application; $presentation = $powerpoint.Presentations.Open($filePath); $folder = $documentPath; $slideIndex = 1; foreach ($slide in $presentation.Slides) { $slide.Export([System.IO.Path]::Combine($folder, \"$slideIndex.png\"), 'PNG'); $slideIndex++ }; $presentation.Close(); $powerpoint.Quit()"

echo Conversion complete.
echo.
exit /b

:powerpoint_to_pdf
if "%output_path_enabled%"=="1" (
		echo Output path enabled.
		for %%F in ("%file_path%") do set "document_path=%output_path%\%%~nF.pdf"
	) else (
		echo Using same directory
		for %%F in ("%file_path%") do set "document_path=%%~dpnF.pdf"
	)
	
powershell -Command "$powerpoint = New-Object -ComObject powerpoint.Application; $presentation = $powerpoint.Presentations.Open('!file_path!'); $presentation.SaveAs('!document_path!', 32); $presentation.Close(); $powerpoint.Quit()"

echo Conversion complete.
echo.
exit /b