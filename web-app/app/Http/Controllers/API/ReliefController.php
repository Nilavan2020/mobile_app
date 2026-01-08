<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\ReliefRequest;
use App\Models\ReliefDonation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ReliefController extends Controller
{
    /**
     * Create a relief request
     */
    public function createRequest(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:mobile_users,id',
            'item_type' => 'required|string|in:food,water,medicine,funding',
            'item_name' => 'required|string|max:255',
            'quantity' => 'required|integer|min:1',
            'description' => 'nullable|string',
            'district' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors(),
            ], 400);
        }

        $reliefRequest = ReliefRequest::create([
            'user_id' => $request->user_id,
            'item_type' => $request->item_type,
            'item_name' => $request->item_name,
            'quantity' => $request->quantity,
            'description' => $request->description,
            'district' => $request->district,
            'status' => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Relief request created successfully',
            'data' => $reliefRequest,
        ], 201);
    }

    /**
     * Get user's relief requests
     */
    public function getUserRequests(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:mobile_users,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors(),
            ], 400);
        }

        $requests = ReliefRequest::where('user_id', $request->user_id)
            ->with('user:id,full_name,email')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $requests,
        ], 200);
    }

    /**
     * Get all relief requests (for admin)
     */
    public function getAllRequests()
    {
        $requests = ReliefRequest::with('user:id,full_name,email,phone_number')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $requests,
        ], 200);
    }

    /**
     * Get request statistics
     */
    public function getRequestStats()
    {
        $totalRequests = ReliefRequest::count();
        $pendingRequests = ReliefRequest::where('status', 'pending')->count();
        $fulfilledRequests = ReliefRequest::where('status', 'fulfilled')->count();
        
        $byDistrict = ReliefRequest::selectRaw('district, COUNT(*) as count')
            ->groupBy('district')
            ->orderBy('count', 'desc')
            ->get();

        $byItemType = ReliefRequest::selectRaw('item_type, COUNT(*) as count')
            ->groupBy('item_type')
            ->get();

        return response()->json([
            'success' => true,
            'data' => [
                'total' => $totalRequests,
                'pending' => $pendingRequests,
                'fulfilled' => $fulfilledRequests,
                'by_district' => $byDistrict,
                'by_item_type' => $byItemType,
            ],
        ], 200);
    }

    /**
     * Create a relief donation
     */
    public function createDonation(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:mobile_users,id',
            'item_type' => 'required|string|in:food,water,medicine,funding',
            'item_name' => 'required|string|max:255',
            'quantity' => 'required|integer|min:1',
            'description' => 'nullable|string',
            'district' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors(),
            ], 400);
        }

        $donation = ReliefDonation::create([
            'user_id' => $request->user_id,
            'item_type' => $request->item_type,
            'item_name' => $request->item_name,
            'quantity' => $request->quantity,
            'description' => $request->description,
            'district' => $request->district,
            'status' => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Donation created successfully',
            'data' => $donation,
        ], 201);
    }

    /**
     * Get user's donations
     */
    public function getUserDonations(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:mobile_users,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors(),
            ], 400);
        }

        $donations = ReliefDonation::where('user_id', $request->user_id)
            ->with('user:id,full_name,email')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $donations,
        ], 200);
    }

    /**
     * Get all donations (for admin)
     */
    public function getAllDonations()
    {
        $donations = ReliefDonation::with('user:id,full_name,email,phone_number')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $donations,
        ], 200);
    }

    /**
     * Get donation statistics
     */
    public function getDonationStats()
    {
        $totalDonations = ReliefDonation::count();
        $pendingDonations = ReliefDonation::where('status', 'pending')->count();
        $deliveredDonations = ReliefDonation::where('status', 'delivered')->count();
        
        $byDistrict = ReliefDonation::selectRaw('district, COUNT(*) as count')
            ->groupBy('district')
            ->orderBy('count', 'desc')
            ->get();

        $byItemType = ReliefDonation::selectRaw('item_type, COUNT(*) as count')
            ->groupBy('item_type')
            ->get();

        return response()->json([
            'success' => true,
            'data' => [
                'total' => $totalDonations,
                'pending' => $pendingDonations,
                'delivered' => $deliveredDonations,
                'by_district' => $byDistrict,
                'by_item_type' => $byItemType,
            ],
        ], 200);
    }
}




