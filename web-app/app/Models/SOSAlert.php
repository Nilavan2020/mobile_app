<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SOSAlert extends Model
{
    use HasFactory;

    protected $table = 'sos_alerts';

    protected $fillable = [
        'user_id',
        'user_name',
        'user_phone',
        'emergency_contact',
        'police_contact',
        'latitude',
        'longitude',
        'location_details',
        'is_danger_area',
        'alert_level',
        'alert_time',
        'sms_recipients',
        'sms_message',
        'sms_sent',
        'sms_status',
        'status',
        'closed_at',
        'closed_by',
    ];

    protected $casts = [
        'is_danger_area' => 'boolean',
        'sms_sent' => 'boolean',
        'alert_time' => 'datetime',
        'sms_recipients' => 'array',
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
        'closed_at' => 'datetime',
    ];

    /**
     * Get the mobile user that sent this alert
     */
    public function mobileUser()
    {
        return $this->belongsTo(MobileUser::class, 'user_id');
    }

    /**
     * Scope to get unread alerts
     */
    public function scopeUnread($query)
    {
        return $query->where('sms_sent', true);
    }

    /**
     * Scope to get alerts by level
     */
    public function scopeByLevel($query, $level)
    {
        return $query->where('alert_level', $level);
    }
}

