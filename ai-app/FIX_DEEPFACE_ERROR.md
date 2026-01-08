# Fix DeepFace TensorFlow Error

## Error
```
Failed to import DeepFace: You have tensorflow 2.20.0 and this requires tf-keras package.
```

## Solution

TensorFlow 2.20.0 requires the `tf-keras` package. Install it:

### Step 1: Activate your virtual environment
```powershell
cd ai-app
.\.venv\Scripts\activate
```

### Step 2: Install tf-keras
```powershell
pip install tf-keras
```

### Step 3: Verify installation
```powershell
python -c "from deepface import DeepFace; print('DeepFace imported successfully!')"
```

### Step 4: Restart the AI service
```powershell
uvicorn main:app --host 0.0.0.0 --port 8001 --reload
```

## Alternative: Update all requirements
```powershell
cd ai-app
.\.venv\Scripts\activate
pip install -r requirements.txt
```

The `requirements.txt` has been updated to include `tf-keras>=2.15.0`.




