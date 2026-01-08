@extends('layouts.dashboard_master_layout')

@section('HeaderAssets')
  <meta name="csrf-token" content="{{ csrf_token() }}">
  <title>SOS Alerts - Smart Safety Welfare App</title>
  <link href="{{asset('assets')}}/plugins/datatables/dataTables.bootstrap4.min.css" rel="stylesheet" type="text/css" />
  <link href="{{asset('assets')}}/plugins/datatables/buttons.bootstrap4.min.css" rel="stylesheet" type="text/css" />
  <link href="{{asset('assets')}}/plugins/datatables/responsive.bootstrap4.min.css" rel="stylesheet" type="text/css" />
  <link href="{{asset('assets')}}/css/bootstrap.min.css" rel="stylesheet" type="text/css">
  <link href="{{asset('assets')}}/css/metismenu.min.css" rel="stylesheet" type="text/css">
  <link href="{{asset('assets')}}/css/icons.css" rel="stylesheet" type="text/css">
  <link href="{{asset('assets')}}/css/style.css" rel="stylesheet" type="text/css">
  <style>
    #datatable tbody tr:hover {
      background-color: #3f4f69;
      cursor: pointer;
    }
    .card {
      background-color: rgba(30, 41, 59, 0.8);
      border: 1px solid rgba(255, 255, 255, 0.1);
    }
    .card-body {
      color: #dee2e6;
    }
    .table {
      color: #dee2e6;
    }
    .table thead th {
      border-bottom: 2px solid rgba(255, 255, 255, 0.1);
      color: #dee2e6;
    }
    .table tbody td {
      border-top: 1px solid rgba(255, 255, 255, 0.1);
    }
    .badge.bg-orange {
      background-color: #ff9800 !important;
    }
  </style>
@endsection

@section('PageContent')

<div class="container-fluid">
    <div class="page-title-box">
        <div class="row align-items-center">
          <div class="col-md-8">
            <div class="page-title-box">
                <h4 class="page-title">SOS Alerts</h4>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{ route('show.dashboard') }}">Home</a>
                    </li>
                    <li class="breadcrumb-item active">SOS Alerts</li>
                </ol>
            </div>
          </div>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row">
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Total Alerts</h5>
                    <h2>{{ $stats['total'] }}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Today</h5>
                    <h2>{{ $stats['today'] }}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Stage 1</h5>
                    <h2 class="text-warning">{{ $stats['stage_1'] ?? 0 }}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Stage 2 (Serious)</h5>
                    <h2 class="text-danger">{{ $stats['stage_2'] }}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card border-danger" style="border-width: 2px !important;">
                <div class="card-body">
                    <h5 class="card-title text-danger" style="font-weight: bold;">🚨 Stage 3 (AGGRESSIVE) 🚨</h5>
                    <h2 class="text-danger" style="color: #8b0000 !important; font-weight: bold;">{{ $stats['stage_3'] ?? 0 }}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Sent Alerts</h5>
                    <h2>{{ $stats['unread'] }}</h2>
                </div>
            </div>
        </div>
    </div>

    <!-- Filter Tabs -->
    <div class="row mb-3">
        <div class="col-12">
            <ul class="nav nav-tabs" role="tablist" style="border-bottom: 2px solid rgba(255, 255, 255, 0.1);">
                <li class="nav-item">
                    <a class="nav-link {{ $filter === 'open' ? 'active' : '' }}" href="{{ route('sos.alerts', ['filter' => 'open']) }}" style="color: #dee2e6; {{ $filter === 'open' ? 'background-color: rgba(30, 41, 59, 0.8); border-color: rgba(255, 255, 255, 0.1);' : '' }}">
                        Open Cases <span class="badge bg-warning">{{ $stats['open'] }}</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link {{ $filter === 'closed' ? 'active' : '' }}" href="{{ route('sos.alerts', ['filter' => 'closed']) }}" style="color: #dee2e6; {{ $filter === 'closed' ? 'background-color: rgba(30, 41, 59, 0.8); border-color: rgba(255, 255, 255, 0.1);' : '' }}">
                        History (Closed) <span class="badge bg-success">{{ $stats['closed'] }}</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link {{ $filter === 'all' ? 'active' : '' }}" href="{{ route('sos.alerts', ['filter' => 'all']) }}" style="color: #dee2e6; {{ $filter === 'all' ? 'background-color: rgba(30, 41, 59, 0.8); border-color: rgba(255, 255, 255, 0.1);' : '' }}">
                        All Cases <span class="badge bg-info">{{ $stats['total'] }}</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>

    <!-- DataTable -->
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <h4 class="mt-0 header-title">{{ $filter === 'closed' ? 'History - Closed Cases' : ($filter === 'open' ? 'Open Cases' : 'All SOS Alerts') }}</h4>
                    <p class="text-muted mb-4">View and manage all emergency SOS alerts from mobile users.</p>
                    
                    <table id="datatable" class="table table-bordered dt-responsive nowrap" style="border-collapse: collapse; border-spacing: 0; width: 100%;">
                        <thead>
                            <tr>
                                <th>Action</th>
                                <th>User Name</th>
                                <th>User Phone</th>
                                <th>Emergency Contact</th>
                                <th>Alert Level</th>
                                <th>Alert Time</th>
                                <th>SMS Status</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Data will be loaded via AJAX -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- View Alert Modal -->
