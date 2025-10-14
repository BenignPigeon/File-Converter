@echo off
setlocal enabledelayedexpansion

7z i | find "7-Zip" > nul 2>&1
if %errorlevel% neq 0 (
    echo 7Zip is not installed. Installing 7Zip using winget...
    winget install --id 7zip.7zip -e --source winget --silent
    if %errorlevel% neq 0 (
        echo Failed to install 7Zip. Please install 7Zip manually and ensure it's in your PATH.
        pause
		exit /b
    )
) else (
	echo 7Zip is already installed.
)
:: Check if has_7zip is not true and update the line
for /f "tokens=1,* delims==" %%a in (%config_file%) do (
	if /i "%%a"=="has_7zip" (
		set "line=%%a=%%b"
		if /i "%%b" neq "true" (
			powershell -Command "(Get-Content '%config_file%') | ForEach-Object {if ($_ -match '^has_7zip=') {'has_7zip=true'} else {$_}} | Set-Content '%config_file%'"
		)
	)
)
exit /b