## Smart Safety Welfare — AI Service (DeepFace)

This is a small Python API used by the Laravel `web-app` to perform **face search** inside a **camera session dataset**.

### What it does
- The **web app** creates a session (e.g., a temple / public place) and uploads many faces to that session.
- The **mobile app** uploads one face image and selects a session.
- The **Laravel API** forwards the uploaded image to this AI service.
- This service runs `DeepFace.find(..., model_name="Facenet")` over the session dataset and returns top matches.

### Dataset folder structure
The service expects the dataset images here:

`DATASET_ROOT/{session_id}/db/*.(jpg|png)`

For local dev, the recommended root is the Laravel public storage folder:

`../web-app/storage/app/public/face_sessions`

### Environment variables
Copy `ENV_EXAMPLE.txt` into your own env (or set variables in your terminal):
- **DATASET_ROOT**: absolute or relative path to `face_sessions`
- **MODEL_NAME**: default `Facenet`
- **ENFORCE_DETECTION**: `true` or `false` (default false)

### Install & run

```bash
cd ai-app
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8001 --reload
```

### Endpoints
- `GET /health`
- `POST /face/search` (multipart form: `session_id`, `image`)





