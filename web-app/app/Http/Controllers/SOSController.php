<?php

namespace App\Http\Controllers;

use App\Models\SOSAlert;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SOSController extends Controller
{
    public function index(Request $request)
    {
        $filter = $request->get('filter', 'open'); // open, closed, all
        
        $query = SOSAlert::query();
        
        if ($filter === 'open') {
            $query->where('status', '!=', 'closed')->orWhereNull('status');
        } elseif ($filter === 'closed') {
            $query->where('status', 'closed');
        }
        // 'all' shows everything
        
        $stats = [
            'total' => SOSAlert::count(),
            'today' => SOSAlert::whereDate('created_at', today())->count(),
            'stage_1' => SOSAlert::where('alert_level', 'stage_1')->count(),
            'stage_2' => SOSAlert::where('alert_level', 'stage_2')->count(),
            'stage_3' => SOSAlert::where('alert_level', 'stage_3')->count(),
            'unread' => SOSAlert::where('sms_sent', true)->count(),
            'open' => SOSAlert::where('status', '!=', 'closed')->orWhereNull('status')->count(),
            'closed' => SOSAlert::where('status', 'closed')->count(),
        ];

        return view('sos-alerts', compact('stats', 'filter'));
    }

    public function processAjax(Request $request)
    {
        try {
            $filter = $request->input('filter', 'open'); // Get filter from request
            
            // Base query for counting total
            $baseQuery = DB::table('sos_alerts');
            if ($filter === 'open') {
                $baseQuery->where(function($q) {
                    $q->where('status', '!=', 'closed')->orWhereNull('status');
                });
            } elseif ($filter === 'closed') {
                $baseQuery->where('status', 'closed');
            }
            $recordsTotal = $baseQuery->count();

            $query = DB::table('sos_alerts')
                ->leftJoin('mobile_users', 'sos_alerts.user_id', '=', 'mobile_users.id')
                ->select(
                    'sos_alerts.*',
                    'mobile_users.full_name',
                    'mobile_users.email',
                    'mobile_users.phone_number'
                );
            
            // Apply filter
            if ($filter === 'open') {
                $query->where(function($q) {
                    $q->where('sos_alerts.status', '!=', 'closed')->orWhereNull('sos_alerts.status');
                });
            } elseif ($filter === 'closed') {
                $query->where('sos_alerts.status', 'closed');
            }

            // Search
            $searchValue = $request->input('search.value');
            if (!empty($searchValue)) {
                $query->where(function ($q) use ($searchValue) {
                    $q->where('mobile_users.full_name', 'like', "%{$searchValue}%")
                      ->orWhere('mobile_users.email', 'like', "%{$searchValue}%")
                      ->orWhere('mobile_users.phone_number', 'like', "%{$searchValue}%")
                      ->orWhere('sos_alerts.location_details', 'like', "%{$searchValue}%")
                      ->orWhere('sos_alerts.alert_level', 'like', "%{$searchValue}%");
                });
            }

            $recordsFiltered = $query->count();

            // Ordering
            $orderColumnIndex = $request->input('order.0.column', 0);
            $orderColumn = $request->input("columns.{$orderColumnIndex}.data", 'created_at');
            $orderDir = $request->input('order.0.dir', 'desc');

            // Map DataTables column names to database columns
            $columnMap = [
                'user_name' => 'mobile_users.full_name',
                'alert_level' => 'sos_alerts.alert_level',
                'location' => 'sos_alerts.location_details',
                'created_at' => 'sos_alerts.created_at',
            ];

            $orderColumn = $columnMap[$orderColumn] ?? 'sos_alerts.created_at';

            $query->orderBy($orderColumn, $orderDir);

            // Pagination
            $start = $request->input('start', 0);
            $length = $request->input('length', 10);
            $query->offset($start)->limit($length);

            $alerts = $query->get();
            
            \Log::info('SOS Alerts Query Result', [
                'count' => $alerts->count(),
                'first_alert' => $alerts->first()
            ]);

            $data = [];
            foreach ($alerts as $alert) {
            $alertLevelBadge = $this->getAlertLevelBadge($alert->alert_level ?? 'stage_1');
            $smsStatusBadge = $this->getSMSStatusBadge($alert->sms_status ?? 'pending');

            // Handle status - default to 'open' if null
            $status = $alert->status ?? 'open';
            $statusBadge = $status === 'closed' 
                ? '<span class="badge bg-success">Closed</span>' 
                : '<span class="badge bg-warning">Open</span>';
            
            $actions = '<div class="btn-group" role="group">';
            $actions .= '<button class="btn btn-sm btn-info view-alert" data-id="' . $alert->id . '" title="View Details"><i class="fas fa-eye"></i> View</button>';
            if ($status !== 'closed') {
                $actions .= '<button class="btn btn-sm btn-success close-case" data-id="' . $alert->id . '" title="Close Case"><i class="fas fa-check"></i> Close</button>';
            }
            $actions .= '</div>';
            
            // Format alert_time - handle both datetime and time formats
            $alertTime = 'N/A';
            if ($alert->alert_time) {
                try {
                    // Try parsing as datetime first
                    $timeObj = is_string($alert->alert_time) ? strtotime($alert->alert_time) : $alert->alert_time;
                    if ($timeObj) {
                        $alertTime = date('H:i:s', $timeObj);
                    }
                } catch (\Exception $e) {
                    $alertTime = 'N/A';
                }
            }
            
                $data[] = [
                    'actions' => $actions,
                    'user_name' => $alert->full_name ?? ($alert->user_name ?? 'N/A'),
                    'user_phone' => $alert->phone_number ?? ($alert->user_phone ?? 'N/A'),
                    'emergency_contact' => $alert->emergency_contact ?? 'N/A',
                    'alert_level' => $alertLevelBadge,
                    'alert_time' => $alertTime,
                    'sms_status' => $smsStatusBadge,
                    'status' => $statusBadge,
                    // Store ID and other details for the view modal
                    'id' => $alert->id,
                    'police_contact' => $alert->police_contact ?? 'N/A',
                    'location' => $alert->location_details ?? ($alert->latitude && $alert->longitude ? "{$alert->latitude}, {$alert->longitude}" : 'N/A'),
                    'created_at' => $alert->created_at ? date('Y-m-d H:i:s', strtotime($alert->created_at)) : 'N/A',
                ];
            }

            \Log::info('SOS Alerts Response', [
                'draw' => intval($request->input('draw', 1)),
                'recordsTotal' => $recordsTotal,
                'recordsFiltered' => $recordsFiltered,
                'data_count' => count($data),
            ]);

            return response()->json([
                'draw' => intval($request->input('draw', 1)),
                'recordsTotal' => $recordsTotal,
                'recordsFiltered' => $recordsFiltered,
                'data' => $data,
            ]);
        } catch (\Exception $e) {
            \Log::error('SOS Alerts AJAX Error: ' . $e->getMessage());
            \Log::error('Stack trace: ' . $e->getTraceAsString());
            
            return response()->json([
                'draw' => intval($request->input('draw', 1)),
                'recordsTotal' => 0,
                'recordsFiltered' => 0,
                'data' => [],
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function show($id)
    {
        $alert = SOSAlert::with('mobileUser')->findOrFail($id);
        return response()->json($alert);
    }

    private function getAlertLevelBadge($level)
    {
        $badges = [
            'stage_1' => '<span class="badge bg-warning">Stage 1</span>',
            'stage_2' => '<span class="badge bg-danger">Stage 2 (Serious)</span>',
            'stage_3' => '<span class="badge bg-dark text-danger" style="background-color: #8b0000 !important; font-weight: bold;">🚨 Stage 3 (AGGRESSIVE) 🚨</span>',
        ];

        return $badges[$level] ?? '<span class="badge bg-secondary">' . ucfirst($level) . '</span>';
    }

    private function getSMSStatusBadge($status)
    {
        $badges = [
            'success' => '<span class="badge bg-success">Sent</span>',
            'failed' => '<span class="badge bg-danger">Failed</span>',
            'partial' => '<span class="badge bg-warning">Partial</span>',
            'pending' => '<span class="badge bg-secondary">Pending</span>',
        ];

        return $badges[$status] ?? '<span class="badge bg-secondary">' . ucfirst($status ?? 'Unknown') . '</span>';
    }

    public function closeCase(Request $request, $id)
    {
        try {
            $alert = SOSAlert::findOrFail($id);
            
            if ($alert->status === 'closed') {
                return response()->json([
                    'success' => false,
                    'message' => 'This case is already closed.'
                ], 400);
            }
            
            $alert->update([
                'status' => 'closed',
                'closed_at' => now(),
                'closed_by' => auth()->id() ?? null,
            ]);
            
            return response()->json([
                'success' => true,
                'message' => 'Case closed successfully.'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to close case: ' . $e->getMessage()
            ], 500);
        }
    }
}

