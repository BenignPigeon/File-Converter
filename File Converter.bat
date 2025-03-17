@echo off
setlocal EnableDelayedExpansion

cd dependencies
call universal-parameters.bat
cd ..
:: Check if the config file exists, if not, create it with default settings
if not exist "%config_file%" (
	echo first_execution=true >"%config_file%"
    echo method=explorer >> "%config_file%"
	echo has_ffmpeg=false >> "%config_file%"
    echo has_pdf_to_docx_dependencies=false >> "%config_file%"
	echo has_pdf_to_png_dependencies=false >> "%config_file%"
	echo has_pdf_ocr_dependencies=false >> "%config_file%"
	echo output_path_enabled=0 >> "%config_file%"
	echo output_path=%USERPROFILE%\Desktop >> "%config_file%"
	echo supported_image_formats=arw,bmp,cr2,dds,dns,exr,heic,ico,jfif,jpg,jpeg,nef,png,psd,raf,svg,tif,tiff,tga,webp >> "%config_file%"
	echo supported_audio_formats=aac,aiff,ape,bik,cda,flac,gif,m4a,m4b,mp3,oga,ogg,ogv,opus,wav,wma >> "%config_file%"	
	echo supported_video_formats=3gp,3gpp,avi,bik,flv,gif,m4v,mkv,mp4,mpg,mpeg,mov,ogv,rm,ts,vob,webm,wmv >> "%config_file%"
	echo supported_word_formats=docx,odt,doc >> "%config_file%"
	echo supported_powerpoint_formats=pptx,ppt >> "%config_file%"
	echo supported_excel_formats=xlsx,xls >> "%config_file%"
)

:: Read settings from the config file
for /f "tokens=1,* delims==" %%a in (%config_file%) do (
	if "%%a"=="first_execution" set "first_execution=%%b"
    if "%%a"=="method" set "method=%%b"
    if "%%a"=="has_ffmpeg" set "has_ffmpeg=%%b"
	if "%%a"=="has_pdf_to_docx_dependencies" set "has_pdf_to_docx_dependencies=%%b"
	if "%%a"=="has_pdf_to_png_dependencies" set "has_pdf_to_png_dependencies=%%b"
	if "%%a"=="has_pdf_ocr_dependencies" set "has_pdf_ocr_dependencies=%%b"
	if "%%a"=="output_path_enabled" set "output_path_enabled=%%b"
	if "%%a"=="output_path" set "output_path=%%b"
	if "%%a"=="supported_image_formats" set "supported_image_formats=%%b"
	if "%%a"=="supported_audio_formats" set "supported_audio_formats=%%b"
	if "%%a"=="supported_video_formats" set "supported_video_formats=%%b"
	if "%%a"=="supported_word_formats" set "supported_word_formats=%%b"
	if "%%a"=="supported_powerpoint_formats" set "supported_powerpoint_formats=%%b"
	if "%%a"=="supported_excel_formats" set "supported_excel_formats=%%b"
)

:: Trim any leading or trailing spaces from variables
set "first_execution=%first_execution: =%"
set "method=%method: =%"
set "has_ffmpeg=%has_ffmpeg: =%"
set "has_pdf_to_docx_dependencies=%has_pdf_to_docx_dependencies: =%"
set "has_pdf_to_png_dependencies=%has_pdf_to_docx_dependencies: =%"
set "has_pdf_ocr_dependencies=%has_pdf_ocr_dependencies: =%"
set "output_path_enabled=%output_path_enabled: =%"
set "output_path=%output_path: =%"
set "supported_image_formats=%supported_image_formats: =%"
set "supported_audio_formats=%supported_audio_formats: =%"
set "supported_video_formats=%supported_video_formats: =%"
set "supported_word_formats=%supported_word_formats: =%"
set "supported_powerpoint_formats=%supported_powerpoint_formats: =%"
set "supported_excel_formats=%supported_excel_formats: =%"

::-----------------------------------------------------------------------------------------------------

if "%first_execution%" neq "false" (
	set "first_execution=false"
	powershell -Command "(Get-Content '%config_file%') | ForEach-Object {if ($_ -match '^first_execution=') {'first_execution=false'} else {$_}} | Set-Content '%config_file%'"
)

:menu
cls
echo File Converter
echo ====================
echo 1. Convert File
echo 2. Convert Selection (Specific Pages)
echo 3. Compress File
echo 4. Settings
echo 5. Exit
echo.

if "%output_path_enabled%"=="1" (
    echo Current output folder: %output_path%
) else (
    echo Outputting to the same directory as the file
)
echo Current folder selection method: %method%
echo.

set /p choice="Enter your choice (1-5): "
if "%choice%"=="1" (
	cd convert-file
	call convert-file.bat
	
	::after running
	cd ..
	goto menu
)
if "%choice%"=="2" (
	cd convert-selection
	call convert-selection.bat
	
	::after running
	cd ..
	goto menu
)
if "%choice%"=="3" (
	cd compress-file
	call compress-file.bat

	::after running
	cd ..
	goto menu
)
if "%choice%"=="4" (
	cd settings
	call settings.bat

	::after running settings.bat
	cd ..
	goto menu
)
if "%choice%"=="5" (
	endlocal
	exit /b
)
echo Invalid choice, try again.
timeout /t 2 >nul
goto menu
