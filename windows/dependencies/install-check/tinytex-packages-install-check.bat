@echo off
setlocal enabledelayedexpansion
REM ==========================================
REM TinyTeX Package Installer (Concurrent)
REM Installs all packages simultaneously
REM ==========================================

echo Checking for tlmgr...
where tlmgr >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: tlmgr not found. Make sure TinyTeX is installed and in your PATH.
    pause
    exit /b 1
)
echo SUCCESS: tlmgr found!
echo.

echo Starting CONCURRENT package installation...
echo All 15 packages will install simultaneously.
echo ==========================================
echo.

REM Launch all installations in parallel
start "Installing multirow" /min cmd /c "tlmgr install multirow 2>&1 && echo [SUCCESS] multirow || echo [FAILED] multirow"
echo [1/15] Started: multirow

start "Installing xcolor" /min cmd /c "tlmgr install xcolor 2>&1 && echo [SUCCESS] xcolor || echo [FAILED] xcolor"
echo [2/15] Started: xcolor

start "Installing graphicx" /min cmd /c "tlmgr install graphicx 2>&1 && echo [SUCCESS] graphicx || echo [FAILED] graphicx"
echo [3/15] Started: graphicx

start "Installing geometry" /min cmd /c "tlmgr install geometry 2>&1 && echo [SUCCESS] geometry || echo [FAILED] geometry"
echo [4/15] Started: geometry

start "Installing array" /min cmd /c "tlmgr install array 2>&1 && echo [SUCCESS] array || echo [FAILED] array"
echo [5/15] Started: array

start "Installing tabularx" /min cmd /c "tlmgr install tabularx 2>&1 && echo [SUCCESS] tabularx || echo [FAILED] tabularx"
echo [6/15] Started: tabularx

start "Installing booktabs" /min cmd /c "tlmgr install booktabs 2>&1 && echo [SUCCESS] booktabs || echo [FAILED] booktabs"
echo [7/15] Started: booktabs

start "Installing amsmath" /min cmd /c "tlmgr install amsmath 2>&1 && echo [SUCCESS] amsmath || echo [FAILED] amsmath"
echo [8/15] Started: amsmath

start "Installing amssymb" /min cmd /c "tlmgr install amssymb 2>&1 && echo [SUCCESS] amssymb || echo [FAILED] amssymb"
echo [9/15] Started: amssymb

start "Installing hyperref" /min cmd /c "tlmgr install hyperref 2>&1 && echo [SUCCESS] hyperref || echo [FAILED] hyperref"
echo [10/15] Started: hyperref

start "Installing siunitx" /min cmd /c "tlmgr install siunitx 2>&1 && echo [SUCCESS] siunitx || echo [FAILED] siunitx"
echo [11/15] Started: siunitx

start "Installing mathtools" /min cmd /c "tlmgr install mathtools 2>&1 && echo [SUCCESS] mathtools || echo [FAILED] mathtools"
echo [12/15] Started: mathtools

start "Installing fancyhdr" /min cmd /c "tlmgr install fancyhdr 2>&1 && echo [SUCCESS] fancyhdr || echo [FAILED] fancyhdr"
echo [13/15] Started: fancyhdr

start "Installing pdflscape" /min cmd /c "tlmgr install pdflscape 2>&1 && echo [SUCCESS] pdflscape || echo [FAILED] pdflscape"
echo [14/15] Started: pdflscape

start "Installing lscape" /min cmd /c "tlmgr install lscape 2>&1 && echo [SUCCESS] lscape || echo [FAILED] lscape"
echo [15/15] Started: lscape

echo.
echo ==========================================
echo All 15 installations launched!
echo ==========================================
echo.
echo Check the minimized windows for progress.
echo You can close this window or wait for installations to complete.
echo.
echo TIP: Look in Task Manager for "tlmgr" processes to monitor progress.
echo.
pause