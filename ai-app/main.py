import os
import re
import tempfile
import logging
import threading
from typing import Any, Optional, Tuple
from datetime import datetime
from contextlib import asynccontextmanager

from fastapi import FastAPI, File, Form, UploadFile
from fastapi.responses import JSONResponse
from dotenv import load_dotenv
import speech_recognition as sr
import requests

load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# ============================================================================
# Stage 3: Voice-Activated Aggressive Emergency Alert System Configuration
# ============================================================================

# Hardcoded phone numbers for emergency alerts (change these to your numbers)
EMERGENCY_PHONE_NUMBER = "94776716678"  # Format: 94XXXXXXXXX (Sri Lankan number)
POLICE_PHONE_NUMBER = "94776716678"     # Police contact (change as needed)

# Backend API URL (Laravel web app)
WEB_APP_BASE_URL = os.getenv("WEB_APP_BASE_URL", "http://127.0.0.1:8000")
STAGE3_API_ENDPOINT = f"{WEB_APP_BASE_URL}/api/sos/send-stage3-alert"

# Notify.lk SMS Gateway credentials (load from .env or hardcode)
NOTIFY_LK_USER_ID = os.getenv("NOTIFY_LK_USER_ID", "")
NOTIFY_LK_API_KEY = os.getenv("NOTIFY_LK_API_KEY", "")
NOTIFY_LK_SENDER_ID = os.getenv("NOTIFY_LK_SENDER_ID", "NotifyDEMO")
NOTIFY_LK_API_URL = "https://app.notify.lk/api/v1/send"

# Global flag for Stage 3 listening thread
_stage3_thread: Optional[threading.Thread] = None
_stage3_stop_event = threading.Event()

# ============================================================================
# Stage 3 Helper Functions
# ============================================================================

def get_user_location() -> Tuple[str, Optional[float], Optional[float]]:
    """
    Get approximate user location for testing.
    Returns tuple: (location_string, latitude, longitude)
    For production, you would use GPS or geocoding services.
    """
    try:
        # Option 1: Try to get location from geocoding service (requires internet)
        try:
            response = requests.get("http://ip-api.com/json/", timeout=3)
            if response.status_code == 200:
                data = response.json()
                city = data.get("city", "Unknown")
                region = data.get("regionName", "Unknown")
                country = data.get("country", "Unknown")
                lat = data.get("lat", 0)
                lon = data.get("lon", 0)
                location_str = f"{city}, {region}, {country}"
                return (location_str, lat if lat else None, lon if lon else None)
        except Exception as e:
            logger.debug(f"IP geolocation failed: {e}")
        
        # Option 2: Fallback to default location for testing
        return ("Testing Area, Kandy, Sri Lanka", 7.2906, 80.6337)
    except Exception as e:
        logger.warning(f"Could not get location: {e}")
        return ("Unknown Location", None, None)


def format_phone_number(phone: str) -> str:
    """
    Format phone number to Notify.lk format: 9471XXXXXXX
    """
    # Remove all non-digit characters
    phone = re.sub(r'[^0-9]', '', phone)
    
    # Convert to 94XXXXXXXXX format
    if len(phone) == 9:
        # 9 digits: add 94 prefix
        phone = '94' + phone
    elif len(phone) == 10 and phone.startswith('0'):
        # 10 digits starting with 0: replace 0 with 94
        phone = '94' + phone[1:]
    elif len(phone) == 11 and phone.startswith('0'):
        # 11 digits starting with 0: replace 0 with 94
        phone = '94' + phone[1:]
    
    return phone


