<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\MobileUser;
use App\Models\SOSAlert;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Http;

class SOSController extends Controller
{
    /**
     * Send SOS alert via SMS to emergency contact and police
     * 
     * This endpoint receives the SOS alert request and prepares to send SMS.
     * The actual SMS gateway integration will be added when gateway information is provided.
     */
    public function sendAlert(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:mobile_users,id',
            'emergency_contact' => 'nullable|string|max:20',
            'police_contact' => 'nullable|string|max:20',
            'user_name' => 'nullable|string',
            'user_phone' => 'nullable|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'is_danger_area' => 'nullable|boolean',
            'location_details' => 'nullable|string',
        ]);

        $userId = $request->user_id;
        $emergencyContact = $request->emergency_contact;
        $policeContact = $request->police_contact;
        $userName = $request->user_name ?? 'User';
        $userPhone = $request->user_phone ?? '';
        $latitude = $request->latitude;
        $longitude = $request->longitude;
        // Get is_danger_area - handle both boolean and string values
        $isDangerAreaInput = $request->input('is_danger_area', false);
        // Convert to boolean properly - handle true, false, "true", "false", 1, 0, etc.
        if (is_bool($isDangerAreaInput)) {
            $isDangerArea = $isDangerAreaInput;
        } elseif (is_string($isDangerAreaInput)) {
            $isDangerArea = in_array(strtolower($isDangerAreaInput), ['true', '1', 'yes']);
        } elseif (is_numeric($isDangerAreaInput)) {
            $isDangerArea = (bool) $isDangerAreaInput;
        } else {
            $isDangerArea = (bool) $isDangerAreaInput;
        }
        $locationDetails = $request->location_details ?? '';

        // Get user's emergency contacts from database if not provided
        $user = MobileUser::find($userId);
        if ($user) {
            if (empty($emergencyContact) && !empty($user->emergency_contact)) {
                $emergencyContact = $user->emergency_contact;
            }
            if (empty($policeContact) && !empty($user->police_contact)) {
                $policeContact = $user->police_contact;
            }
            if (empty($userName)) {
                $userName = $user->full_name;
            }
            if (empty($userPhone)) {
                $userPhone = $user->phone_number;
            }
        }

        // Check if at least one contact is available
        if (empty($emergencyContact) && empty($policeContact)) {
            return response()->json([
                'success' => false,
                'message' => 'No emergency contacts found. Please add emergency contacts in your profile.',
            ], 400);
        }

        // Get mobile phone's time (NOT server time!)
        // The mobile app sends mobile_time and mobile_hour as parameters
        $mobileTime = $request->input('mobile_time');
        $mobileHour = $request->input('mobile_hour');
        
        // Initialize with server time as default
        $currentTime = now();
        $currentHour = (int) $currentTime->format('H');
        
        // Use mobile phone time if provided
        if (!empty($mobileTime) && $mobileHour !== null) {
            try {
                $currentTime = new \DateTime($mobileTime);
                $currentHour = (int) $mobileHour;
                error_log("Using mobile phone time: " . $currentTime->format('Y-m-d H:i:s') . " (Hour: $currentHour)");
            } catch (\Exception $e) {
                // Fallback to server time if parsing fails
                error_log("WARNING: Failed to parse mobile time: " . $e->getMessage() . ", using server time");
            }
        } else {
            // Fallback to server time if mobile time not provided
            error_log("WARNING: Mobile time not provided, using server time");
        }
        
        // Stage 2 time range: >= 18:00 (6 PM) AND <= 05:00 (5 AM morning)
        // This covers nighttime: 6 PM to 5 AM
        $isInNightTime = ($currentHour >= 18) || ($currentHour <= 5); // 6 PM = 18:00

        // PRINT DIRECTLY TO TERMINAL/STDERR FOR DEBUGGING
        $stderr = defined('STDERR') ? STDERR : fopen('php://stderr', 'w');
        fwrite($stderr, "\n");
        fwrite($stderr, "===========================================\n");
        fwrite($stderr, "SOS ALERT DEBUG INFO\n");
        fwrite($stderr, "===========================================\n");
        fwrite($stderr, "MOBILE PHONE TIME (from mobile): " . $currentTime->format('Y-m-d H:i:s') . "\n");
        fwrite($stderr, "MOBILE PHONE HOUR: " . $currentHour . "\n");
        fwrite($stderr, "IS NIGHTTIME (>=18 OR <=5)? " . ($isInNightTime ? 'YES' : 'NO') . "\n");
        fwrite($stderr, "IS DANGER AREA? " . ($isDangerArea ? 'YES' : 'NO') . "\n");
        fwrite($stderr, "DANGER AREA VALUE: " . var_export($isDangerArea, true) . "\n");
        fwrite($stderr, "DANGER AREA TYPE: " . gettype($isDangerArea) . "\n");
        fwrite($stderr, "RAW INPUT: " . var_export($request->input('is_danger_area'), true) . "\n");
        fwrite($stderr, "===========================================\n");
        
        // Also log to Laravel log
        Log::info('SOS Alert - Conditions Check', [
            'current_hour' => $currentHour,
            'current_time' => $currentTime->format('Y-m-d H:i:s'),
            'is_nighttime' => $isInNightTime,
            'is_nighttime_bool' => var_export($isInNightTime, true),
            'is_danger_area' => $isDangerArea,
            'is_danger_area_bool' => var_export($isDangerArea, true),
            'is_danger_area_type' => gettype($isDangerArea),
            'is_danger_area_raw' => $request->input('is_danger_area'),
            'all_request_data' => $request->all(),
        ]);

        // Determine alert level and recipients based on time and location
        $alertLevel = 'stage_1';
        $recipients = [];
        $smsRecipients = [];

        // RULE: 
        // Stage 1: Daytime (06:01 to 17:59) AND safe area → Emergency contact only (1 message)
        // Stage 2: Nighttime (>= 18:00 OR <= 05:00) AND danger area → Emergency contact + Police (2 messages)
        
        $stderr = defined('STDERR') ? STDERR : fopen('php://stderr', 'w');
        fwrite($stderr, "CHECKING CONDITIONS:\n");
        fwrite($stderr, "  Nighttime (>=18 OR <=5)? " . ($isInNightTime ? 'YES' : 'NO') . "\n");
        fwrite($stderr, "  Danger Area? " . ($isDangerArea ? 'YES' : 'NO') . "\n");
        
        // Stage 2: Nighttime (>= 18:00 OR <= 05:00) AND danger area
        if ($isInNightTime && $isDangerArea) {
            $alertLevel = 'stage_2';
            fwrite($stderr, ">>> STAGE 2 SELECTED (Nighttime AND Danger Area) <<<\n");
            fwrite($stderr, "Sending to: Emergency Contact + Police (2 messages)\n");
            
            if (!empty($emergencyContact)) {
                $recipients[] = [
                    'type' => 'emergency',
                    'number' => $emergencyContact,
                    'alert_level' => 'stage_2',
                ];
            }
            if (!empty($policeContact)) {
                $recipients[] = [
                    'type' => 'police',
                    'number' => $policeContact,
                    'alert_level' => 'stage_2',
                ];
            }
        }
        // Stage 1: Daytime (06:01 to 17:59) AND safe area
        elseif (!$isInNightTime && !$isDangerArea) {
            $alertLevel = 'stage_1';
            fwrite($stderr, ">>> STAGE 1 SELECTED (Daytime AND Safe Area) <<<\n");
            fwrite($stderr, "Sending to: Emergency Contact only (1 message)\n");
            
            if (!empty($emergencyContact)) {
                $recipients[] = [
                    'type' => 'emergency',
                    'number' => $emergencyContact,
                    'alert_level' => 'stage_1',
                ];
            }
        }
        // Fallback: Any other combination → Stage 1 (emergency contact only)
        else {
            $alertLevel = 'stage_1';
            fwrite($stderr, ">>> FALLBACK TO STAGE 1 <<<\n");
            fwrite($stderr, "  Reason: Other combination\n");
            fwrite($stderr, "  Nighttime? " . ($isInNightTime ? 'YES' : 'NO') . "\n");
            fwrite($stderr, "  Danger Area? " . ($isDangerArea ? 'YES' : 'NO') . "\n");
            fwrite($stderr, "Sending to: Emergency Contact only (1 message)\n");
            
            if (!empty($emergencyContact)) {
                $recipients[] = [
                    'type' => 'emergency',
                    'number' => $emergencyContact,
                    'alert_level' => 'stage_1',
                ];
            }
        }
        
        fwrite($stderr, "FINAL ALERT LEVEL: " . $alertLevel . "\n");
        fwrite($stderr, "RECIPIENTS COUNT: " . count($recipients) . "\n");
        fwrite($stderr, "===========================================\n\n");
        
        Log::info('SOS Alert - Final Decision', [
            'alert_level' => $alertLevel,
            'recipients_count' => count($recipients),
            'recipients' => $recipients,
        ]);

        // Prepare SMS message based on alert level
        if ($alertLevel === 'stage_2') {
            // Stage 2: Warning Serious Danger
            $message = "⚠️ WARNING SERIOUS DANGER ⚠️\n\n";
            $message .= "Alert from: $userName\n";
            $message .= "Phone: $userPhone\n";
            $message .= "Warning Status: Very Danger Area\n\n";
            
            if ($latitude && $longitude) {
                $message .= "Location: $locationDetails\n";
                $message .= "Coordinates: $latitude, $longitude\n";
                $message .= "Map: https://www.google.com/maps?q=$latitude,$longitude\n";
            }
            
            $message .= "Time: " . $currentTime->format('Y-m-d H:i:s') . "\n\n";
            $message .= "IMMEDIATE ACTION REQUIRED\n";
            $message .= "This is a SERIOUS EMERGENCY. User needs immediate assistance.";
        } else {
            // Stage 1: Warning Danger
            $message = "⚠️ WARNING DANGER ⚠️\n\n";
            $message .= "Alert from: $userName\n";
            $message .= "Phone: $userPhone\n";
            $message .= "Warning Status: Very Danger Area\n\n";
            
            if ($latitude && $longitude) {
                $message .= "Location: $locationDetails\n";
                $message .= "Coordinates: $latitude, $longitude\n";
                $message .= "Map: https://www.google.com/maps?q=$latitude,$longitude\n";
            }
            
            $message .= "Time: " . $currentTime->format('Y-m-d H:i:s') . "\n\n";
            $message .= "Please respond immediately.";
        }

        // Create SOS alert record
        $sosAlert = SOSAlert::create([
            'user_id' => $userId,
            'user_name' => $userName,
            'user_phone' => $userPhone,
            'emergency_contact' => $emergencyContact,
            'police_contact' => $policeContact,
            'latitude' => $latitude,
            'longitude' => $longitude,
            'location_details' => $locationDetails,
            'is_danger_area' => $isDangerArea,
            'alert_level' => $alertLevel,
            'alert_time' => $currentTime,
            'sms_message' => $message,
            'sms_sent' => false,
            'sms_status' => 'pending',
        ]);

        // Send SMS to recipients using Notify.lk API
        $sentCount = 0;
        $failedCount = 0;

        foreach ($recipients as $recipient) {
            try {
                $smsResult = $this->sendSMSViaNotifyLK(
                    $recipient['number'],
                    $message
                );

                $smsRecipients[] = [
                    'type' => $recipient['type'],
                    'number' => $recipient['number'],
                    'alert_level' => $recipient['alert_level'],
                    'status' => $smsResult['status'],
                    'message' => $smsResult['message'] ?? null,
                ];

                if ($smsResult['status'] === 'success') {
                    $sentCount++;
                } else {
                    $failedCount++;
                }
            } catch (\Exception $e) {
                Log::error('Error sending SMS to recipient', [
                    'recipient' => $recipient['number'],
                    'error' => $e->getMessage(),
                ]);
                $smsRecipients[] = [
                    'type' => $recipient['type'],
                    'number' => $recipient['number'],
                    'alert_level' => $recipient['alert_level'],
                    'status' => 'failed',
                    'message' => $e->getMessage(),
                ];
                $failedCount++;
            }
        }

        // Update SOS alert with SMS results
        $sosAlert->update([
            'sms_recipients' => $smsRecipients,
            'sms_sent' => $sentCount > 0,
            'sms_status' => $failedCount === 0 ? 'success' : ($sentCount > 0 ? 'partial' : 'failed'),
        ]);

        Log::info('SOS Alert Sent', [
            'alert_id' => $sosAlert->id,
            'user_id' => $userId,
            'alert_level' => $alertLevel,
            'current_hour' => $currentHour,
            'is_nighttime' => $isInNightTime,
            'is_danger_area' => $isDangerArea,
            'sent_count' => $sentCount,
            'failed_count' => $failedCount,
            'recipients' => $smsRecipients,
        ]);

        // Build detailed error message if SMS failed
        $errorMessage = "Failed to send SOS alert. Please try again.";
        if ($sentCount == 0 && !empty($smsRecipients)) {
            $firstError = $smsRecipients[0]['message'] ?? 'Unknown error';
            if (strpos($firstError, 'SMS gateway not configured') !== false) {
                $errorMessage = "SMS gateway not configured. Please contact administrator.";
            } else {
                $errorMessage = "Failed to send SMS: " . $firstError;
            }
        } elseif (empty($recipients)) {
            $errorMessage = "No emergency contacts configured. Please add emergency contacts in your profile.";
        }

        return response()->json([
            'success' => $sentCount > 0,
            'message' => $sentCount > 0 
                ? "SOS alert sent to $sentCount contact(s)." 
                : $errorMessage,
            'data' => [
                'alert_id' => $sosAlert->id,
                'alert_level' => $alertLevel,
                'recipients' => $smsRecipients,
                'sent_count' => $sentCount,
                'failed_count' => $failedCount,
                'error_details' => $sentCount == 0 ? $smsRecipients : null,
            ],
        ], $sentCount > 0 ? 200 : 400);
    }

    /**
     * Send SMS via Notify.lk API
     * 
     * @param string $phoneNumber Recipient phone number (format: 9471XXXXXXX)
     * @param string $message SMS message content
     * @return array Response with status and message
     */
    private function sendSMSViaNotifyLK($phoneNumber, $message)
    {
        try {
            // Get Notify.lk credentials from .env
            $userId = env('NOTIFY_LK_USER_ID');
            $apiKey = env('NOTIFY_LK_API_KEY');
            $senderId = env('NOTIFY_LK_SENDER_ID', 'NotifyDEMO');

            if (empty($userId) || empty($apiKey)) {
                Log::error('Notify.lk credentials not configured', [
                    'phone' => $phoneNumber,
                ]);
                return [
                    'status' => 'failed',
                    'message' => 'SMS gateway not configured',
                ];
            }

            // Format phone number (remove +, spaces, ensure it starts with 94)
            $phoneNumber = preg_replace('/[^0-9]/', '', $phoneNumber);
            if (strlen($phoneNumber) === 9) {
                $phoneNumber = '94' . $phoneNumber;
            } elseif (strlen($phoneNumber) === 10 && substr($phoneNumber, 0, 1) === '0') {
                $phoneNumber = '94' . substr($phoneNumber, 1);
            }

            // Truncate message to 621 characters (Notify.lk limit)
            if (strlen($message) > 621) {
                $message = substr($message, 0, 618) . '...';
            }

            // Send SMS via Notify.lk API with timeout
            // Disable SSL verification for local development (only in non-production)
            $httpClient = Http::timeout(15);
            
            // In local development, disable SSL verification to avoid certificate issues
            if (env('APP_ENV') === 'local' || env('APP_DEBUG') === true) {
                $httpClient = $httpClient->withoutVerifying();
            }
            
            $response = $httpClient->get('https://app.notify.lk/api/v1/send', [
                'user_id' => $userId,
                'api_key' => $apiKey,
                'sender_id' => $senderId,
                'to' => $phoneNumber,
                'message' => $message,
            ]);

            // Handle JSON decode errors
            try {
                $responseData = $response->json();
            } catch (\Exception $e) {
                Log::error('Failed to decode Notify.lk response', [
                    'phone' => $phoneNumber,
                    'response_body' => $response->body(),
                    'error' => $e->getMessage(),
                ]);
                return [
                    'status' => 'failed',
                    'message' => 'Invalid response from SMS gateway: ' . substr($response->body(), 0, 100),
                ];
            }

            if ($response->successful() && isset($responseData['status']) && $responseData['status'] === 'success') {
                Log::info('SMS sent successfully via Notify.lk', [
                    'phone' => $phoneNumber,
                    'response' => $responseData,
                ]);

                return [
                    'status' => 'success',
                    'message' => $responseData['data'] ?? 'Sent',
                ];
            } else {
                $errorMsg = $responseData['message'] ?? ($responseData['error'] ?? 'Unknown error');
                Log::error('SMS sending failed via Notify.lk', [
                    'phone' => $phoneNumber,
                    'response' => $responseData,
                    'status_code' => $response->status(),
                    'response_body' => $response->body(),
                ]);

                return [
                    'status' => 'failed',
                    'message' => $errorMsg,
                ];
            }
        } catch (\Exception $e) {
            Log::error('Exception while sending SMS via Notify.lk', [
                'phone' => $phoneNumber,
                'error' => $e->getMessage(),
            ]);

            return [
                'status' => 'failed',
                'message' => $e->getMessage(),
            ];
        }
    }

    /**
     * Send Stage 3 Alert - Voice-activated aggressive emergency alert
     * Called by external Python script (src_stage3.py)
     */
    public function sendStage3Alert(Request $request)
    {
        $request->validate([
            'user_name' => 'nullable|string|max:255',
            'user_phone' => 'nullable|string|max:20',
            'emergency_contact' => 'nullable|string|max:20',
            'police_contact' => 'nullable|string|max:20',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'location_details' => 'nullable|string',
            'sms_message' => 'required|string',
        ]);

        $userName = $request->user_name ?? 'Voice Alert User';
        $userPhone = $request->user_phone ?? '';
        $emergencyContact = $request->emergency_contact;
        $policeContact = $request->police_contact;
        $latitude = $request->latitude;
        $longitude = $request->longitude;
        $locationDetails = $request->location_details ?? 'Location not available';
        $smsMessage = $request->sms_message; // Message from Python script

        // For Stage 3, we need at least emergency contact or police contact
        if (empty($emergencyContact) && empty($policeContact)) {
            return response()->json([
                'success' => false,
                'message' => 'Emergency contact or police contact is required for Stage 3 alerts',
            ], 400);
        }

        // Get current time
        $currentTime = now();

        // Stage 3 is the most serious - always send to both if available
        $recipients = [];
        $smsRecipients = [];

        if (!empty($emergencyContact)) {
            $recipients[] = [
                'type' => 'emergency',
                'number' => $emergencyContact,
                'alert_level' => 'stage_3',
            ];
        }
        if (!empty($policeContact)) {
            $recipients[] = [
                'type' => 'police',
                'number' => $policeContact,
                'alert_level' => 'stage_3',
            ];
        }

        // Create SOS alert record with stage_3
        // For Stage 3, user_id is optional (external script may not have user account)
        $sosAlert = SOSAlert::create([
            'user_id' => $request->user_id ?? 1, // Default to user_id 1 if not provided
            'user_name' => $userName,
            'user_phone' => $userPhone,
            'emergency_contact' => $emergencyContact,
            'police_contact' => $policeContact,
            'latitude' => $latitude,
            'longitude' => $longitude,
            'location_details' => $locationDetails,
            'is_danger_area' => true, // Stage 3 is always considered danger
            'alert_level' => 'stage_3', // Tagged as stage_3
            'alert_time' => $currentTime,
            'sms_message' => $smsMessage,
            'sms_sent' => false,
            'sms_status' => 'pending',
        ]);

        // Send SMS to recipients
        $sentCount = 0;
        $failedCount = 0;

        foreach ($recipients as $recipient) {
            try {
                $smsResult = $this->sendSMSViaNotifyLK(
                    $recipient['number'],
                    $smsMessage
                );

                $smsRecipients[] = [
                    'type' => $recipient['type'],
                    'number' => $recipient['number'],
                    'alert_level' => $recipient['alert_level'],
                    'status' => $smsResult['status'],
                    'message' => $smsResult['message'] ?? null,
                ];

                if ($smsResult['status'] === 'success') {
                    $sentCount++;
                } else {
                    $failedCount++;
                }
            } catch (\Exception $e) {
                Log::error('Error sending Stage 3 SMS to recipient', [
                    'recipient' => $recipient['number'],
                    'error' => $e->getMessage(),
                ]);
                $smsRecipients[] = [
                    'type' => $recipient['type'],
                    'number' => $recipient['number'],
                    'alert_level' => $recipient['alert_level'],
                    'status' => 'failed',
                    'message' => $e->getMessage(),
                ];
                $failedCount++;
            }
        }

        // Update SOS alert with SMS results
        $sosAlert->update([
            'sms_recipients' => $smsRecipients,
            'sms_sent' => $sentCount > 0,
            'sms_status' => $failedCount === 0 ? 'success' : ($sentCount > 0 ? 'partial' : 'failed'),
        ]);

        Log::info('Stage 3 Alert Sent', [
            'alert_id' => $sosAlert->id,
            'user_name' => $userName,
            'alert_level' => 'stage_3',
            'sent_count' => $sentCount,
            'failed_count' => $failedCount,
            'recipients' => $smsRecipients,
        ]);

        return response()->json([
            'success' => $sentCount > 0,
            'message' => $sentCount > 0 
                ? "Stage 3 alert sent to $sentCount contact(s)." 
                : "Failed to send Stage 3 alert",
            'data' => [
                'alert_id' => $sosAlert->id,
                'alert_level' => 'stage_3',
                'recipients' => $smsRecipients,
                'sent_count' => $sentCount,
                'failed_count' => $failedCount,
            ],
        ], $sentCount > 0 ? 200 : 400);
    }
}