<div class="modal fade" id="viewAlertModal" tabindex="-1" role="dialog" aria-labelledby="viewAlertModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content" style="background-color: #1e293b; color: #dee2e6;">
            <div class="modal-header" style="border-bottom: 1px solid rgba(255, 255, 255, 0.1);">
                <h5 class="modal-title" id="viewAlertModalLabel">SOS Alert Details</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: #dee2e6;">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" id="alertDetails">
                <!-- Alert details will be loaded here -->
            </div>
            <div class="modal-footer" style="border-top: 1px solid rgba(255, 255, 255, 0.1);">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

@endsection

@section('FooterAssets')
<!-- jQuery first, then DataTables -->
<script src="{{asset('assets')}}/js/jquery.min.js"></script>
<script src="{{asset('assets')}}/js/bootstrap.bundle.min.js"></script>
<script src="{{asset('assets')}}/js/metismenu.min.js"></script>
<script src="{{asset('assets')}}/js/jquery.slimscroll.js"></script>
<script src="{{asset('assets')}}/js/waves.min.js"></script>
<script src="{{asset('assets')}}/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="{{asset('assets')}}/plugins/datatables/dataTables.bootstrap4.min.js"></script>
<script src="{{asset('assets')}}/plugins/datatables/dataTables.responsive.min.js"></script>
<script src="{{asset('assets')}}/plugins/datatables/responsive.bootstrap4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
$(document).ready(function() {
    var table = $('#datatable').DataTable({
        processing: true,
        serverSide: true,
        ajax: {
            url: "{{ route('sos.alerts.ajax') }}",
            type: "POST",
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            },
            data: function(d) {
                // Add filter parameter
                d.filter = '{{ $filter }}';
                return d;
            },
            error: function(xhr, error, thrown) {
                console.error('DataTables AJAX Error:', error);
                console.error('Status:', xhr.status);
                console.error('Response:', xhr.responseText);
                alert('Error loading data. Check console for details.');
            }
        },
        columns: [
            { data: 'actions', name: 'actions', orderable: false, searchable: false },
            { data: 'user_name', name: 'user_name' },
            { data: 'user_phone', name: 'user_phone' },
            { data: 'emergency_contact', name: 'emergency_contact' },
            { data: 'alert_level', name: 'alert_level', orderable: false },
            { data: 'alert_time', name: 'alert_time' },
            { data: 'sms_status', name: 'sms_status', orderable: false },
            { data: 'status', name: 'status', orderable: false }
        ],
        order: [[5, 'desc']], // Order by alert_time desc
        pageLength: 25,
        language: {
            search: "Search:",
            lengthMenu: "Show _MENU_ entries",
            info: "Showing _START_ to _END_ of _TOTAL_ entries",
            infoEmpty: "No entries found",
            infoFiltered: "(filtered from _TOTAL_ total entries)"
        }
    });

    // View alert details
    $(document).on('click', '.view-alert', function() {
        var alertId = $(this).data('id');
        
        $.ajax({
            url: "{{ route('sos.alerts.show', '') }}/" + alertId,
            type: "GET",
            success: function(response) {
                var html = '<div class="row">';
                html += '<div class="col-md-6"><strong>Alert ID:</strong> ' + (response.id || 'N/A') + '</div>';
                var alertLevelBadge = '';
                if (response.alert_level === 'stage_3') {
                    alertLevelBadge = '<span class="badge" style="background-color: #8b0000 !important; color: white; font-weight: bold;">🚨 Stage 3 (AGGRESSIVE) 🚨</span>';
                } else if (response.alert_level === 'stage_2') {
                    alertLevelBadge = '<span class="badge bg-danger">Stage 2 (Serious)</span>';
                } else {
                    alertLevelBadge = '<span class="badge bg-warning">Stage 1</span>';
                }
                html += '<div class="col-md-6"><strong>Alert Level:</strong> ' + alertLevelBadge + '</div>';
                html += '</div><hr>';
                html += '<div class="row">';
                html += '<div class="col-md-6"><strong>User Name:</strong> ' + (response.user_name || 'N/A') + '</div>';
                html += '<div class="col-md-6"><strong>User Phone:</strong> ' + (response.user_phone || 'N/A') + '</div>';
                html += '</div><hr>';
                html += '<div class="row">';
                html += '<div class="col-md-6"><strong>Emergency Contact:</strong> ' + (response.emergency_contact || 'N/A') + '</div>';
                html += '<div class="col-md-6"><strong>Police Contact:</strong> ' + (response.police_contact || 'N/A') + '</div>';
                html += '</div><hr>';
                html += '<div class="row">';
                html += '<div class="col-md-12"><strong>Location:</strong> ' + (response.location_details || (response.latitude && response.longitude ? response.latitude + ', ' + response.longitude : 'N/A')) + '</div>';
                if (response.latitude && response.longitude) {
                    html += '<div class="col-md-12 mt-2"><a href="https://www.google.com/maps?q=' + response.latitude + ',' + response.longitude + '" target="_blank" class="btn btn-sm btn-primary">View on Map</a></div>';
                }
                html += '</div><hr>';
                html += '<div class="row">';
                html += '<div class="col-md-6"><strong>Is Danger Area:</strong> ' + (response.is_danger_area ? 'Yes (Isolated)' : 'No (Populated)') + '</div>';
                html += '<div class="col-md-6"><strong>Status:</strong> <span class="badge bg-' + (response.status === 'closed' ? 'success' : 'warning') + '">' + (response.status === 'closed' ? 'Closed' : 'Open') + '</span></div>';
                html += '</div><hr>';
                html += '<div class="row">';
                html += '<div class="col-md-6"><strong>Alert Time:</strong> ' + (response.alert_time || 'N/A') + '</div>';
                html += '<div class="col-md-6"><strong>Created At:</strong> ' + (response.created_at || 'N/A') + '</div>';
                html += '</div><hr>';
                html += '<div class="row">';
                html += '<div class="col-md-12"><strong>SMS Status:</strong> <span class="badge bg-' + (response.sms_status === 'success' ? 'success' : (response.sms_status === 'failed' ? 'danger' : 'warning')) + '">' + (response.sms_status || 'Pending') + '</span></div>';
                html += '</div><hr>';
                if (response.sms_message) {
                    html += '<div class="row"><div class="col-md-12"><strong>SMS Message:</strong><pre style="background-color: #0f172a; color: #ffffff; padding: 10px; border-radius: 5px; white-space: pre-wrap;">' + response.sms_message + '</pre></div></div>';
                }
                if (response.sms_recipients) {
                    html += '<div class="row mt-3"><div class="col-md-12"><strong>SMS Recipients:</strong><ul style="color: #dee2e6;">';
                    var recipients = typeof response.sms_recipients === 'string' ? JSON.parse(response.sms_recipients) : response.sms_recipients;
                    if (Array.isArray(recipients)) {
                        recipients.forEach(function(recipient) {
                            var statusBadge = recipient.status === 'success' ? 'success' : (recipient.status === 'failed' ? 'danger' : 'warning');
                            html += '<li style="margin-bottom: 5px;">' + recipient.type.charAt(0).toUpperCase() + recipient.type.slice(1) + ': <strong>' + recipient.number + '</strong> <span class="badge bg-' + statusBadge + '">' + recipient.status + '</span></li>';
                        });
                    }
                    html += '</ul></div></div>';
                }
                
                $('#alertDetails').html(html);
                $('#viewAlertModal').modal('show');
            },
            error: function() {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Failed to load alert details'
                });
            }
        });
    });

    // Close case
    $(document).on('click', '.close-case', function() {
        var alertId = $(this).data('id');
        var button = $(this);
        
        Swal.fire({
            title: 'Close Case?',
            text: 'Are you sure you want to close this SOS alert case?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#28a745',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, Close Case',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: "{{ route('sos.alerts.close', ':id') }}".replace(':id', alertId),
                    type: "POST",
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    success: function(response) {
                        if (response.success) {
                            Swal.fire({
                                icon: 'success',
                                title: 'Success',
                                text: response.message,
                                timer: 2000,
                                showConfirmButton: false
                            }).then(() => {
                                // Redirect to history (closed cases) after closing
                                window.location.href = "{{ route('sos.alerts', ['filter' => 'closed']) }}";
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: response.message
                            });
                        }
                    },
                    error: function(xhr) {
                        var errorMsg = 'Failed to close case';
                        if (xhr.responseJSON && xhr.responseJSON.message) {
                            errorMsg = xhr.responseJSON.message;
                        }
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: errorMsg
                        });
                    }
                });
            }
        });
    });
});
</script>
@endsection

