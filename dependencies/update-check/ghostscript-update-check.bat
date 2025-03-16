gswin64c.exe -version >nul 2>nul
if %errorlevel% == 0 (
    echo Ghostscript needs to update in a separate window..

    powershell -Command "Start-Process cmd.exe -ArgumentList '/c choco upgrade ghostscript -y' -Verb RunAs"

	if %errorlevel% neq 0 (
        echo Failed to update Ghostscript. Please check the error above.
        pause
    ) else (
        echo Ghostscript has been successfully updated!
		)

) else (
    echo Ghostscript is is not installed. Skipping update.
)
exit /b