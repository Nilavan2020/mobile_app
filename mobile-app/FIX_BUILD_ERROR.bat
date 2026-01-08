@echo off
echo ========================================
echo Fixing Android Build Error
echo ========================================
echo.
echo This script will:
echo 1. Clean Flutter build cache
echo 2. Clean Gradle cache
echo 3. Delete corrupted transform cache
echo.

pause

echo.
echo Step 1: Cleaning Flutter build...
cd mobile-app
flutter clean
flutter pub get

echo.
echo Step 2: Cleaning Gradle build cache...
cd android
call gradlew.bat clean --no-daemon

echo.
echo Step 3: Deleting corrupted transform cache...
set GRADLE_CACHE=%USERPROFILE%\.gradle\caches\transforms-3
if exist "%GRADLE_CACHE%" (
    echo Deleting: %GRADLE_CACHE%
    rmdir /s /q "%GRADLE_CACHE%"
    echo Transform cache deleted!
) else (
    echo Transform cache folder not found (may have been already deleted).
)

echo.
echo Step 4: Invalidating Gradle caches...
if exist "%USERPROFILE%\.gradle\caches" (
    echo You may need to manually delete: %USERPROFILE%\.gradle\caches\transforms-3
    echo This folder contains corrupted JDK image transforms.
)

echo.
echo ========================================
echo Cleanup Complete!
echo ========================================
echo.
echo Now try building again:
echo   cd mobile-app
echo   flutter run
echo.
echo If the error persists, manually delete:
echo   %USERPROFILE%\.gradle\caches
echo.
pause




