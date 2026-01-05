Project Walkthrough: Mobile Safety & Disaster Relief App
This project consists of 3 main components:

ML Scripts: Python scripts to define and train models.
Backend API: FastAPi server for heavy lifting (NLP, Disaster Prediction).
Mobile App: React Native (Expo) app for the user interface.
Prerequisites
Python: You need Python installed to run the ML scripts and Backend.
Download from python.org
Important: Check "Add Python to PATH" during installation.
Verify by running python --version in your terminal.
Node.js: Required for the Mobile App.
1. Machine Learning Models
Located in ml_scripts/. To generate the mock TFLite models:

python ml_scripts/safety_classifier.py
python ml_scripts/face_recognition.py
# (This requires tensorflow and other libs installed)
2. Backend API
Located in backend/. This serves the NLP and Disaster Inference. To run:

cd backend
python -m pip install -r requirements.txt
python main.py
Server runs at http://0.0.0.0:8000.

3. Mobile Application
Located in mobile_app/.

Setup
If dependnecies are not installed yet, run:

cd mobile_app
npm install
npm install @react-navigation/native @react-navigation/native-stack react-native-screens react-native-safe-area-context expo-camera expo-av expo-sensors expo-location axios
Running the App
cd mobile_app
npx expo start
NOTE

Windows Users: If you get a "security error" in PowerShell, run this instead: cmd /c "npx expo start"

Press a for Android Emulator.
Scan QR code with Expo Go on your phone.
Usage
Safety: Click "Start Monitoring" to simulate threat detection.
Missing Person: Open Camera to scan (mock match).
Complaint: Type a complaint about water/roads to see categorization.
Disaster: Click "Assess Risk" to see resource predictions.
Notes
TFLite Integration: The app uses mock logic for safety detection in this version. To fully integrate TFLite, use react-native-fast-tflite and load the .tflite models generated in step 1.
Backend Connection: The app assumes the backend is at http://10.0.2.2:8000 (Android Emulator localhost). Change API_URL in 
ComplaintScreen.js
 and 
DisasterScreen.js
 if running on a physical device (use your PC's IP).
