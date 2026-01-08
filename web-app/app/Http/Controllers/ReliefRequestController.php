<?php

namespace App\Http\Controllers;

use App\Models\ReliefRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ReliefRequestController extends Controller
{
    public function index(Request $request)
    {
        $selectedDistrict = $request->get('district');
        
        // Get all unique districts from relief requests
        $districts = ReliefRequest::select('district')
            ->distinct()
            ->orderBy('district')
            ->pluck('district')
            ->toArray();
        
        $stats = [
            'total' => ReliefRequest::count(),
            'pending' => ReliefRequest::where('status', 'pending')->count(),
            'fulfilled' => ReliefRequest::where('status', 'fulfilled')->count(),
            'cancelled' => ReliefRequest::where('status', 'cancelled')->count(),
        ];

        return view('relief-requests', compact('stats', 'selectedDistrict', 'districts'));
    }

    public function processAjax(Request $request)
    {
        $recordsTotal = DB::table('relief_requests')->count();

        $query = DB::table('relief_requests')
            ->join('mobile_users', 'relief_requests.user_id', '=', 'mobile_users.id')
            ->select(
                'relief_requests.*',
                'mobile_users.full_name',
                'mobile_users.email'
            );

        // Filter by district if provided and not "All"
        if ($request->filled('district') && $request->input('district') !== 'all' && $request->input('district') !== '') {
            $district = $request->input('district');
            $query->where('relief_requests.district', $district);
        }

        // Search
        if ($request->filled('search.value')) {
            $search = $request->input('search.value');
            $query->where(function ($q) use ($search) {
                $q->where('relief_requests.item_name', 'like', '%' . $search . '%')
                  ->orWhere('relief_requests.district', 'like', '%' . $search . '%')
                  ->orWhere('relief_requests.item_type', 'like', '%' . $search . '%')
                  ->orWhere('relief_requests.status', 'like', '%' . $search . '%')
                  ->orWhere('mobile_users.full_name', 'like', '%' . $search . '%')
                  ->orWhere('mobile_users.email', 'like', '%' . $search . '%');
            });
        }

        $recordsFiltered = $query->count();

        // Pagination
        $limit = (int) $request->input('length', 10);
        $offset = (int) $request->input('start', 0);

        $requests = $query->orderBy('relief_requests.created_at', 'DESC')
            ->skip($offset)
            ->take($limit)
            ->get();

        $data = [];
        foreach ($requests as $req) {
            $data[] = [
                'id' => $req->id,
                'user_name' => $req->full_name ?? 'N/A',
                'user_email' => $req->email ?? '',
                'item_type' => ucfirst($req->item_type),
                'item_name' => $req->item_name,
                'quantity' => $req->quantity,
                'district' => $req->district,
                'status' => $req->status,
                'created_at' => date('Y-m-d H:i', strtotime($req->created_at)),
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
            'status' => 'required|in:pending,fulfilled,cancelled',
        ]);

        $reliefRequest = ReliefRequest::findOrFail($id);
        $reliefRequest->status = $request->status;
        $reliefRequest->save();

        return response()->json(['success' => true, 'message' => 'Request status updated successfully.']);
    }
}

