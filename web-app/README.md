# Smart Safety Welfare App

A comprehensive safety and welfare management system built with Laravel.

## Features

- User Account Management
- Dashboard for system overview
- Mobile app integration
- Camera Sessions (Face Datasets) + AI face search (DeepFace / Facenet)
- Multi-language support (English, Sinhala, Tamil)

## Requirements

- PHP >= 8.2
- Composer
- MySQL/MariaDB or SQLite
- Node.js and NPM (for asset compilation)

## Installation

1. Clone the repository
2. Copy `.env.example` to `.env`
3. Update database configuration in `.env`
4. Run `composer install`
5. Run `php artisan key:generate`
6. Run `php artisan migrate`
7. Run `npm install && npm run build`

## Configuration

Update the following in `.env`:
- `APP_NAME="Smart Safety Welfare App"`
- `DB_DATABASE=smart_safety_welfare_db`
- Database credentials

### AI service (DeepFace)
This Laravel app proxies face-search requests to the Python service in `ai-app/`.

Add this to `.env`:
- `AI_SERVICE_URL=http://127.0.0.1:8001`

Dataset images are stored on the Laravel **public** disk at:
`storage/app/public/face_sessions/{session_id}/db/*`

Make sure you have the public storage symlink:
`php artisan storage:link`

## License

The Smart Safety Welfare App is open-sourced software.
