:compress_video

if /i "%has_ffmpeg%" neq "true" (
    echo Checking dependencies...
	cd ..\dependencies\install-check
	call ffmpeg-install-check.bat
	
	cd ..\..\compress-file
	pause
)
cls
echo How much do you want to compress the %ext% by? (This will take a while)
echo 1. 10%
echo 2. 25%
echo 3. 50%
echo 4. 75%
echo 5. Back
echo.

cd ..\dependencies\
call detect-hardware-acceleration.bat	
cd ..\compress-file

echo Using: %encoder_name%
echo.

set /p format_choice="Enter your choice (1-5): "

if "%format_choice%"=="1" (
    :: Check if output_path is enabled
    if "%output_path_enabled%"=="1" (
        echo Output path enabled.
        for %%F in ("%file_path%") do set "video_path=%output_path%\%%~nF_10percent.%ext%"
    ) else (
        echo Using same directory
        for %%F in ("%file_path%") do set "video_path=%%~dpnF_10percent.%ext%"
    )
    echo Converting using %encoder_name%...
    ffmpeg -i "!file_path!" -vf "scale=iw*0.9:ih*0.9" %encoder% -crf 23 -preset medium -c:a aac "!video_path!"
    if %errorlevel% neq 0 (
        cls
        echo Conversion failed. Trying with software encoding...
        ffmpeg -i "!file_path!" -vf "scale=iw*0.9:ih*0.9" -c:v libx264 -crf 23 -preset medium -c:a aac "!video_path!"
        if %errorlevel% neq 0 (
            cls
            echo Conversion failed.
        ) else (
            cls
            echo Conversion successful with software encoding.
        )
    ) else (
        cls
        echo Conversion successful with %encoder_name%.
    )
    echo.
    exit /b
)

if "%format_choice%"=="2" (
    :: Check if output_path is enabled
    if "%output_path_enabled%"=="1" (
        echo Output path enabled.
        for %%F in ("%file_path%") do set "video_path=%output_path%\%%~nF_25percent.%ext%"
    ) else (
        echo Using same directory
        for %%F in ("%file_path%") do set "video_path=%%~dpnF_25percent.%ext%"
    )
    echo Converting using %encoder_name%...
    ffmpeg -i "!file_path!" -vf "scale=iw*0.75:ih*0.75" %encoder% -crf 25 -preset medium -c:a aac "!video_path!"
    if %errorlevel% neq 0 (
        cls
        echo Conversion failed. Trying with software encoding...
        ffmpeg -i "!file_path!" -vf "scale=iw*0.75:ih*0.75" -c:v libx264 -crf 25 -preset medium -c:a aac "!video_path!"
        if %errorlevel% neq 0 (
            cls
            echo Conversion failed.
        ) else (
            cls
            echo Conversion successful with software encoding.
        )
    ) else (
        cls
        echo Conversion successful with %encoder_name%.
    )
    echo.
    exit /b
)

if "%format_choice%"=="3" (
    :: Check if output_path is enabled
    if "%output_path_enabled%"=="1" (
        echo Output path enabled.
        for %%F in ("%file_path%") do set "video_path=%output_path%\%%~nF_50percent.%ext%"
    ) else (
        echo Using same directory
        for %%F in ("%file_path%") do set "video_path=%%~dpnF_50percent.%ext%"
    )
    echo Converting using %encoder_name%...
    ffmpeg -i "!file_path!" -vf "scale=iw*0.5:ih*0.5" %encoder% -crf 28 -preset slow -c:a aac "!video_path!"
    if %errorlevel% neq 0 (
        cls
        echo Conversion failed. Trying with software encoding...
        ffmpeg -i "!file_path!" -vf "scale=iw*0.5:ih*0.5" -c:v libx264 -crf 28 -preset slow -c:a aac "!video_path!"
        if %errorlevel% neq 0 (
            cls
            echo Conversion failed.
        ) else (
            cls
            echo Conversion successful with software encoding.
        )
    ) else (
        cls
        echo Conversion successful with %encoder_name%.
    )
    echo.
    exit /b
)

if "%format_choice%"=="4" (
    :: Check if output_path is enabled
    if "%output_path_enabled%"=="1" (
        echo Output path enabled.
        for %%F in ("%file_path%") do set "video_path=%output_path%\%%~nF_75percent.%ext%"
    ) else (
        echo Using same directory
        for %%F in ("%file_path%") do set "video_path=%%~dpnF_75percent.%ext%"
    )
    echo Converting using %encoder_name%...
    ffmpeg -i "!file_path!" -vf "scale=iw*0.25:ih*0.25" %encoder% -crf 30 -preset slow -c:a aac "!video_path!"
    if %errorlevel% neq 0 (
        cls
        echo Conversion failed. Trying with software encoding...
        ffmpeg -i "!file_path!" -vf "scale=iw*0.25:ih*0.25" -c:v libx264 -crf 30 -preset slow -c:a aac "!video_path!"
        if %errorlevel% neq 0 (
            cls
            echo Conversion failed.
        ) else (
            cls
            echo Conversion successful with software encoding.
        )
    ) else (
        cls
        echo Conversion successful with %encoder_name%.
    )
    echo.
    exit /b
)

if "%format_choice%"=="5" exit /b 99

echo invalid choice try again...
timeout /t 2 >nul
goto compress_video