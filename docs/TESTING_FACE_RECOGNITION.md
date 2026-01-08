# Testing Face Recognition Feature

## Prerequisites

1. **Laravel Web App** is running on `http://127.0.0.1:8000` (or your configured port)
2. **AI Service (Python FastAPI)** is running on `http://127.0.0.1:8001`
3. **Mobile App** is installed and running on device/emulator

## Setup Steps

### 1. Laravel Setup

```bash
cd web-app

# Run migrations
php artisan migrate

# Create storage link (if not already done)
php artisan storage:link

# Set AI service URL in .env
# AI_SERVICE_URL=http://127.0.0.1:8001
```

### 2. AI Service Setup

```bash
cd ai-app

# Create virtual environment
python -m venv .venv

# Activate virtual environment
# Windows:
.\.venv\Scripts\activate
# Linux/Mac:
# source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Set environment variables (create .env from ENV_EXAMPLE.txt)
# DATASET_ROOT=../web-app/storage/app/public/face_sessions

# Run the service
uvicorn main:app --host 0.0.0.0 --port 8001 --reload
```

### 3. Mobile App Setup

```bash
cd mobile-app

# Install dependencies
flutter pub get

# Run on device/emulator
flutter run
```

## Testing Workflow

### Step 1: Create a Camera Session (Web App)

1. Open web app: `http://127.0.0.1:8000`
2. Login as admin
3. Go to **"Camera Sessions"** in the sidebar
4. Click **"Create New Session"**
5. Fill in:
   - **Session Name**: e.g., "Temple Visit"
   - **Place Name**: e.g., "Kandy Temple"
6. Click **"Create Session"**

### Step 2: Upload Dataset Images (Web App)

1. After creating the session, you'll see the session details page
2. Scroll to **"Upload Dataset Images"** section
3. Click **"Choose Files"** and select multiple face images (JPG/PNG)
4. Click **"Upload Images"**
5. Wait for uploads to complete
6. Images will be stored in: `storage/app/public/face_sessions/{session_id}/db/`

### Step 3: Test Face Search (Mobile App)

1. Open the mobile app
2. Navigate to **"Find Person"** tab
3. **Select a Session**: Choose the session you created from the dropdown
4. **Upload Photo**: 
   - Tap the image area
   - Choose "Camera" or "Gallery"
   - Select/take a photo of a person
5. **Search**: Click "Search for Person" button
6. **View Results**: 
   - If matches found, you'll see matching candidates with images
   - Each match shows similarity score
   - If no matches, you'll see "No matches found" message

## Troubleshooting

### Mobile App Can't Connect to API

- **Android Emulator**: Use `http://10.0.2.2:8000/api` (already configured in `config.dart`)
- **Physical Device**: Use your computer's local IP (e.g., `http://192.168.1.100:8000/api`)
  - Update `mobile-app/lib/config.dart` with your IP

### AI Service Not Responding

- Check if AI service is running: `http://127.0.0.1:8001/health`
- Verify `DATASET_ROOT` in AI service `.env` points to Laravel storage
- Check Laravel `.env` has `AI_SERVICE_URL=http://127.0.0.1:8001`

### No Matches Found

- Ensure you uploaded dataset images to the session
- Try with a photo that's similar to one in the dataset
- Check AI service logs for errors
- Verify images are in correct folder: `storage/app/public/face_sessions/{session_id}/db/`

### Images Not Displaying in Results

- Ensure `php artisan storage:link` was run
- Check file permissions on `storage/app/public/face_sessions/`
- Verify image URLs are accessible: `http://127.0.0.1:8000/storage/face_sessions/{session_id}/db/{filename}`

## API Endpoints

### Mobile App API (Laravel)

- **GET** `/api/face/sessions` - List all camera sessions
- **POST** `/api/face/search` - Search for faces
  - Form data:
    - `session_id`: Session ID (required)
    - `image`: Image file (required)

### AI Service API (Python FastAPI)

- **GET** `/health` - Health check
- **POST** `/face/search` - Face recognition search
  - Form data:
    - `session_id`: Session ID (required)
    - `image`: Image file (required)

## Expected Response Format

### List Sessions Response
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Temple Visit",
      "place_name": "Kandy Temple",
      "images_count": 10
    }
  ]
}
```

### Search Response
```json
{
  "success": true,
  "data": {
    "session": {
      "id": 1,
      "name": "Temple Visit",
      "place_name": "Kandy Temple",
      "images_count": 10
    },
    "matches": [
      {
        "identity": "1/db/person1.jpg",
        "distance": 0.25,
        "url": "http://127.0.0.1:8000/storage/face_sessions/1/db/person1.jpg"
      }
    ]
  }
}
```



