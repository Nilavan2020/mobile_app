@echo off
echo ========================================
echo Fix After Folder Rename
echo ========================================
echo.
echo This script will fix image serving after renaming the project folder.
echo.

cd /d "%~dp0"

echo Step 1: Removing old/broken storage symlink...
if exist "public\storage" (
    rmdir "public\storage" 2>nul
    echo Old symlink removed.
) else (
    echo No existing symlink found.
)

echo.
echo Step 2: Creating new storage symlink pointing to current location...
php artisan storage:link

echo.
echo Step 3: Verifying symlink...
if exist "public\storage" (
    echo ✓ Symlink created successfully!
) else (
    echo ✗ Symlink creation failed!
    echo.
    echo Trying manual creation...
    mklink /D "public\storage" "storage\app\public" 2>nul
)

echo.
echo Step 4: Clearing Laravel cache...
php artisan cache:clear
php artisan config:clear
php artisan view:clear
php artisan route:clear

echo.
echo ========================================
echo Done!
echo ========================================
echo.
echo IMPORTANT: The web dashboard now uses database-backed image serving!
echo - Web dashboard: Uses /api/face/image/{id} (database-backed)
echo - Mobile app: Uses /api/face/image/{id} (database-backed)
echo - Both are now portable and work regardless of folder name!
echo.
echo If images still don't show:
echo 1. Make sure Laravel server is restarted
echo 2. Check that files exist in: storage\app\public\face_sessions
echo 3. Verify database has FaceSessionImage records
echo.
pause


