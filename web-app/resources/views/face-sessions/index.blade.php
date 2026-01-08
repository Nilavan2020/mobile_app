@extends('layouts.dashboard_master_layout')

@section('HeaderAssets')
    <title>Camera Sessions - Smart Safety Welfare App</title>
    <link href="{{asset('assets')}}/css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link href="{{asset('assets')}}/css/metismenu.min.css" rel="stylesheet" type="text/css">
    <link href="{{asset('assets')}}/css/icons.css" rel="stylesheet" type="text/css">
    <link href="{{asset('assets')}}/css/style.css" rel="stylesheet" type="text/css">
@endsection

@section('PageContent')
<div class="container-fluid">
    <div class="page-title-box">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h4 class="page-title">Camera Sessions (Face Datasets)</h4>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="{{ route('show.dashboard') }}">Home</a></li>
                    <li class="breadcrumb-item active">Camera Sessions</li>
                </ol>
            </div>
            <div class="col-md-4 text-right">
                <a href="{{ route('face.sessions.create') }}" class="btn btn-primary">
                    <i class="mdi mdi-plus"></i> Create Session
                </a>
            </div>
        </div>
    </div>

    @if(session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @endif

    <div class="card" style="background-color: rgba(30, 41, 59, 0.8); border: 1px solid rgba(255, 255, 255, 0.1);">
        <div class="card-body" style="color: #dee2e6;">
            <p class="text-muted mb-3">Create a session for a location (e.g., a temple). Upload many faces to build the dataset. Mobile users will select a session and search for a person.</p>

            <div class="table-responsive">
                <table class="table table-bordered" style="color: #dee2e6;">
                    <thead>
                        <tr>
                            <th>Session</th>
                            <th>Place</th>
                            <th>Images</th>
                            <th>Created</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($sessions as $s)
                            <tr>
                                <td><strong>{{ $s->name }}</strong><br><small class="text-muted">ID: {{ $s->id }}</small></td>
                                <td>{{ $s->place_name ?? '—' }}</td>
                                <td>{{ $s->images_count }}</td>
                                <td>{{ $s->created_at ? $s->created_at->format('Y-m-d H:i') : '—' }}</td>
                                <td>
                                    <a href="{{ route('face.sessions.show', $s->id) }}" class="btn btn-sm btn-info">
                                        <i class="mdi mdi-eye"></i> Manage
                                    </a>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="5" class="text-center text-muted">No sessions yet.</td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
@endsection

@section('FooterAssets')
<script src="{{asset('assets')}}/js/jquery.min.js"></script>
<script src="{{asset('assets')}}/js/bootstrap.bundle.min.js"></script>
<script src="{{asset('assets')}}/js/metismenu.min.js"></script>
<script src="{{asset('assets')}}/js/jquery.slimscroll.js"></script>
<script src="{{asset('assets')}}/js/waves.min.js"></script>
@endsection





