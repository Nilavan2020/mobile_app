@extends('layouts.dashboard_master_layout')

@section('HeaderAssets')
  <title>Relief Donations - Smart Safety Welfare App</title>
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
  </style>
@endsection

@section('PageContent')

<div class="container-fluid">
    <div class="page-title-box">
        <div class="row align-items-center">
          <div class="col-md-8">
            <div class="page-title-box">
                <h4 class="page-title">Relief Donations</h4>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{ route('show.dashboard') }}">Home</a>
                    </li>
                    <li class="breadcrumb-item active">Relief Donations</li>
                </ol>
            </div>
          </div>
        </div>
    </div>

    @if (session('success'))
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            {{ session('success') }}
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    @endif

    <!-- Statistics Cards -->
    <div class="row">
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Total Donations</h5>
                    <h2>{{ $stats['total'] }}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Pending</h5>
                    <h2>{{ $stats['pending'] }}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Delivered</h5>
                    <h2>{{ $stats['delivered'] }}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Cancelled</h5>
                    <h2>{{ $stats['cancelled'] }}</h2>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <table id="datatable" class="table table-bordered display nowrap" style="border-collapse: collapse; border-spacing: 0; width: 100%;">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>User</th>
                                <th>Item Type</th>
                                <th>Item Name</th>
                                <th>Quantity</th>
                                <th>District</th>
                                <th>Status</th>
                                <th>Created At</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

@endsection

@section('FooterAssets')
    <!-- jQuery  -->
    <script src="{{asset('assets')}}/js/jquery.min.js"></script>
    <script src="{{asset('assets')}}/js/bootstrap.bundle.min.js"></script>
    <script src="{{asset('assets')}}/js/metismenu.min.js"></script>
    <script src="{{asset('assets')}}/js/jquery.slimscroll.js"></script>
    <script src="{{asset('assets')}}/js/waves.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- Required datatable js -->
    <script src="{{asset('assets')}}/plugins/datatables/jquery.dataTables.min.js"></script>
    <script src="{{asset('assets')}}/plugins/datatables/dataTables.bootstrap4.min.js"></script>
    <!-- Buttons examples -->
    <script src="{{asset('assets')}}/plugins/datatables/dataTables.buttons.min.js"></script>
    <script src="{{asset('assets')}}/plugins/datatables/buttons.bootstrap4.min.js"></script>
    <script src="{{asset('assets')}}/plugins/datatables/jszip.min.js"></script>
    <script src="{{asset('assets')}}/plugins/datatables/pdfmake.min.js"></script>
    <script src="{{asset('assets')}}/plugins/datatables/vfs_fonts.js"></script>
    <script src="{{asset('assets')}}/plugins/datatables/buttons.html5.min.js"></script>
    <script src="{{asset('assets')}}/plugins/datatables/buttons.print.min.js"></script>
    <script src="{{asset('assets')}}/plugins/datatables/buttons.colVis.min.js"></script>
    <!-- Responsive examples -->
    <script src="{{asset('assets')}}/plugins/datatables/dataTables.responsive.min.js"></script>
    <script src="{{asset('assets')}}/plugins/datatables/responsive.bootstrap4.min.js"></script>

    <!-- App js -->
    <script src="{{asset('assets')}}/js/app.js"></script>

    <script>
        $(document).ready(function() {
            setTimeout(function() {
                $('.alert').fadeOut('slow');
            }, 6000);
        });
    </script>

    <script>
        $.ajaxSetup({
            headers: { 'X-CSRF-TOKEN': '{{ csrf_token() }}' }
        });

        function updateDonationStatus(id, status) {
            $.post("{{ route('relief.donations.update.status', ':id') }}".replace(':id', id), {
                status: status,
                _token: '{{ csrf_token() }}'
            })
            .done(resp => {
                if(resp.success) {
                    $('#datatable').DataTable().ajax.reload(null, false);
                    Swal.fire('Success', resp.message, 'success');
                } else {
                    Swal.fire('Error', resp.message || 'Update failed', 'error');
                }
            })
            .fail(xhr => {
                console.error(xhr.responseText);
                Swal.fire('Error', 'Update request failed', 'error');
            });
        }
    </script>

    <script>
        $(document).ready(function() {
            $('#datatable').DataTable({
                processing: true,
                serverSide: true,
                ajax: {
                    url: "{{ route('relief.donations.ajax') }}",
                    type: "POST",
                    data: function (d) {
                        d._token = "{{ csrf_token() }}";
                    }
                },
                scrollX: true,
                columns: [
                    { data: "id", name: "id" },
                    { 
                        data: null,
                        render: function(data, type, row) {
                            return row.user_name + '<br><small>' + row.user_email + '</small>';
                        }
                    },
                    { data: "item_type", name: "item_type" },
                    { data: "item_name", name: "item_name" },
                    { data: "quantity", name: "quantity" },
                    { data: "district", name: "district" },
                    { 
                        data: "status",
                        render: function(data) {
                            let badgeClass = 'warning';
                            if (data === 'delivered') badgeClass = 'success';
                            else if (data === 'cancelled') badgeClass = 'danger';
                            return '<span class="badge badge-' + badgeClass + '">' + data.charAt(0).toUpperCase() + data.slice(1) + '</span>';
                        }
                    },
                    { data: "created_at", name: "created_at" },
                    { 
                        data: null,
                        orderable: false,
                        searchable: false,
                        render: function(data, type, row) {
                            let selectedPending = row.status === 'pending' ? 'selected' : '';
                            let selectedDelivered = row.status === 'delivered' ? 'selected' : '';
                            let selectedCancelled = row.status === 'cancelled' ? 'selected' : '';
                            return '<select class="form-control form-control-sm" onchange="updateDonationStatus(' + row.id + ', this.value)">' +
                                   '<option value="pending" ' + selectedPending + '>Pending</option>' +
                                   '<option value="delivered" ' + selectedDelivered + '>Delivered</option>' +
                                   '<option value="cancelled" ' + selectedCancelled + '>Cancelled</option>' +
                                   '</select>';
                        }
                    }
                ]
            });
        });
    </script>
@endsection
