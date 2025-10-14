@echo off
REM ==========================================
REM TinyTeX Package Installer
REM Run this to install common LaTeX packages
REM ==========================================

REM Check if tlmgr is available
where tlmgr >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: tlmgr not found. Make sure TinyTeX is installed and in your PATH.
    pause
    exit /b 1
)

echo Installing common LaTeX packages for TinyTeX...
echo.

REM Core packages for tables, color, graphics, and math
tlmgr install multirow
tlmgr install xcolor
tlmgr install graphicx
tlmgr install geometry
tlmgr install array
tlmgr install tabularx
tlmgr install booktabs
tlmgr install amsmath
tlmgr install amssymb

REM Optional useful packages
tlmgr install hyperref
tlmgr install siunitx
tlmgr install mathtools
tlmgr install fancyhdr
tlmgr install pdflscape
tlmgr install lscape

echo.
echo ==========================================
echo All selected packages installed (or already present).
echo ==========================================
pause
