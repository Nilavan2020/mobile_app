# Smart Safety and Welfare Platform

A comprehensive safety and welfare management system designed to assist in emergency situations, missing person identification, and general welfare management. The platform consists of a mobile application for users, a web dashboard for administrators, and an AI service for face recognition.

## 🏗️ Architecture

The project follows a 3-tier architecture:

1.  **Mobile App (`mobile-app`)**: A Flutter-based mobile application for end-users to report incidents, view safety information, and upload photos for identification.
2.  **Web App (`web-app`)**: A Laravel-based web dashboard for administrators to manage users, complaints, and camera sessions. It provides the API backend for the mobile app.
3.  **AI Service (`ai-app`)**: A Python/FastAPI service that performs face search operations using DeepFace (Facenet). It processes images sent from the Web App.

## ✨ Features

-   **Women's Safety**: dedicated features for emergency assistance.
-   **Missing Person Recognition**: Face search capability to identify missing persons using AI.
-   **Complaint Management**: System for reporting and tracking grievances.
-   **Disaster Relief**: Information and coordination for disaster situations.
-   **Multi-language Support**: English, Sinhala, and Tamil.

## 🛠️ Prerequisites

Ensure you have the following installed on your development machine:

-   **PHP** >= 8.2 & **Composer** (for Web App)
-   **Node.js** & **NPM** (for Web App assets)
-   **Python** >= 3.8 (for AI Service)
-   **Flutter SDK** (for Mobile App)
-   **MySQL** or **MariaDB** database

## 🚀 Installation & Setup

Follow these steps to set up the entire platform locally.

### 1. AI Service Setup (`ai-app`)
This service must be running for face recognition features to work.

```bash
cd ai-app
python -m venv .venv
# Activate virtual environment:
# Windows: .\.venv\Scripts\activate
# Mac/Linux: source .venv/bin/activate

pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8001 --reload
```
*The AI service runs on port 8001.*

### 2. Web App Setup (`web-app`)
The core backend and admin dashboard.

```bash
cd web-app
cp .env.example .env
# Edit .env and configure your DB_DATABASE and DB_PASSWORD
# Ensure AI_SERVICE_URL=http://127.0.0.1:8001 is set in .env

composer install
php artisan key:generate
php artisan migrate
php artisan storage:link
npm install && npm run build
php artisan serve
```
*The Web App runs on port 8000 (default).*

### 3. Mobile App Setup (`mobile-app`)
The user-facing mobile interface.

```bash
cd mobile-app
flutter pub get
# Ensure your emulator or device is connected
flutter run
```

## 🔗 Connection Details

-   **Web App**: Proxies face search requests to the AI Service.
-   **Mobile App**: Connects to the Web App API (Update the base URL in your Flutter config if testing on a real device, as `localhost` won't work; use your machine's IP).

## 📄 License

This project is open-source software.
