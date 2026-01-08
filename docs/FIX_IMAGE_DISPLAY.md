# Fix: Matching Candidate Images Not Showing

## Problem
Mobile app shows "Image not available" for face search results. URL shown: `http://10.0.2.2:8000/storage/face_sessions/filename.jpg` (missing `{session_id}/db/` part).

## How Images Should Flow

### 1. Storage Structure
```
web-app/storage/app/public/face_sessions/{session_id}/db/filename.jpg
```

### 2. Laravel Storage Link
Laravel creates a symlink: `public/storage → storage/app/public`
This makes files accessible at: `http://domain/storage/face_sessions/{session_id}/db/filename.jpg`

### 3. Flow
1. **Admin uploads images** via web dashboard → stored in `storage/app/public/face_sessions/{id}/db/`
2. **AI service** searches these files → returns match with file path
3. **Laravel API** receives path → constructs full URL
4. **Mobile app** receives URL → loads image from that URL

## Fixes Applied

### ✅ AI Service (`ai-app/main.py`)
- Improved path handling to correctly extract relative paths
- Better logging to debug path issues
- Handles both absolute and relative paths from DeepFace

### ✅ Laravel Controller (`web-app/app/Http/Controllers/API/FaceRecognitionController.php`)
- Now handles cases where AI returns just filename
- Uses session_id from request to construct full path if needed
- Generates URLs using request's host (works with Android emulator)

## Steps to Verify Fix

### Step 1: Verify Storage Link Exists
```powershell
cd web-app
php artisan storage:link
```

### Step 2: Check File Structure
Verify files exist:
```
web-app/storage/app/public/face_sessions/1/db/[filename].jpg
```

### Step 3: Test URL Directly
Open in browser (replace session_id and filename):
```
http://10.0.2.2:8000/storage/face_sessions/1/db/[filename].jpg
```
or on your computer:
```
http://127.0.0.1:8000/storage/face_sessions/1/db/[filename].jpg
```

If you see the image, the storage link is working!

### Step 4: Check AI Service Logs
Restart AI service and check logs when searching. You should see:
```
INFO: Identity: [full_path] -> relative: 1/db/filename.jpg
```

### Step 5: Check Laravel Response
Test the API endpoint and check the response:
```json
{
  "success": true,
  "data": {
    "matches": [
      {
        "identity": "1/db/filename.jpg",
        "distance": 0.15,
        "url": "http://10.0.2.2:8000/storage/face_sessions/1/db/filename.jpg"
      }
    ]
  }
}
```

The URL should have the full path: `{session_id}/db/filename.jpg`

## Common Issues

### Issue 1: Storage Link Missing
**Symptom**: 404 error when accessing image URL
**Fix**: Run `php artisan storage:link`

### Issue 2: Files Not in Correct Location
**Symptom**: Files exist but wrong path
**Fix**: Ensure files are in `storage/app/public/face_sessions/{session_id}/db/`

### Issue 3: Network Security (Android)
**Symptom**: Can't load HTTP images
**Fix**: Already fixed in `network_security_config.xml`

### Issue 4: Wrong URL Generation
**Symptom**: URL missing `{session_id}/db/` part
**Fix**: Applied in controller - now uses session_id to construct path

## Testing

After applying fixes:
1. Restart AI service
2. Restart Laravel server  
3. Rebuild mobile app: `flutter clean && flutter run`
4. Try face search again

Images should now display correctly!




