cls

@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: Pandoc + TinyTeX Installation Script with Full LuaTeX Support
:: ============================================================================
:: Installs Pandoc and TinyTeX with complete LuaLaTeX support for PDF generation
:: Lightweight: ~300MB total (vs 7GB for full TeX Live)
:: Installation time: 5-10 minutes
:: ============================================================================

if /i "%has_pandoc%" neq "true" (
    echo Checking dependencies...
    goto install_check
)
else  (
    echo Pandoc is already installed.
    goto end
)

:install_check
echo.
echo ================================================
echo Pandoc + TinyTeX Installer (LuaTeX Optimized)
echo ================================================
echo.

:: ============================================================================
:: Self-Elevate to Administrator if not already running as admin
:: ============================================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Administrator privileges required
    echo [INFO] Requesting elevation...
    echo.
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: Pandoc + TinyTeX Minimal Installer (LuaLaTeX Ready)
:: ============================================================================
:: Lightweight (~300 MB) setup for Markdown → PDF with LuaLaTeX
:: Works without Chocolatey; uses winget + TinyTeX official installer
:: ============================================================================

echo.
echo ===========================================================
echo  Pandoc + TinyTeX Installer (LuaLaTeX Optimised)
echo ===========================================================
echo.

:: ------------------------------------------------------------
:: Step 1: Check / Install Pandoc
:: ------------------------------------------------------------
echo [1/4] Checking Pandoc installation...

where pandoc >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Pandoc not found — installing via winget...
    where winget >nul 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] winget not available. Please install "App Installer" from Microsoft Store.
        pause
        exit /b 1
    )
    call winget install --id JohnMacFarlane.Pandoc --silent --accept-source-agreements --accept-package-agreements
    if %errorlevel% neq 0 (
        echo [ERROR] Pandoc installation failed.
        pause
        exit /b 1
    )
    echo [OK] Pandoc installed successfully.
) else (
    for /f "tokens=*" %%i in ('pandoc --version ^| findstr /r "^pandoc"') do echo [INFO] %%i
)
echo.

:: ------------------------------------------------------------
:: Step 2: Check and Install TinyTeX (Chocolatey Preferred)
:: ------------------------------------------------------------
echo [2/4] Checking TinyTex installation...
echo.

set "TINYTEX_BIN="
set "TINYTEX_FOUND=0"

:: Enable delayed expansion (needed for variables inside loops)
setlocal enabledelayedexpansion

:: Reset
set "TINYTEX_BIN="
set "TINYTEX_FOUND=0"

:: Check if tlmgr exists
where tlmgr >nul 2>&1
if !errorlevel! equ 0 (
    for /f "delims=" %%P in ('where tlmgr') do (
        set "TINYTEX_BIN=%%~dpP"
        set "TINYTEX_FOUND=1"
        goto foundTinyTeX
    )
)

:foundTinyTeX
echo [OK] TinyTeX detected at !TINYTEX_BIN!

echo [INFO] TinyTeX not found — installing lightweight TeX distribution via Chocolatey...
echo.

:: Ensure Chocolatey exists
choco -v
if %errorlevel% neq 0 (
    echo [INFO] Chocolatey not found — installing...
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol=[System.Net.SecurityProtocolType]::Tls12; iex ((New-Object Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    if %errorlevel% neq 0 (
        echo [ERROR] Chocolatey installation failed. Please install manually from https://chocolatey.org/install
        pause
        exit /b 1
    )
)

:: Install TinyTeX via Chocolatey
choco install tinytex -y --no-progress
if %errorlevel% neq 0 (
    echo [ERROR] TinyTeX installation failed via Chocolatey.
    echo [INFO] Try manual installation from: https://yihui.org/tinytex/
    pause
    exit /b 1
)

:: ------------------------------------------------------------
:: Step 3: Install essential LaTeX packages
:: ------------------------------------------------------------
echo [3/4] Installing essential LuaLaTeX / Pandoc packages...

:: Update tlmgr and all packages first
call tlmgr update --self --all >nul 2>&1

:: List of essential packages
set "PACKAGES=luatex luaotfload lualatex-math unicode-math fontspec geometry hyperref xcolor booktabs ltablex"

for %%P in (%PACKAGES%) do (
    :: Check if package is already installed
    call tlmgr info %%P | findstr /C:"installed: Yes" >nul 2>&1
    if %errorlevel% neq 0 (
        echo [INFO] Installing %%P...
        call tlmgr install %%P >nul 2>&1
        if %errorlevel% equ 0 (
            echo [OK] %%P installed
        ) else (
            echo [WARNING] Failed to install %%P
        )
    ) else (
        echo [INFO] %%P already installed, skipping
    )
)

echo [OK] Core packages installed.
echo.


:: ------------------------------------------------------------
:: Step 4: Verify installation
:: ------------------------------------------------------------
echo [4/4] Verifying setup...
where pandoc >nul 2>&1 && echo [OK] Pandoc found. || echo [ERROR] Pandoc missing!
call lualatex --version >nul 2>&1 && echo [OK] LuaLaTeX available. || echo [ERROR] LuaLaTeX missing!

for %%F in (geometry.sty fontspec.sty unicode-math.sty booktabs.sty ltablex.sty) do (
    call kpsewhich %%F >nul 2>&1 && echo [OK] %%F found. || echo [MISSING] %%F
)
echo.

:end

exit /b