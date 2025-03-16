@echo off

:select_conversion_for_video
if /i "%has_ffmpeg%" neq "true" (
    echo Checking dependencies...
	cd ..\dependencies\install-check
	call ffmpeg-install-check.bat
	
	cd ..\..\convert-file
	pause
)

echo What do you want to convert the %ext% to?
echo 1. mp4
echo 2. mp3 (audio)
echo 3. mkv
echo 4. mov
echo 5. webm
echo 6. avi
echo 7. Back
echo.

cd ..\dependencies\
call detect-hardware-acceleration.bat	
cd ..\convert-file

echo Using: %encoder_name%
echo.

@echo off
set "convert_to_extension="

set /p format_choice="Enter your choice (1-7): "

:: Assign extension based on user choice
if "%format_choice%"=="1" set "convert_to_extension=mp4"
if "%format_choice%"=="2" set "convert_to_extension=mp3"
if "%format_choice%"=="3" set "convert_to_extension=mkv"
if "%format_choice%"=="4" set "convert_to_extension=mov"
if "%format_choice%"=="5" set "convert_to_extension=webm" & set "extra_params=-c:v libvpx -c:a libopus -b:a 96k"
if "%format_choice%"=="6" set "convert_to_extension=avi"
if "%format_choice%"=="7" goto menu

:: If invalid choice, retry
if "%convert_to_extension%"=="" (
    echo Invalid choice, try again...
    timeout /t 2 >nul
    goto select_conversion_for_video
)

:: Determine output path
if "%output_path_enabled%"=="1" (
    echo Output path enabled.
    for %%F in ("%file_path%") do set "video_path=%output_path%\%%~nF.%convert_to_extension%"
) else (
    echo Using same directory
    for %%F in ("%file_path%") do set "video_path=%%~dpnF.%convert_to_extension%"
)

:: Perform conversion
echo Converting...
ffmpeg -i "!file_path!" %encoder% %extra_params% "!video_path!"

:: Check if conversion was successful
if %errorlevel% neq 0 (
    echo Failed
) else (
    echo Conversion successful
)
echo.
exit /b

::work on hardware-acceleration for webm too using something other than H.264 (probably VP9 )
:: maybe if "encoder=-c:v h264_amf" set "encoder=-c:v VP9_amf" or something like that