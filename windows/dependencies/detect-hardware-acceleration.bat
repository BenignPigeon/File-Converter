:detect_hardware_acceleration
:: Initialize encoder variables
set "encoder="
set "encoder_name=Software Encoder (libx264)"

:: Query GPU information and set encoder flags
for /f "tokens=*" %%i in ('wmic path win32_VideoController get name /value ^| findstr "Name"') do (

    :: Check for AMD GPU
    echo %%i | findstr /i "AMD Radeon" >nul
    if not errorlevel 1 (
        set "encoder=-c:v h264_amf"
        set "encoder_name=AMD Hardware Encoder"
        exit /b
    )

    :: Check for NVIDIA GPU
    echo %%i | findstr /i "NVIDIA" >nul
    if not errorlevel 1 (
        set "encoder=-c:v h264_nvenc"
        set "encoder_name=NVIDIA Hardware Encoder"
        exit /b
    )

    :: Check for Intel GPU
    echo %%i | findstr /i "Intel" >nul
    if not errorlevel 1 (
        set "encoder=-c:v h264_qsv"
        set "encoder_name=Intel QuickSync"
        exit /b
    )
)

:: If no supported GPU is found, the default values remain
exit /b