def send_stage3_alert_to_backend(
    location_details: str,
    latitude: Optional[float] = None,
    longitude: Optional[float] = None,
    sms_message: str = ""
) -> dict:
    """
    Send Stage 3 alert to backend API to save in database
    
    Args:
        location_details: Human-readable location string
        latitude: Latitude coordinate (optional)
        longitude: Longitude coordinate (optional)
        sms_message: Complete SMS message
    
    Returns:
        dict with 'success', 'alert_id', 'sent_count', etc.
    """
    try:
        payload = {
            'user_name': 'Voice Alert User (Stage 3)',
            'user_phone': '',
            'emergency_contact': EMERGENCY_PHONE_NUMBER,
            'police_contact': POLICE_PHONE_NUMBER,
            'location_details': location_details,
            'sms_message': sms_message,
        }
        
        # Add coordinates if available
        if latitude is not None:
            payload['latitude'] = latitude
        if longitude is not None:
            payload['longitude'] = longitude
        
        logger.info(f"Sending Stage 3 alert to backend: {STAGE3_API_ENDPOINT}")
        response = requests.post(
            STAGE3_API_ENDPOINT,
            json=payload,
            headers={'Content-Type': 'application/json'},
            timeout=15
        )
        
        if response.status_code == 200:
            data = response.json()
            if data.get('success'):
                return {
                    'success': True,
                    'alert_id': data.get('data', {}).get('alert_id'),
                    'sent_count': data.get('data', {}).get('sent_count', 0),
                    'message': data.get('message', '')
                }
            else:
                return {
                    'success': False,
                    'message': data.get('message', 'Backend returned failure')
                }
        else:
            error_msg = f"HTTP {response.status_code}"
            try:
                error_data = response.json()
                error_msg = error_data.get('message', error_msg)
            except:
                error_msg = response.text[:200]
            
            return {
                'success': False,
                'message': error_msg
            }
            
    except requests.exceptions.RequestException as e:
        logger.error(f"Failed to connect to backend API: {e}")
        return {
            'success': False,
            'message': f'Connection error: {str(e)}'
        }
    except Exception as e:
        logger.error(f"Error sending to backend: {e}")
        return {
            'success': False,
            'message': str(e)
        }


def send_sms_stage3(phone_number: str, message: str) -> dict:
    """
    Send SMS via Notify.lk API
    
    Args:
        phone_number: Recipient phone number (will be formatted automatically)
        message: SMS message content (max 621 characters)
    
    Returns:
        dict with 'status' and 'message' keys
    """
    if not NOTIFY_LK_USER_ID or not NOTIFY_LK_API_KEY:
        logger.error("Notify.lk credentials not configured. Set NOTIFY_LK_USER_ID and NOTIFY_LK_API_KEY in .env")
        return {
            'status': 'failed',
            'message': 'SMS gateway not configured'
        }
    
    # Format phone number
    formatted_phone = format_phone_number(phone_number)
    
    # Truncate message to 621 characters (Notify.lk limit)
    if len(message) > 621:
        message = message[:618] + "..."
        logger.warning("Message truncated to 621 characters")
    
    try:
        # Send SMS via Notify.lk API
        params = {
            'user_id': NOTIFY_LK_USER_ID,
            'api_key': NOTIFY_LK_API_KEY,
            'sender_id': NOTIFY_LK_SENDER_ID,
            'to': formatted_phone,
            'message': message
        }
        
        logger.info(f"Sending SMS to {formatted_phone}...")
        response = requests.get(NOTIFY_LK_API_URL, params=params, timeout=15, verify=False)
        
        # Handle response
        try:
            response_data = response.json()
        except:
            logger.error(f"Failed to parse response: {response.text}")
            return {
                'status': 'failed',
                'message': f'Invalid response: {response.text[:100]}'
            }
        
        if response.status_code == 200 and response_data.get('status') == 'success':
            logger.info(f"SMS sent successfully! Response: {response_data}")
            return {
                'status': 'success',
                'message': response_data.get('data', 'Sent')
            }
        else:
            error_msg = response_data.get('message') or response_data.get('error', 'Unknown error')
            logger.error(f"SMS sending failed: {error_msg}")
            return {
                'status': 'failed',
                'message': error_msg
            }
            
    except requests.exceptions.RequestException as e:
        logger.error(f"Exception while sending SMS: {e}")
        return {
            'status': 'failed',
            'message': str(e)
        }


def listen_for_help(recognizer: sr.Recognizer, microphone: sr.Microphone) -> bool:
    """
    Listen for audio and check if "help" is detected
    
    Returns:
        True if "help" is detected, False otherwise
    """
    try:
        # Adjust for ambient noise
        logger.info("Adjusting for ambient noise... Please wait.")
        with microphone as source:
            recognizer.adjust_for_ambient_noise(source, duration=1)
        
        logger.info("Listening for 'help'... Speak now!")
        
        # Listen for audio
        with microphone as source:
            audio = recognizer.listen(source, timeout=5, phrase_time_limit=3)
        
        # Recognize speech using Google Speech Recognition
        try:
            text = recognizer.recognize_google(audio).lower()
            logger.info(f"Heard: '{text}'")
            
            # Check if "help" is in the recognized text
            if "help" in text:
                logger.warning("⚠️  'HELP' DETECTED! Triggering emergency alert...")
                return True
            else:
                logger.info("No 'help' detected. Continuing to listen...")
                return False
                
        except sr.UnknownValueError:
            logger.debug("Could not understand audio")
            return False
        except sr.RequestError as e:
            logger.error(f"Error with speech recognition service: {e}")
            return False
            
    except sr.WaitTimeoutError:
        logger.debug("Listening timeout (no speech detected)")
        return False
    except Exception as e:
        logger.error(f"Error listening: {e}")
        return False


