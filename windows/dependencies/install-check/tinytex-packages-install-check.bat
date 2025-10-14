@echo off
setlocal
REM ==========================================
REM TinyTeX Package Installer - LaTeX Recommended
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

echo Installing LaTeX recommended package collection...
echo ==========================================
tlmgr install collection-latexrecommended
IF %ERRORLEVEL% EQU 0 (
    echo.
    echo SUCCESS: LaTeX recommended collection installed!
) ELSE (
    echo.
    echo WARNING: Installation may have failed. Check the output above.
)
echo ==========================================
echo.
echo All done. You can now compile your LaTeX documents.
echo.
pause
