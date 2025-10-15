@echo off
setlocal EnableDelayedExpansion

echo Loading...

:: Check if %APPDATA%\Bat-Files exists, create if it doesn't
if not exist "%APPDATA%\Bat-Files" (
    echo Directory "%APPDATA%\Bat-Files" does not exist. Creating now...
    mkdir "%APPDATA%\Bat-Files"
) 
:: Check if %APPDATA%\Bat-Files\File-Converter exists, create if it doesn't
if not exist "%APPDATA%\Bat-Files\File-Converter" (
    echo Directory "%APPDATA%\Bat-Files\File-Converter" does not exist. Creating now...
    mkdir "%APPDATA%\Bat-Files\File-Converter"
)

cd dependencies
call universal-parameters.bat

:: ============================================================================
:: Define all default configuration settings in one place
:: ============================================================================
set "defaults_count=0"

set /a defaults_count+=1 & set "default[!defaults_count!]=first_execution=true"

set /a defaults_count+=1 & set "default[!defaults_count!]=method=explorer"

set /a defaults_count+=1 & set "default[!defaults_count!]=has_ffmpeg=false"

set /a defaults_count+=1 & set "default[!defaults_count!]=has_7zip=false"

set /a defaults_count+=1 & set "default[!defaults_count!]=has_pandoc=false"

set /a defaults_count+=1 & set "default[!defaults_count!]=has_latex=false"

set /a defaults_count+=1 & set "default[!defaults_count!]=has_tinytex_packages=false"

set /a defaults_count+=1 & set "default[!defaults_count!]=has_pdf_to_docx_dependencies=false"

set /a defaults_count+=1 & set "default[!defaults_count!]=has_pdf_to_png_dependencies=false"

set /a defaults_count+=1 & set "default[!defaults_count!]=has_pdf_ocr_dependencies=false"

set /a defaults_count+=1 & set "default[!defaults_count!]=output_path_enabled=0"

set /a defaults_count+=1 & set "default[!defaults_count!]=output_path=%USERPROFILE%\Desktop"

set /a defaults_count+=1 & set "default[!defaults_count!]=supported_image_formats=arw,bmp,cr2,dds,dns,exr,heic,ico,jfif,jpg,jpeg,nef,png,psd,raf,svg,tif,tiff,tga,webp"

set /a defaults_count+=1 & set "default[!defaults_count!]=supported_audio_formats=aac,aiff,ape,bik,cda,flac,gif,m4a,m4b,mp3,oga,ogg,ogv,opus,wav,wma"

set /a defaults_count+=1 & set "default[!defaults_count!]=supported_video_formats=3gp,3gpp,avi,bik,flv,gif,m4v,mkv,mp4,mpg,mpeg,mov,ogv,rm,ts,vob,webm,wmv"

set /a defaults_count+=1 & set "default[!defaults_count!]=supported_archive_formats=zip,tar,gz,7z,rar"

set /a defaults_count+=1 & set "default[!defaults_count!]=supported_word_formats=docx,odt,doc"

set /a defaults_count+=1 & set "default[!defaults_count!]=supported_powerpoint_formats=pptx,ppt"

set /a defaults_count+=1 & set "default[!defaults_count!]=supported_excel_formats=xlsx,xls"

:: ============================================================================
:: DEBUG: Check config_file variable
:: ============================================================================
if not defined config_file (
    echo ERROR: config_file variable is not defined!
    pause
    exit /b 1
)

:: Check if path contains problematic characters
echo "%config_file%" | find "&" >nul && echo WARNING: Path contains ampersand - may cause issues!
echo "%config_file%" | find "!" >nul && echo WARNING: Path contains exclamation mark - may cause issues!


:: ============================================================================
:: Create config file if it doesn't exist
:: ============================================================================
if not exist "%config_file%" (
    echo Creating new config file: %config_file%
    for /L %%i in (1,1,!defaults_count!) do (
        echo !default[%%i]! >> "%config_file%"
    )
) else (
    setlocal enabledelayedexpansion
    set /a i=1

    :check_defaults_loop
    if !i! leq %defaults_count% (
        :: Safely get the line from the default array
        call set "line=%%default[!i!]%%"

        :: Extract key (everything before '=')
        for /f "tokens=1 delims==" %%a in ("!line!") do (
            set "key=%%a"
            set "key_exists=false"

            :: Check if this key exists in the config file
            for /f "tokens=1 delims==" %%b in ('type "%config_file%"') do (
                if "%%b"=="!key!" set "key_exists=true"
            )

            :: Append the default line if key is missing
            if "!key_exists!"=="false" (
                echo Missing key detected: !key! - adding default value
                echo !line!>>"%config_file%"
            )
        )

        :: Increment counter and loop
        set /a i+=1
        goto check_defaults_loop
    )
    endlocal
)

:: ============================================================================
:: Read all settings from config file into variables
:: ============================================================================
for /f "tokens=1,* delims==" %%a in ('type "%config_file%"') do (
    set "%%a=%%b"
)

:: ============================================================================
:: Trim leading and trailing spaces from all variables (optional)
:: ============================================================================
for /L %%i in (1,1,!defaults_count!) do (
    set "line=!default[%%i]!"
    for /f "tokens=1 delims==" %%a in ("!line!") do (
        set "var_name=%%a"
        call set "var_value=%%!var_name!%%"
        
        :: Trim spaces by reassigning
        for /f "tokens=* delims= " %%b in ("!var_value!") do set "var_value=%%b"
        set "!var_name!=!var_value!"
    )
)

@REM :: ============================================================================
@REM :: Display loaded configuration (optional - remove in production)
@REM :: ============================================================================
@REM echo.
@REM echo Configuration loaded:
@REM echo =====================
@REM for /L %%i in (1,1,!defaults_count!) do (
@REM     set "line=!default[%%i]!"
@REM     for /f "tokens=1 delims==" %%a in ("!line!") do (
@REM         set "var_name=%%a"
@REM         call echo %%a = %%!var_name!%%
@REM     )
@REM )
@REM echo.

::-----------------------------------------------------------------------------------------------------
if "%first_execution%" neq "false" (
	cd dependencies
	call python-add-path.bat
	cd ..
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
