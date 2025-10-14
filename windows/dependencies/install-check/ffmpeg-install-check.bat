@echo off
setlocal enabledelayedexpansion

if /i "%has_ffmpeg%" neq "true" (
    ffmpeg -version >nul 2>nul
    if %errorlevel% neq 0 (
        echo FFmpeg is not installed. Installing FFmpeg using winget...
        winget install --id Gyan.FFmpeg -e --source winget --silent
        if %errorlevel% neq 0 (
            echo Failed to install FFmpeg. Please install FFmpeg manually and ensure it's in your PATH.
            pause
			exit /b
        )
    ) else (
		echo FFmpeg is already installed.
	)
	:: Check if has_ffmpeg is not true and update the line
	for /f "tokens=1,* delims==" %%a in (%config_file%) do (
		if /i "%%a"=="has_ffmpeg" (
			set "line=%%a=%%b"
			if /i "%%b" neq "true" (
				powershell -Command "(Get-Content '%config_file%') | ForEach-Object {if ($_ -match '^has_ffmpeg=') {'has_ffmpeg=true'} else {$_}} | Set-Content '%config_file%'"
			)
		)
	)
	exit /b
)
echo FFmpeg is already installed.
exit /b