# SOS Alert Stages: Stage 1 vs Stage 2 Explained

## Overview
The mobile app has a two-stage emergency alert system that automatically determines the severity level based on **time** and **location**.

## Decision Logic

The system uses **two factors** to determine which stage to trigger:

### Factor 1: Time (6 PM = 18:00)
- **Before 6 PM** (Time < 18:00) = Daytime
- **After 6 PM** (Time >= 18:00) = Evening/Night

### Factor 2: Location Type
- **Safe Area** = Populated/Crowded areas (cities, towns, commercial areas, residential)
- **Danger Area** = Isolated/Quiet areas (rural, forest, countryside, villages)

## Stage Determination Rules

### Stage 1: Standard Alert
**Condition:** `Time < 6 PM` **AND** `Safe Area`

**What Happens:**
- ✅ Sends SMS to **Emergency Contact only** (1 message)
- ✅ Message: "⚠️ WARNING DANGER ⚠️"
- ✅ Less urgent - user is in a populated area during daytime

**Example Scenarios:**
- User in city center at 2 PM → Stage 1
- User in shopping mall at 10 AM → Stage 1
- User in residential area at 5 PM → Stage 1

---

### Stage 2: Serious Alert
**Condition:** `Time >= 6 PM` **AND** `Danger Area`

**What Happens:**
- ✅ Sends SMS to **Emergency Contact + Police** (2 messages)
- ✅ Message: "⚠️ WARNING SERIOUS DANGER ⚠️"
- ✅ More urgent - user is in isolated area during evening/night

**Example Scenarios:**
- User in rural area at 8 PM → Stage 2
- User in forest at 7 PM → Stage 2
- User in countryside at 9 PM → Stage 2

---

### Fallback: Stage 1 (Default)
**Condition:** Any other combination

**What Happens:**
- ✅ Defaults to Stage 1 (Emergency Contact only)
- ✅ Used when conditions don't match Stage 2

**Example Scenarios:**
- User in city at 8 PM → Stage 1 (safe area, but after 6 PM)
- User in rural area at 2 PM → Stage 1 (danger area, but before 6 PM)

---

## How It Works in Mobile App

### Step 1: User Taps SOS Button
```dart
// User activates SOS switch
_toggleSOS() → _sendSOSAlert()
```

### Step 2: Location Check
```dart
// App checks if location is danger area
_checkLocation() → LocationAnalyzer.isDangerArea()
```

**Location Analysis:**
- Uses OpenStreetMap reverse geocoding
- Checks location type (city, rural, forest, etc.)
- Returns: `true` = Danger Area, `false` = Safe Area

**Safe Areas (Populated):**
- City, Town, Commercial, Retail, Industrial
- Urban, Suburb, Residential

**Danger Areas (Isolated):**
- Rural, Forest, Farm, Village, Hamlet
- Countryside, Country

### Step 3: Time Check
```dart
// App gets current time from mobile phone
final now = DateTime.now();
final currentHour = now.hour;  // 0-23
```

**Time Logic:**
- `currentHour >= 18` = After 6 PM (evening/night)
- `currentHour < 18` = Before 6 PM (daytime)

### Step 4: Send Data to Backend
```dart
// Mobile app sends to Laravel API
{
  'user_id': 123,
  'mobile_time': '2026-01-07T20:30:00',
  'mobile_hour': 20,  // 8 PM
  'is_danger_area': true,  // or false
  'latitude': 7.2906,
  'longitude': 80.6337,
  'location_details': 'Kandy, Central Province'
}
```

### Step 5: Backend Decision
```php
// Laravel determines stage
if ($isAfter6PM && $isDangerArea) {
    // Stage 2: Send to Emergency Contact + Police
} elseif (!$isAfter6PM && !$isDangerArea) {
    // Stage 1: Send to Emergency Contact only
} else {
    // Fallback: Stage 1 (Emergency Contact only)
}
```

---

## Visual Flow Diagram

```
User Taps SOS
    ↓
Get Location (GPS)
    ↓
Analyze Location Type
    ├─→ Safe Area (City/Town) ──┐
    └─→ Danger Area (Rural/Forest) ──┐
                                      │
Get Current Time                      │
    ├─→ Before 6 PM (< 18:00) ───────┤
    └─→ After 6 PM (>= 18:00) ────────┤
                                      │
    ┌─────────────────────────────────┘
    │
    ├─→ Time >= 6 PM AND Danger Area
    │   └─→ STAGE 2: Emergency + Police (2 SMS)
    │
    ├─→ Time < 6 PM AND Safe Area
    │   └─→ STAGE 1: Emergency Only (1 SMS)
    │
    └─→ Other Combinations
        └─→ STAGE 1: Emergency Only (1 SMS)
```

---

## SMS Message Differences

### Stage 1 Message
```
⚠️ WARNING DANGER ⚠️

Alert from: [User Name]
Phone: [User Phone]
Warning Status: Very Danger Area

Location: [Location Details]
Coordinates: [Lat, Lon]
Map: https://www.google.com/maps?q=[Lat],[Lon]

Time: [Timestamp]

Please respond immediately.
```

### Stage 2 Message
```
⚠️ WARNING SERIOUS DANGER ⚠️

Alert from: [User Name]
Phone: [User Phone]
Warning Status: Very Danger Area

Location: [Location Details]
Coordinates: [Lat, Lon]
Map: https://www.google.com/maps?q=[Lat],[Lon]

Time: [Timestamp]

IMMEDIATE ACTION REQUIRED
This is a SERIOUS EMERGENCY. User needs immediate assistance.
```

---

## Key Points

1. **Time Source:** Uses mobile phone's time (not server time) to avoid timezone issues
2. **Location Analysis:** Automatic - uses OpenStreetMap to determine area type
3. **Stage 2 is More Serious:** Only triggered when BOTH conditions are met (night + isolated)
4. **Fallback Safety:** If unsure, defaults to Stage 1 (safer option)
5. **User Can Check Location:** "Check if Area is Safe" button shows current status

---

## Testing Scenarios

### Test Stage 1
1. Set phone time to 2 PM (before 6 PM)
2. Go to a city/shopping area (safe area)
3. Tap SOS
4. ✅ Should send to Emergency Contact only

### Test Stage 2
1. Set phone time to 8 PM (after 6 PM)
2. Go to a rural/forest area (danger area)
3. Tap SOS
4. ✅ Should send to Emergency Contact + Police

### Test Fallback
1. Set phone time to 8 PM (after 6 PM)
2. Go to a city area (safe area)
3. Tap SOS
4. ✅ Should send to Emergency Contact only (Stage 1 fallback)

---

## Code Locations

- **Mobile App Logic:** `mobile-app/lib/dashboard/sos_tab_screen.dart`
- **Location Analysis:** `mobile-app/lib/services/location_analyzer.dart`
- **Backend Decision:** `web-app/app/Http/Controllers/API/SOSController.php` (lines 134-199)
- **SMS Sending:** `web-app/app/Http/Controllers/API/SOSController.php` (lines 350-456)

