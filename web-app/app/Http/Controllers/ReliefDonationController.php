<?php

namespace App\Http\Controllers;

use App\Models\ReliefDonation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ReliefDonationController extends Controller
{
    public function index()
    {
        $stats = [
            'total' => ReliefDonation::count(),
            'pending' => ReliefDonation::where('status', 'pending')->count(),
            'delivered' => ReliefDonation::where('status', 'delivered')->count(),
            'cancelled' => ReliefDonation::where('status', 'cancelled')->count(),
        ];

        return view('relief-donations', compact('stats'));
    }

    public function processAjax(Request $request)
    {
        $recordsTotal = DB::table('relief_donations')->count();

        $query = DB::table('relief_donations')
            ->join('mobile_users', 'relief_donations.user_id', '=', 'mobile_users.id')
            ->select(
                'relief_donations.*',
                'mobile_users.full_name',
                'mobile_users.email'
            );

        // Search
        if ($request->filled('search.value')) {
            $search = $request->input('search.value');
            $query->where(function ($q) use ($search) {
                $q->where('relief_donations.item_name', 'like', '%' . $search . '%')
                  ->orWhere('relief_donations.district', 'like', '%' . $search . '%')
                  ->orWhere('relief_donations.item_type', 'like', '%' . $search . '%')
                  ->orWhere('relief_donations.status', 'like', '%' . $search . '%')
                  ->orWhere('mobile_users.full_name', 'like', '%' . $search . '%')
                  ->orWhere('mobile_users.email', 'like', '%' . $search . '%');
            });
        }

        $recordsFiltered = $query->count();

        // Pagination
        $limit = (int) $request->input('length', 10);
        $offset = (int) $request->input('start', 0);

        $donations = $query->orderBy('relief_donations.created_at', 'DESC')
            ->skip($offset)
            ->take($limit)
            ->get();

        $data = [];
        foreach ($donations as $don) {
            $data[] = [
                'id' => $don->id,
                'user_name' => $don->full_name ?? 'N/A',
                'user_email' => $don->email ?? '',
                'item_type' => ucfirst($don->item_type),
                'item_name' => $don->item_name,
                'quantity' => $don->quantity,
                'district' => $don->district,
                'status' => $don->status,
                'created_at' => date('Y-m-d H:i', strtotime($don->created_at)),
            ];
        }

        return response()->json([
            'draw' => intval($request->input('draw')),
            'recordsTotal' => $recordsTotal,
            'recordsFiltered' => $recordsFiltered,
            'data' => $data,
        ]);
    }

    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:pending,delivered,cancelled',
        ]);

        $donation = ReliefDonation::findOrFail($id);
        $donation->status = $request->status;
        $donation->save();

        return response()->json(['success' => true, 'message' => 'Donation status updated successfully.']);
    }
}

