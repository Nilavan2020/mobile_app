<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FaceSessionImage extends Model
{
    use HasFactory;

    protected $fillable = [
        'face_session_id',
        'file_path',
        'original_name',
    ];

    public function session()
    {
        return $this->belongsTo(FaceSession::class, 'face_session_id');
    }
}





