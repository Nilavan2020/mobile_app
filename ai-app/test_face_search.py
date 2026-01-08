"""
Test script to diagnose face search issues
Run this to check if the AI service is configured correctly
"""
import os
import sys
from pathlib import Path

print("=" * 50)
print("AI Service Diagnostic Test")
print("=" * 50)

# Check Python version
print(f"\n1. Python version: {sys.version}")

# Check DeepFace import
print("\n2. Checking DeepFace installation...")
try:
    from deepface import DeepFace
    print("   ✓ DeepFace imported successfully")
    try:
        print(f"   ✓ DeepFace version: {DeepFace.__version__}")
    except:
        pass
except ImportError as e:
    print(f"   ✗ DeepFace import failed: {e}")
    print("   Solution: Run 'pip install -r requirements.txt' in ai-app folder")
    sys.exit(1)

# Check environment variables
print("\n3. Checking environment variables...")
from dotenv import load_dotenv
load_dotenv()

dataset_root = os.getenv("DATASET_ROOT", "").strip()
if not dataset_root:
    # Default path
    dataset_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "web-app", "storage", "app", "public", "face_sessions"))
    print(f"   DATASET_ROOT not set, using default: {dataset_root}")
else:
    print(f"   DATASET_ROOT: {dataset_root}")

dataset_root = os.path.abspath(dataset_root)
print(f"   Absolute path: {dataset_root}")
print(f"   Directory exists: {os.path.isdir(dataset_root)}")

# Check for sessions
print("\n4. Checking face sessions...")
if os.path.isdir(dataset_root):
    sessions = [d for d in os.listdir(dataset_root) 
                if os.path.isdir(os.path.join(dataset_root, d))]
    print(f"   Found {len(sessions)} session(s): {sessions}")
    
    for session_id in sessions[:3]:  # Check first 3 sessions
        session_path = os.path.join(dataset_root, session_id, "db")
        if os.path.isdir(session_path):
            images = [f for f in os.listdir(session_path) 
                     if f.lower().endswith(('.jpg', '.jpeg', '.png'))]
            print(f"   Session '{session_id}': {len(images)} images")
        else:
            print(f"   Session '{session_id}': db folder not found")
else:
    print(f"   ✗ Dataset root directory does not exist!")
    print(f"   Solution: Create the directory or set DATASET_ROOT in .env file")

# Check model
model_name = os.getenv("MODEL_NAME", "Facenet")
print(f"\n5. Model configuration: {model_name}")

print("\n" + "=" * 50)
print("Diagnostic complete!")
print("=" * 50)




