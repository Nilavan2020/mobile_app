<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\ReliefRequest;
use App\Models\ReliefDonation;

class DashboardController extends Controller
{
    public function showDashboard()
    {
        // Get request counts by district
        $requestCounts = ReliefRequest::selectRaw('district, COUNT(*) as count')
            ->where('status', 'pending')
            ->groupBy('district')
            ->get()
            ->pluck('count', 'district')
            ->toArray();

        // Get donation counts by district
        $donationCounts = ReliefDonation::selectRaw('district, COUNT(*) as count')
            ->where('status', 'pending')
            ->groupBy('district')
            ->get()
            ->pluck('count', 'district')
            ->toArray();

        // Get overall statistics
        $stats = [
            'total_requests' => ReliefRequest::count(),
            'pending_requests' => ReliefRequest::where('status', 'pending')->count(),
            'fulfilled_requests' => ReliefRequest::where('status', 'fulfilled')->count(),
            'total_donations' => ReliefDonation::count(),
            'pending_donations' => ReliefDonation::where('status', 'pending')->count(),
            'delivered_donations' => ReliefDonation::where('status', 'delivered')->count(),
        ];

        return view('dashboard', compact('requestCounts', 'donationCounts', 'stats'));
    }
}
