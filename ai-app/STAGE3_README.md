# Stage 3: Voice-Activated Emergency Alert System

## Overview
A Python script that continuously listens for the word "help" and automatically sends an SMS alert with the user's location when detected.

## Features
- ✅ Continuous speech recognition listening for "help"
- ✅ Automatic SMS sending via Notify.lk API
- ✅ Location detection (approximate for testing)
- ✅ Comprehensive logging
- ✅ Error handling

## Setup

### 1. Install Dependencies
```bash
cd ai-app
pip install -r requirements.txt
```

**Note:** On Windows, if `pyaudio` installation fails, you may need to install it separately:
```bash
# Option 1: Use pipwin
pip install pipwin
pipwin install pyaudio

# Option 2: Download wheel from https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyaudio
# Then install: pip install PyAudio-0.2.11-cp312-cp312-win_amd64.whl
```

### 2. Configure Notify.lk Credentials
Create or update `ai-app/.env`:
```env
NOTIFY_LK_USER_ID=your_user_id_here
NOTIFY_LK_API_KEY=your_api_key_here
NOTIFY_LK_SENDER_ID=NotifyDEMO
```

### 3. Set Emergency Phone Number
Edit `src_stage3.py` and change:
```python
EMERGENCY_PHONE_NUMBER = "94771234567"  # Change to your phone number
```

Phone number format:
- Sri Lankan: `94771234567` (94 + 9 digits)
- Or: `0771234567` (will be auto-formatted)

## Usage

### Run the Script
```bash
cd ai-app
python src_stage3.py
```

### How It Works
1. Script starts and adjusts microphone for ambient noise
2. Continuously listens for speech (5 second timeout)
3. When "help" is detected in speech:
   - Gets approximate user location
   - Creates emergency message
   - Sends SMS to configured phone number
4. Logs all activity to console
5. Resumes listening for next "help" command

### Message Format
When "help" is detected, SMS sent contains:
```
⚠️ WARNING WARNING ⚠️

AGGRESSIVE ALERT
SO VERY SERIOUS AGGRESSIVE ALERT

Emergency triggered by voice command.

[Location: City, Region, Country (Approximate coordinates)]

This is an automated emergency alert from Stage 3 system.
```

## Testing

### Test Microphone
```python
# Quick test in Python
import speech_recognition as sr
r = sr.Recognizer()
mic = sr.Microphone()
print(mic.list_microphone_names())  # List available microphones
```

### Test Speech Recognition
Say "help" clearly into your microphone. The script will:
1. Display what it heard: `Heard: 'help me please'`
2. Detect "help" keyword
3. Trigger SMS alert

### Test SMS (Without Voice)
You can test SMS sending directly by modifying the script or creating a test:
```python
from src_stage3 import send_sms, get_user_location

location = get_user_location()
message = f"Test alert from Stage 3\n{location}"
result = send_sms("94771234567", message)
print(result)
```

## Troubleshooting

### Microphone Not Working
- **Windows:** Check microphone permissions in Settings > Privacy > Microphone
- **Linux:** Install ALSA: `sudo apt-get install portaudio19-dev`
- **Mac:** Check System Preferences > Security & Privacy > Microphone

### Speech Recognition Not Working
- Ensure internet connection (uses Google Speech Recognition API)
- Check microphone is properly connected
- Try speaking louder or closer to microphone
- Check if microphone is being used by another application

### SMS Not Sending
- Verify Notify.lk credentials in `.env` file
- Check phone number format (should be 9471XXXXXXX)
- Ensure internet connection
- Check Notify.lk account has credits

### Location Not Accurate
- Location uses IP geolocation (approximate)
- For testing, this is sufficient
- For production, integrate GPS or manual location entry

## Configuration Options

### Change Recognition Language
Edit `src_stage3.py`:
```python
text = recognizer.recognize_google(audio, language="en-US").lower()
# Change to: language="si-LK" for Sinhala, "ta-LK" for Tamil
```

### Adjust Sensitivity
Modify timeout and phrase length:
```python
audio = recognizer.listen(source, timeout=10, phrase_time_limit=5)
# timeout: seconds to wait for speech
# phrase_time_limit: max length of phrase to record
```

### Change Trigger Word
Edit the detection logic:
```python
if "help" in text or "emergency" in text:  # Listen for multiple words
    # Trigger alert
```

## Notes
- This script runs continuously until stopped (Ctrl+C)
- Requires microphone access permissions
- Requires internet connection for:
  - Speech recognition (Google API)
  - SMS sending (Notify.lk API)
  - Location detection (IP geolocation)
- Designed to run on computer (not mobile) to avoid permission issues

