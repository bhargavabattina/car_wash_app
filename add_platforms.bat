@echo off
REM Script to add Android, iOS, and Web platform support to your Flutter project
REM Run this in your project root directory (double-click or run in Command Prompt)

echo.
echo ================================
echo   Adding Platform Support
echo   Car Wash App
echo ================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flutter is not installed or not in PATH
    echo Please install Flutter first: https://flutter.dev/docs/get-started/install/windows
    pause
    exit /b 1
)

echo [OK] Flutter found
flutter --version | findstr /C:"Flutter"
echo.

REM Add Android, iOS, and Web platforms
echo [STEP 1] Adding Android, iOS, and Web platforms...
echo.
flutter create --platforms=android,ios,web .

echo.
echo ================================
echo   Platform Setup Complete!
echo ================================
echo.

echo Created folders:
if exist android echo   - android/
if exist ios echo   - ios/
if exist web echo   - web/

echo.
echo Next steps:
echo   1. Open SETUP_GUIDE.md
echo   2. Follow Android configuration (Section 2)
echo   3. Follow iOS configuration (Section 3)
echo   4. Follow Web configuration (Section 4)
echo.

echo Press any key to check Flutter installation...
pause >nul
flutter doctor

echo.
pause
