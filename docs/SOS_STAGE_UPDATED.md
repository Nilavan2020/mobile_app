# SOS Alert Stages - Updated Rules

## Stage 2 Trigger - UPDATED ✅

**New Condition:** 
- Time >= 18:00 (6 PM) **OR** Time <= 05:00 (5 AM morning) **AND** Danger Area

This means Stage 2 triggers during **nighttime hours** (6 PM to 5 AM) when in a danger area.

## Complete Stage Rules

### Stage 1: Standard Alert
**Condition:** Daytime (06:01 to 17:59) **AND** Safe Area

**What Happens:**
- ✅ Sends SMS to **Emergency Contact only** (1 message)
- ✅ Message: "⚠️ WARNING DANGER ⚠️"

**Time Range:** 06:01 AM to 05:59 PM (daytime)

---

### Stage 2: Serious Alert  
**Condition:** Nighttime (>= 18:00 **OR** <= 05:00) **AND** Danger Area

**What Happens:**
- ✅ Sends SMS to **Emergency Contact + Police** (2 messages)
- ✅ Message: "⚠️ WARNING SERIOUS DANGER ⚠️"

**Time Range:** 
- 06:00 PM (18:00) to 11:59 PM (23:59)
- 12:00 AM (00:00) to 05:00 AM (05:00)

---

### Fallback: Stage 1 (Default)
**Condition:** Any other combination

**What Happens:**
- ✅ Defaults to Stage 1 (Emergency Contact only)

---

## Time Range Visualization

```
00:00 (Midnight) ──────────────────────────────────────────────── 23:59
│                                                                  │
│  STAGE 2 Range (if Danger Area)                                 │
│  ┌─────────────────────────────────────────────────────┐        │
│  │                                                     │        │
│  │ 00:00 ──────── 05:00 ──── 06:00 ──── 18:00 ─────── 23:59   │
│  │   ▲                                                   ▲      │
│  │   │                                                   │      │
│  └───┴───────────────────────────────────────────────────┴──┐  │
│      Stage 2                    Stage 1        Stage 2      │  │
│      (Night)                   (Daytime)      (Night)       │  │
│                                                               │  │
└───────────────────────────────────────────────────────────────┘  │
                                                                   │
STAGE 1 Range (if Safe Area) - Always                             │
```

## Examples

### Stage 2 Examples:
- ✅ **7 PM (19:00)** in rural area → Stage 2 (nighttime + danger)
- ✅ **11 PM (23:00)** in forest → Stage 2 (nighttime + danger)
- ✅ **2 AM (02:00)** in countryside → Stage 2 (nighttime + danger)
- ✅ **4 AM (04:00)** in village → Stage 2 (nighttime + danger)

### Stage 1 Examples:
- ✅ **2 PM (14:00)** in city → Stage 1 (daytime + safe)
- ✅ **10 AM (10:00)** in shopping mall → Stage 1 (daytime + safe)
- ✅ **7 PM (19:00)** in city → Stage 1 (nighttime but safe area - fallback)
- ✅ **3 AM (03:00)** in city → Stage 1 (nighttime but safe area - fallback)

## Code Changes

### Backend (`SOSController.php`)
```php
// OLD:
$isAfter6PM = $currentHour >= 18;

// NEW:
$isInNightTime = ($currentHour >= 18) || ($currentHour <= 5);

// Stage 2 trigger:
if ($isInNightTime && $isDangerArea) {
    // Stage 2: Emergency + Police
}
```

### Mobile App (`sos_tab_screen.dart`)
- Debug logging updated to show "Is Nighttime" instead of "Is After 6PM"
- Logic remains the same (sends hour to backend, backend decides)

## Summary

✅ **Stage 2** now triggers during **nighttime hours** (6 PM to 5 AM) when in a **danger area**  
✅ **Stage 1** triggers during **daytime hours** (6 AM to 5:59 PM) when in a **safe area**  
✅ All other combinations default to **Stage 1** for safety

