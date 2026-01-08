# How Face Search Images Are Served to Mobile App

## Storage Structure

1. **Files are stored in**: 
   ```
   web-app/storage/app/public/face_sessions/{session_id}/db/filename.jpg
   ```

2. **Laravel storage link** creates a symlink:
   ```
   public/storage → storage/app/public
   ```

3. **Public URL should be**:
   ```
   http://10.0.2.2:8000/storage/face_sessions/{session_id}/db/filename.jpg
   ```

## Flow

1. **AI Service** searches and returns matches with `identity` path
2. **Laravel Controller** receives `identity` (should be `{session_id}/db/filename.jpg`)
3. **Controller** constructs URL: `{baseUrl}/storage/face_sessions/{identity}`
4. **Mobile App** loads image from that URL

## Current Problem

The URL shown is: `http://10.0.2.2:8000/storage/face_sessions/86982e2e-e4e5-451a-a3f2-451291638d9f.jpg`

This is missing the `{session_id}/db/` part, which means:
- The AI service is returning just the filename, OR
- The path processing is stripping it incorrectly




