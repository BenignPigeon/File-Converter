@echo off

:select_conversion_for_audio
if /i "%has_ffmpeg%" neq "true" (
    echo Checking dependencies...
	cd ..\dependencies\install-check
	call ffmpeg-install-check.bat
	
	cd ..\..\convert-file
	pause
)

echo What do you want to convert the %ext% to?
echo 1. mp3
echo 2. mp4 (video) [you will have to select the picture]
echo 3. wav
echo 4. aac
echo 5. flac
echo 6. ogg
echo 7. Back
echo.
set /p format_choice="Enter your choice (1-7): "

:: Set the appropriate file extension and ffmpeg options based on user choice
if "%format_choice%"=="1" set "convert_to_extension=mp3"
if "%format_choice%"=="2" goto audio_to_mp4
if "%format_choice%"=="3" set "convert_to_extension=wav"
if "%format_choice%"=="4" set "convert_to_extension=aac -vf scale=256:256"
if "%format_choice%"=="5" set "convert_to_extension=flac"
if "%format_choice%"=="6" set "convert_to_extension=ogg"
if "%format_choice%"=="7" exit /b 99

:: Validate if the format choice is correct
if not defined convert_to_extension (
    echo Invalid choice, try again...
    timeout /t 2 >nul
    goto select_conversion_for_audio
)

:: Check if output path is enabled
if "%output_path_enabled%"=="1" (
    echo Output path enabled.
    for %%F in ("%file_path%") do set "audio_path=%output_path%\%%~nF.%convert_to_extension%"
) else (
    echo Using same directory
    for %%F in ("%file_path%") do set "audio_path=%%~dpnF.%convert_to_extension%"
)

echo Converting...
:: Run ffmpeg command to convert audio
ffmpeg -i "!file_path!" "!audio_path!"

:: Check if the conversion was successful
if %errorlevel% neq 0 (
    echo Failed
) else (
    echo Conversion successful
)
echo.
exit /b

::------------------------------------------------------------------------------------------------------

:audio_to_mp4
cls
call :detect_hardware_acceleration
cls
echo What image would you like to be the background?
echo 1. Select Image
echo 2. Black Background
echo 3. Other Solid Colour
echo 4. Back

set /p format_choice="Enter your choice (1-3): "

if "%format_choice%"=="1" (
cls
	if "%method%"=="explorer" (
		for /f "delims=" %%a in ('powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog; $FileBrowser.InitialDirectory = [Environment]::GetFolderPath('Desktop'); $FileBrowser.Filter = 'Image Files|*.jpg;*.jpeg;*.png;*.gif;*.bmp;*.tiff;*.ico;*.webp'; if ($FileBrowser.ShowDialog() -eq 'OK') { $FileBrowser.FileName }"') do set "image_file=%%a"
	) else (
		set /p "image_file=Enter the full path of the file or enter back to go back: "
	)
	:: Check if the user pressed Cancel/Entered nothing (image_file is empty)
	if "%image_file%"=="" (
		echo No file selected, returning...
		timeout /t 2 >nul
		goto audio_to_mp4
	)

	:: Remove surrounding quotes if present
	set image_file=%image_file:"=%

	echo.
	echo Selected file: %image_file%

	:: If user enters "back", return to audio_to_mp4
	if /i "%image_file%"=="back" (
		goto audio_to_mp4
	)
		
	if "%output_path_enabled%"=="1" (
        echo Output path enabled.
        for %%F in ("%file_path%") do set "video_path=%output_path%\%%~nF.mp4"
    ) else (
        echo Using same directory
        for %%F in ("%file_path%") do set "video_path=%%~dpnF.mp4"
    )

    echo Converting...

    ffmpeg -loop 1 -i "!image_file!" -i "!file_path!" %encoder% -c:a aac -b:a 192k -shortest "!video_path!"
	
	if %errorlevel% neq 0 (
		echo Failed
	) else (
		echo Conversion successful
	)
	echo.
    exit /b
)
if "%format_choice%"=="2" (
	if "%output_path_enabled%"=="1" (
        echo Output path enabled.
        for %%F in ("%file_path%") do set "video_path=%output_path%\%%~nF.mp4"
    ) else (
        echo Using same directory
        for %%F in ("%file_path%") do set "video_path=%%~dpnF.mp4"
    )

    echo Converting...

    ffmpeg -f lavfi -i color=c=black:s=1920x1080:d=10 -i "!file_path!" %encoder% -c:a aac -b:a 192k -shortest "!video_path!"
	
	if %errorlevel% neq 0 (
		echo Failed
	) else (
		echo Conversion successful
	)
	echo.
    exit /b
)
if "%format_choice%"=="3" (
    cls
    echo What colour would you like to be the background?
    echo 1.  Blue
    echo 2.  Red
    echo 3.  Yellow
    echo 4.  Green
    echo 5.  Black
    echo 6.  White
    echo 7.  Magenta
	echo 8.  Navy
	echo 9.  Gold
	echo 10. Go Back
	
	set "video_colour="
    
    set /p colour_choice="Enter your choice (1-8): "
    
    if "!colour_choice!"=="1" set "video_colour=blue"
    if "!colour_choice!"=="2" set "video_colour=red"
    if "!colour_choice!"=="3" set "video_colour=yellow"
    if "!colour_choice!"=="4" set "video_colour=green"
    if "!colour_choice!"=="5" set "video_colour=black"
    if "!colour_choice!"=="6" set "video_colour=white"
    if "!colour_choice!"=="7" set "video_colour=magenta"
	if "!colour_choice!"=="8" set "video_colour=navy"
	if "!colour_choice!"=="8" set "video_colour=gold"
	if "!colour_choice!"=="10" goto audio_to_mp4

    :: Handle invalid input
    if not defined video_colour (
        echo Invalid choice! Going back...
		timeout /t 2 >nul
		goto audio_to_mp4
        
    )

    if "%output_path_enabled%"=="1" (
        echo Output path enabled.
        for %%F in ("%file_path%") do set "video_path=%output_path%\%%~nF.mp4"
    ) else (
        echo Using same directory
        for %%F in ("%file_path%") do set "video_path=%%~dpnF.mp4"
    )

	echo Selected Colour: !video_colour!
	timeout /t 1 >nul

    echo Converting...
	echo ffmpeg -f lavfi -i color=c=!video_colour!:s=1920x1080:d=10 -i "%file_path%" %encoder% -c:a aac -b:a 192k -shortest "%video_path%"
    ffmpeg -f lavfi -i color=c=!video_colour!:s=1920x1080:d=10 -i "%file_path%" %encoder% -c:a aac -b:a 192k -shortest "%video_path%"

    if %errorlevel% neq 0 (
        echo Failed
    ) else (
        echo Conversion successful
    )
	echo.
    exit /b
)
if "%format_choice%"=="4" goto select_conversion_for_audio

echo invalid choice try again...
timeout /t 2 >nul
goto audio_to_mp4
