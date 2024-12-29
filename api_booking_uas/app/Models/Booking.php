<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Booking extends Model
{
    protected $table = 'bookings';
    protected $guarded = ['id'];


    public function hotel()
    {
        return $this->belongsTo(Hotel::class);
    }
}
