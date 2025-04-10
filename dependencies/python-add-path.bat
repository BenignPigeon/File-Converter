@echo off
echo Adding Python Scripts to User PATH...

powershell -NoProfile -Command ^
"$oldPath = [Environment]::GetEnvironmentVariable('Path', 'User'); ^
$newPath = \"$oldPath;C:\Users\ben\AppData\Roaming\Python\Python312\Scripts\"; ^
[Environment]::SetEnvironmentVariable('Path', $newPath, 'User')"

echo Success!
pause
exit /b
