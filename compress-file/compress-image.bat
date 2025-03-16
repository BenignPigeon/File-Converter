:compress_image

if /i "%has_ffmpeg%" neq "true" (
    echo Checking dependencies...
	cd ..\dependencies\install-check
	call ffmpeg-install-check.bat
	
	cd ..\..\compress-file
	pause
)
cls
echo How much do you want to compress the %ext% by?
echo 1. 10%
echo 2. 25%
echo 3. 50%
echo 4. 75%
echo 5. Back
echo.
set /p format_choice="Enter your choice (1-5): "
if "%format_choice%"=="1" (
    :: Check if output_path is enabled
	if "%output_path_enabled%"=="1" (
		echo Output path enabled.
		for %%F in ("%file_path%") do set "image_path=%output_path%\%%~nF_10percent.%ext%"
	) else (
		echo Using same directory
		for %%F in ("%file_path%") do set "image_path=%%~dpnF_10percent.%ext%"
	)
	echo Converting...
	ffmpeg -i "!file_path!" -vf "scale=iw*0.9:ih*0.9" -q:v 23 "!image_path!" -loglevel error -y >nul 2>&1

	if %errorlevel% neq 0 (
		echo Failed
	) else (
		echo Conversion successful
	)
	echo.
    goto image_compress_success
)
if "%format_choice%"=="2" (
    :: Check if output_path is enabled
	if "%output_path_enabled%"=="1" (
		echo Output path enabled.
		for %%F in ("%file_path%") do set "image_path=%output_path%\%%~nF_25percent.%ext%"
	) else (
		echo Using same directory
		for %%F in ("%file_path%") do set "image_path=%%~dpnF_25percent.%ext%"
	)
	echo Converting...
	ffmpeg -i "!file_path!" -vf "scale=iw*0.75:ih*0.75" -q:v 25 "!image_path!" -loglevel error -y >nul 2>&1

	if %errorlevel% neq 0 (
		echo Failed
	) else (
		echo Conversion successful
	)
	echo.
    goto image_compress_success
)
if "%format_choice%"=="3" (
    :: Check if output_path is enabled
	if "%output_path_enabled%"=="1" (
		echo Output path enabled.
		for %%F in ("%file_path%") do set "image_path=%output_path%\%%~nF_50percent.%ext%"
	) else (
		echo Using same directory
		for %%F in ("%file_path%") do set "image_path=%%~dpnF_50percent.%ext%"
	)
	echo Converting...
	ffmpeg -i "!file_path!" -vf "scale=iw*0.5:ih*0.5" -q:v 28 "!image_path!" -loglevel error -y >nul 2>&1

	if %errorlevel% neq 0 (
		echo Failed
	) else (
		echo Conversion successful
	)
	echo.
    goto image_compress_success
)
if "%format_choice%"=="4" (
    :: Check if output_path is enabled
	if "%output_path_enabled%"=="1" (
		echo Output path enabled.
		for %%F in ("%file_path%") do set "image_path=%output_path%\%%~nF_75percent.%ext%"
	) else (
		echo Using same directory
		for %%F in ("%file_path%") do set "image_path=%%~dpnF_75percent.%ext%"
	)
	echo Converting...
	ffmpeg -i "!file_path!" -vf "scale=iw*0.25:ih*0.25" -q:v 30 "!image_path!" -loglevel error -y >nul 2>&1

	if %errorlevel% neq 0 (
		echo Failed
	) else (
		echo Conversion successful
	)
	echo.
    goto image_compress_success
)
if "%format_choice%"=="5" exit /b

echo invalid choice try again...
timeout /t 2 >nul
goto compress_image

:image_compress_success
set /p "retry=Would you like to compress another image? (Y/N): "
if /i "%retry%"=="Y" call compress-file.bat
if /i "%retry%"=="N" exit /b
echo Invalid choice. Please enter Y or N.
echo.
timeout /t 2 >nul
goto image_compress_success