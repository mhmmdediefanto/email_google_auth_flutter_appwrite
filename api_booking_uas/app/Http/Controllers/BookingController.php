<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    public function index()
    {
        $boking = Booking::with('hotel')->get();
        return response()->json($boking);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'full_name' => 'required',
            'hotel_id' => 'required',
            'kelas' => 'required',
            'tanggal_checkin' => 'required',
            'tanggal_checkout' => 'required',
        ]);

        if ($validated) {
            Booking::create($validated);
            return response()->json('booking success');
        }

        return response()->json('booking failed');
    }
}
