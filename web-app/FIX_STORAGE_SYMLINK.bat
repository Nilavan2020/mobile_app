@echo off
echo ========================================
echo Fixing Storage Symlink
echo ========================================
echo.

cd /d "%~dp0"

echo Step 1: Removing old/broken symlink...
if exist "public\storage" (
    rmdir "public\storage" 2>nul
    echo Old symlink removed.
) else (
    echo No existing symlink found.
)

echo.
echo Step 2: Creating new storage symlink...
php artisan storage:link

echo.
echo Step 3: Verifying symlink...
if exist "public\storage" (
    echo ✓ Symlink created successfully!
    echo.
    echo Testing path...
    echo Checking: storage\app\public\face_sessions
    if exist "storage\app\public\face_sessions" (
        echo ✓ face_sessions directory exists
        echo.
        echo Listing files:
        dir /b "storage\app\public\face_sessions" 2>nul || echo No files found
    ) else (
        echo ✗ face_sessions directory not found
        echo.
        echo Creating directory structure...
        mkdir "storage\app\public\face_sessions" 2>nul
        echo ✓ Created directory
    )
) else (
    echo ✗ Symlink creation failed!
    echo.
    echo Trying manual creation...
    mklink /D "public\storage" "storage\app\public"
)

echo.
echo ========================================
echo Done!
echo ========================================
echo.
echo Note: Images are now also accessible via route:
echo http://127.0.0.1:8000/storage/face_sessions/...
echo.
pause