def stage3_listening_loop():
    """
    Background thread function: Continuously listen for "help" and send SMS when detected
    Runs in a separate thread so it doesn't block the FastAPI server
    """
    logger.info("=" * 70)
    logger.info("🚨 STAGE 3: Voice-Activated AGGRESSIVE Emergency Alert System 🚨")
    logger.info("=" * 70)
    logger.info("Listening for the word 'HELP'...")
    logger.info(f"Emergency contact: {EMERGENCY_PHONE_NUMBER}")
    logger.info(f"Police contact: {POLICE_PHONE_NUMBER}")
    logger.info(f"Backend API: {STAGE3_API_ENDPOINT}")
    logger.info("=" * 70)
    
    # Initialize speech recognition
    recognizer = sr.Recognizer()
    microphone = sr.Microphone()
    
    # Test microphone
    try:
        with microphone as source:
            logger.info(f"Using microphone: {microphone.list_microphone_names()[0]}")
    except Exception as e:
        logger.error(f"Error accessing microphone: {e}")
        logger.error("Please check your microphone settings and permissions.")
        logger.warning("Stage 3 voice listening will be disabled due to microphone error.")
        return
    
    alert_count = 0
    
    try:
        while not _stage3_stop_event.is_set():
            # Listen for "help"
            if listen_for_help(recognizer, microphone):
                alert_count += 1
                
                # Get user location
                logger.info("Getting user location...")
                location_details, latitude, longitude = get_user_location()
                
                # Create STAGE 3 aggressive alert message with dangerous/aggressive words
                current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                message = (
                    f"🚨 DANGER DANGER DANGER 🚨\n\n"
                    f"⚠️ CRITICAL AGGRESSIVE ALERT ⚠️\n"
                    f"⚠️ VERY DANGEROUS SITUATION ⚠️\n\n"
                    f"🚨 SERIOUS THREAT DETECTED 🚨\n"
                    f"🚨 IMMEDIATE DANGER AHEAD 🚨\n\n"
                    f"⚠️ AGGRESSIVE BEHAVIOR ALERT ⚠️\n"
                    f"⚠️ POTENTIALLY DANGEROUS AREA ⚠️\n\n"
                    f"Emergency triggered by voice-activated Stage 3 system.\n"
                    f"User may be in DANGEROUS and AGGRESSIVE situation.\n\n"
                    f"📍 Location: {location_details}\n"
                )
                
                if latitude and longitude:
                    message += f"📍 Coordinates: {latitude:.6f}, {longitude:.6f}\n"
                    message += f"📍 Map: https://www.google.com/maps?q={latitude},{longitude}\n"
                
                message += (
                    f"\n⏰ Time: {current_time}\n\n"
                    f"🚨 THIS IS A STAGE 3 CRITICAL EMERGENCY 🚨\n"
                    f"🚨 IMMEDIATE RESPONSE REQUIRED 🚨\n"
                    f"🚨 USER NEEDS URGENT ASSISTANCE 🚨\n\n"
                    f"⚠️ POTENTIALLY DANGEROUS SITUATION ⚠️\n"
                    f"⚠️ AGGRESSIVE THREAT IDENTIFIED ⚠️"
                )
                
                logger.info("=" * 70)
                logger.info("🚨 STAGE 3 AGGRESSIVE EMERGENCY ALERT TRIGGERED! 🚨")
                logger.info("=" * 70)
                logger.info(f"Location: {location_details}")
                if latitude and longitude:
                    logger.info(f"Coordinates: {latitude:.6f}, {longitude:.6f}")
                logger.info("=" * 70)
                
                # Send to backend API first (to save in database)
                logger.info("Saving alert to backend database...")
                api_result = send_stage3_alert_to_backend(
                    location_details=location_details,
                    latitude=latitude,
                    longitude=longitude,
                    sms_message=message
                )
                
                if api_result['success']:
                    logger.info(f"✅ Alert saved to database (Alert ID: {api_result.get('alert_id', 'N/A')})")
                    logger.info(f"   SMS sent to {api_result.get('sent_count', 0)} recipient(s)")
                else:
                    logger.warning(f"⚠️ Backend save failed: {api_result.get('message', 'Unknown error')}")
                    # Still try to send SMS directly as fallback
                    logger.info("Attempting direct SMS as fallback...")
                    sms_result = send_sms_stage3(EMERGENCY_PHONE_NUMBER, message)
                    if sms_result['status'] == 'success':
                        logger.info("✅ SMS sent directly (fallback)")
                    else:
                        logger.error(f"❌ Direct SMS also failed: {sms_result['message']}")
                
                logger.info("-" * 70)
                logger.info("Resuming listening...")
                logger.info("-" * 70)
    
    except Exception as e:
        logger.error(f"Unexpected error in Stage 3 listening loop: {e}", exc_info=True)
    finally:
        logger.info("Stage 3 listening thread stopped.")


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    FastAPI lifespan context manager to start/stop background threads
    """
    # Startup: Start Stage 3 listening thread
    global _stage3_thread
    logger.info("Starting Stage 3 voice-activated emergency alert system...")
    _stage3_stop_event.clear()
    _stage3_thread = threading.Thread(target=stage3_listening_loop, daemon=True, name="Stage3VoiceListener")
    _stage3_thread.start()
    logger.info("Stage 3 listening thread started in background.")
    
    yield
    
    # Shutdown: Stop Stage 3 listening thread
    logger.info("Stopping Stage 3 listening thread...")
    _stage3_stop_event.set()
    if _stage3_thread and _stage3_thread.is_alive():
        _stage3_thread.join(timeout=5)
    logger.info("Stage 3 listening thread stopped.")


app = FastAPI(
    title="Smart Safety Welfare - AI Service", 
    version="0.1.0",
    lifespan=lifespan
)

_SESSION_ID_RE = re.compile(r"^[A-Za-z0-9_\-]+$")


def _env_bool(key: str, default: bool) -> bool:
    raw = os.getenv(key)
    if raw is None:
        return default
    return raw.strip().lower() in ("1", "true", "yes", "y", "on")


def _get_dataset_root() -> str:
    root = os.getenv("DATASET_ROOT", "").strip()
    if not root:
        # Default: assume same repo layout, run from ai-app/
        root = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "web-app", "storage", "app", "public", "face_sessions"))
    return os.path.abspath(root)


@app.get("/health")
def health() -> dict[str, Any]:
    return {"ok": True, "service": "ai", "dataset_root": _get_dataset_root()}


@app.post("/face/search")
async def face_search(
    session_id: str = Form(...),
    image: UploadFile = File(...),
) -> JSONResponse:
    """
    Search for a face inside a given session dataset using DeepFace.find (Facenet by default).

    Expected dataset structure:
      DATASET_ROOT/{session_id}/db/*.jpg|png
    """
    logger.info(f"Received face search request: session_id={session_id}, filename={image.filename}")
    
    if not _SESSION_ID_RE.match(session_id):
        return JSONResponse(
            status_code=400,
            content={"success": False, "message": "Invalid session_id. Use only letters, numbers, '-' and '_'."},
        )

    dataset_root = _get_dataset_root()
    session_db_path = os.path.join(dataset_root, session_id, "db")
    session_db_path = os.path.abspath(session_db_path)

    # Prevent path traversal
    if not session_db_path.startswith(dataset_root + os.sep):
        return JSONResponse(status_code=400, content={"success": False, "message": "Invalid session dataset path."})

    if not os.path.isdir(session_db_path):
        return JSONResponse(
            status_code=404,
            content={"success": False, "message": f"Session dataset not found: {session_id}"},
        )

    model_name = os.getenv("MODEL_NAME", "Facenet")
    enforce_detection = _env_bool("ENFORCE_DETECTION", False)

    try:
        from deepface import DeepFace  # type: ignore
        logger.info("DeepFace imported successfully")
    except Exception as e:
        logger.error(f"Failed to import DeepFace: {e}")
        return JSONResponse(
            status_code=500,
            content={
                "success": False,
                "message": "DeepFace is not available. Install dependencies in ai-app/requirements.txt.",
                "error": str(e),
            },
        )

    # Save uploaded file to temp
    suffix = os.path.splitext(image.filename or "")[1] or ".jpg"
    if suffix not in ['.jpg', '.jpeg', '.png']:
        suffix = '.jpg'
    
    try:
        image_data = await image.read()
        if len(image_data) == 0:
            return JSONResponse(
                status_code=400,
                content={"success": False, "message": "Uploaded image is empty"},
            )
        logger.info(f"Image size: {len(image_data)} bytes, suffix: {suffix}")
    except Exception as e:
        logger.error(f"Error reading image data: {e}")
        return JSONResponse(
            status_code=400,
            content={"success": False, "message": f"Error reading image: {str(e)}"},
        )
    
    with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
        tmp_path = tmp.name
        tmp.write(image_data)
        logger.info(f"Saved temporary image to: {tmp_path}")

    try:
        logger.info(f"Starting face search: session_id={session_id}, model={model_name}, enforce_detection={enforce_detection}")
        logger.info(f"Dataset path: {session_db_path}")
        logger.info(f"Temporary image path: {tmp_path}")
        
        # Check if dataset directory has images
        image_files = [f for f in os.listdir(session_db_path) 
                      if f.lower().endswith(('.jpg', '.jpeg', '.png'))]
        logger.info(f"Found {len(image_files)} image files in dataset")
        
        if len(image_files) == 0:
            return JSONResponse(
                status_code=400,
                content={"success": False, "message": "No images found in session dataset"},
            )
        
        result = DeepFace.find(
            img_path=tmp_path,
            db_path=session_db_path,
            model_name=model_name,
            enforce_detection=enforce_detection,
        )

        logger.info(f"DeepFace.find returned: {type(result)}, length: {len(result) if result else 0}")

        # DeepFace.find returns a list of pandas DataFrames (one per detected face)
        matches: list[dict[str, Any]] = []
        if result and len(result) > 0 and result[0] is not None:
            df = result[0]
            logger.info(f"DataFrame info: empty={df.empty if hasattr(df, 'empty') else 'N/A'}, shape={df.shape if hasattr(df, 'shape') else 'N/A'}")
            
            # When no match, DeepFace may return an empty df-like structure
            if hasattr(df, "empty") and not df.empty:
                # columns typically: identity, distance, threshold, etc.
                for idx, row in df.head(5).iterrows():
                    try:
                        identity_path = str(row.get("identity", ""))
                        distance = float(row.get("distance", 0.0))

                        # DeepFace returns absolute path, convert to relative path
                        # identity_path example: C:\...\face_sessions\1\db\filename.jpg
                        # dataset_root example: C:\...\face_sessions
                        # We want: 1/db/filename.jpg
                        
                        abs_identity = os.path.abspath(identity_path)
                        abs_dataset = os.path.abspath(dataset_root)
                        
                        # Check if identity_path is within dataset_root
                        if abs_identity.startswith(abs_dataset):
                            # Get relative path
                            rel_identity = os.path.relpath(abs_identity, abs_dataset).replace("\\", "/")
                        else:
                            # Fallback: try to extract path components
                            logger.warning(f"Identity path {identity_path} not within dataset root {dataset_root}")
                            # Extract just the filename and try to reconstruct
                            filename = os.path.basename(identity_path)
                            # Try to find session_id from the path
                            path_parts = abs_identity.replace("\\", "/").split("/")
                            if "face_sessions" in path_parts:
                                idx = path_parts.index("face_sessions")
                                if idx + 3 < len(path_parts):
                                    # Should be: face_sessions, session_id, db, filename
                                    rel_identity = f"{path_parts[idx+1]}/db/{path_parts[-1]}"
                                else:
                                    rel_identity = filename
                            else:
                                rel_identity = filename
                        
                        logger.info(f"Identity: {identity_path} -> relative: {rel_identity}")
                        matches.append(
                            {
                                "identity": rel_identity,
                                "distance": distance,
                            }
                        )
                    except Exception as e:
                        logger.warning(f"Error processing match row: {e}")
                        continue

        logger.info(f"Returning {len(matches)} matches")
        return JSONResponse(
            status_code=200,
            content={
                "success": True,
                "data": {
                    "session_id": session_id,
                    "model_name": model_name,
                    "matches": matches,
                },
            },
        )
    except Exception as e:
        import traceback
        error_details = traceback.format_exc()
        logger.error(f"Face search failed: {str(e)}")
        logger.error(f"Traceback: {error_details}")
        return JSONResponse(
            status_code=500,
            content={
                "success": False, 
                "message": "Face search failed", 
                "error": str(e),
                "error_type": type(e).__name__,
            },
        )
    finally:
        try:
            os.remove(tmp_path)
        except Exception:
            pass





