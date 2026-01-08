<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MobileUser extends Model
{
    use HasFactory;

    // Define the fillable fields
    protected $fillable = [
        'full_name',
        'username',
        'email',
        'password',
        'phone_number',
        'gender',
        'dob',
        'status',
        'emergency_contact',
        'police_contact',
    ];

    public function reliefRequests()
    {
        return $this->hasMany(ReliefRequest::class);
    }

    public function reliefDonations()
    {
        return $this->hasMany(ReliefDonation::class);
    }
}
