@echo off
echo ========================================
echo Fixing TensorFlow/DeepFace Error
echo ========================================
echo.
echo Error: TensorFlow 2.20.0 requires tf-keras package
echo Solution: Installing tf-keras...
echo.

cd /d "%~dp0"

REM Check if virtual environment exists
if exist ".venv\Scripts\activate.bat" (
    echo Activating virtual environment...
    call .venv\Scripts\activate.bat
    
    echo.
    echo Installing tf-keras...
    pip install tf-keras
    
    echo.
    echo Verifying DeepFace import...
    python -c "from deepface import DeepFace; print('✓ DeepFace imported successfully!')"
    
    echo.
    echo ========================================
    echo Fix complete!
    echo ========================================
    echo.
    echo Now restart your AI service:
    echo   uvicorn main:app --host 0.0.0.0 --port 8001 --reload
    echo.
) else (
    echo Virtual environment not found!
    echo.
    echo Creating virtual environment first...
    python -m venv .venv
    call .venv\Scripts\activate.bat
    pip install -r requirements.txt
    echo.
    echo Setup complete! Now restart the AI service.
)

pause




