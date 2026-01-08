<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\FaceSession;
use App\Models\FaceSessionImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class FaceRecognitionController extends Controller
{
    public function listSessions()
    {
        $sessions = FaceSession::withCount('images')
            ->orderByDesc('id')
            ->get(['id', 'name', 'place_name']);

        return response()->json([
            'success' => true,
            'data' => $sessions,
        ]);
    }

    /**
     * Serve face session image by database ID
     * This is more reliable than file paths and doesn't require exact folder structure
     */
    public function serveImage($id)
    {
        $image = FaceSessionImage::findOrFail($id);
        
        // Get file from storage using the file_path stored in database
        $filePath = $image->file_path;
        
        if (!Storage::disk('public')->exists($filePath)) {
            abort(404, 'Image file not found');
        }
        
        $file = Storage::disk('public')->get($filePath);
        $mimeType = Storage::disk('public')->mimeType($filePath) ?: 'image/jpeg';
        
        // Set cache headers for better performance
        return response($file, 200)
            ->header('Content-Type', $mimeType)
            ->header('Content-Disposition', 'inline; filename="' . basename($filePath) . '"')
            ->header('Cache-Control', 'public, max-age=31536000') // Cache for 1 year
            ->header('ETag', md5($file));
    }

    public function search(Request $request)
    {
        // Set PHP max execution time to 5 minutes (300 seconds) for face search
        set_time_limit(300);
        ini_set('max_execution_time', '300');
        
        $request->validate([
            'session_id' => ['required'],
            'image' => ['required', 'file', 'image', 'max:5120'],
        ]);

        $sessionId = (string) $request->input('session_id');
        $session = FaceSession::withCount('images')->findOrFail($sessionId);

        if ($session->images_count < 1) {
            return response()->json([
                'success' => false,
                'message' => 'This session has no dataset images. Please upload images in the web dashboard first.',
            ], 400);
        }

        $aiUrl = rtrim(env('AI_SERVICE_URL', 'http://127.0.0.1:8001'), '/');

        // Save upload to a temporary local file (for forwarding to AI)
        $tmpDir = 'ai_tmp';
        $tmpName = Str::uuid()->toString() . '.' . ($request->file('image')->getClientOriginalExtension() ?: 'jpg');
        $tmpPath = $request->file('image')->storeAs($tmpDir, $tmpName, 'local'); // storage/app/ai_tmp/...
        $absTmpPath = Storage::disk('local')->path($tmpPath);

        try {
            $resp = Http::timeout(300)  // 5 minutes timeout for HTTP request to AI service
                ->attach('image', fopen($absTmpPath, 'r'), $tmpName)
                ->post($aiUrl . '/face/search', [
                    'session_id' => $sessionId,
                ]);

            if (!$resp->ok()) {
                return response()->json([
                    'success' => false,
                    'message' => 'AI service error',
                    'error' => $resp->body(),
                ], 502);
            }

            $payload = $resp->json();
            $matches = $payload['data']['matches'] ?? [];

            // Get the base URL for the API (same host/port the mobile app uses)
            $baseUrl = $request->getSchemeAndHttpHost();
            
            // Fallback: If baseUrl is localhost/127.0.0.1 and request has Host header, use it
            // This helps when mobile app uses 10.0.2.2 (Android emulator) or actual IP
            $hostHeader = $request->header('Host');
            if ($hostHeader && (str_contains($baseUrl, '127.0.0.1') || str_contains($baseUrl, 'localhost'))) {
                $scheme = $request->getScheme();
                $baseUrl = $scheme . '://' . $hostHeader;
            }
            
            // Map identity -> database record and generate API URL (more reliable than file paths)
            $mappedMatches = [];
            foreach ($matches as $m) {
                $identity = $m['identity'] ?? '';
                $distance = $m['distance'] ?? null;

                // AI returns identity relative to DATASET_ROOT: "{session_id}/db/filename.jpg"
                // Normalize the identity path
                $identity = ltrim(str_replace('\\', '/', $identity), '/');
                
                // Construct expected file_path in Laravel storage format
                if (!preg_match('/^\d+\/db\//', $identity)) {
                    // Identity is just filename, construct full path using current session_id
                    $filePath = "face_sessions/{$sessionId}/db/{$identity}";
                } else {
                    // Identity already has session structure
                    $filePath = 'face_sessions/' . $identity;
                }
                
                // Look up image in database by file_path (more reliable than constructing URLs)
                $imageRecord = FaceSessionImage::where('face_session_id', $sessionId)
                    ->where('file_path', $filePath)
                    ->first();
                
                if ($imageRecord) {
                    // Use API endpoint with image ID (database-backed, no file path issues)
                    $imageUrl = rtrim($baseUrl, '/') . '/api/face/image/' . $imageRecord->id;
                    
                    $mappedMatches[] = [
                        'identity' => $identity,
                        'distance' => $distance,
                        'image_id' => $imageRecord->id,
                        'url' => $imageUrl,
                    ];
                } else {
                    // Fallback: If DB record not found, try file-based URL
                    $imageUrl = rtrim($baseUrl, '/') . '/storage/' . ltrim($filePath, '/');
                    
                    $mappedMatches[] = [
                        'identity' => $identity,
                        'distance' => $distance,
                        'url' => $imageUrl,
                        'note' => 'Database record not found, using file path',
                    ];
                }
            }

            return response()->json([
                'success' => true,
                'data' => [
                    'session' => [
                        'id' => $session->id,
                        'name' => $session->name,
                        'place_name' => $session->place_name,
                        'images_count' => $session->images_count,
                    ],
                    'matches' => $mappedMatches,
                ],
            ]);
        } catch (\Throwable $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to connect to AI service',
                'error' => $e->getMessage(),
            ], 502);
        } finally {
            try {
                Storage::disk('local')->delete($tmpPath);
            } catch (\Throwable $e) {
                // ignore
            }
        }
    }
}





