<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReliefRequest extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'item_type',
        'item_name',
        'quantity',
        'description',
        'district',
        'status',
    ];

    public function user()
    {
        return $this->belongsTo(MobileUser::class);
    }
}




