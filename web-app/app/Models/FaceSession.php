<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FaceSession extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'place_name',
        'notes',
        'created_by',
    ];

    public function images()
    {
        return $this->hasMany(FaceSessionImage::class);
    }

    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }
}





