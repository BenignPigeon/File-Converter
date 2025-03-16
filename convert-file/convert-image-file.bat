@echo off

:select_conversion_for_image
if /i "%has_ffmpeg%" neq "true" (
    echo Checking dependencies...
	cd ..\dependencies\install-check
	call ffmpeg-install-check.bat
	
	cd ..\..\convert-file
	pause
)

echo What do you want to convert the %ext% to?
echo 1. png
echo 2. jpg
echo 3. ico
echo 4. webp
echo 5. Back
echo.
set /p format_choice="Enter your choice (1-5): "
if "%format_choice%"=="1" (
    :: Check if output_path is enabled
    if "%output_path_enabled%"=="1" (
        echo Output path enabled.
        for %%F in ("%file_path%") do set "image_path=%output_path%\%%~nF.png"
    ) else (
        echo Using same directory
        for %%F in ("%file_path%") do set "image_path=%%~dpnF.png"
    )

    echo Converting...
    :: Run ffmpeg command to convert image
    ffmpeg -i "!file_path!" "!image_path!" -loglevel error -y >nul 2>&1

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
        for %%F in ("%file_path%") do set "image_path=%output_path%\%%~nF.jpg"
    ) else (
        echo Using same directory
        for %%F in ("%file_path%") do set "image_path=%%~dpnF.jpg"
    )

    echo Converting...
    ffmpeg -i "!file_path!" "!image_path!" -loglevel error -y >nul 2>&1

	if %errorlevel% neq 0 (
		echo Failed
	) else (
		echo Conversion successful
	)
	echo.
    exit /b
)
if "%format_choice%"=="3" (
	if "%output_path_enabled%"=="1" (
        echo Output path enabled.
        for %%F in ("%file_path%") do set "image_path=%output_path%\%%~nF.ico"
    ) else (
        echo Using same directory
        for %%F in ("%file_path%") do set "image_path=%%~dpnF.ico"
    )

    echo Converting...
    ffmpeg -i "!file_path!" -vf "scale=256:256" -y "!image_path!" -loglevel error >nul 2>&1

	if %errorlevel% neq 0 (
		echo Failed
	) else (
		echo Conversion successful
	)
	echo.
    exit /b
)
if "%format_choice%"=="4" (
	if "%output_path_enabled%"=="1" (
        echo Output path enabled.
        for %%F in ("%file_path%") do set "image_path=%output_path%\%%~nF.webp"
    ) else (
        echo Using same directory
        for %%F in ("%file_path%") do set "image_path=%%~dpnF.webp"
    )

    echo Converting...
    ffmpeg -i "!file_path!" "!image_path!" -loglevel error -y >nul 2>&1

	if %errorlevel% neq 0 (
		echo Failed
	) else (
		echo Conversion successful
	)
	echo.
    exit /b
)
if "%format_choice%"=="5" goto menu

echo invalid choice try again...
timeout /t 2 >nul
goto select_conversion_for_image