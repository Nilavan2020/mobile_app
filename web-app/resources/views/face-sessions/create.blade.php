@extends('layouts.dashboard_master_layout')

@section('HeaderAssets')
    <title>Create Camera Session - Smart Safety Welfare App</title>
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
                <h4 class="page-title">Create Camera Session</h4>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="{{ route('show.dashboard') }}">Home</a></li>
                    <li class="breadcrumb-item"><a href="{{ route('face.sessions.index') }}">Camera Sessions</a></li>
                    <li class="breadcrumb-item active">Create</li>
                </ol>
            </div>
        </div>
    </div>

    <div class="card" style="background-color: rgba(30, 41, 59, 0.8); border: 1px solid rgba(255, 255, 255, 0.1);">
        <div class="card-body" style="color: #dee2e6;">
            @if ($errors->any())
                <div class="alert alert-danger">
                    <ul class="mb-0">
                        @foreach ($errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif

            <form method="POST" action="{{ route('face.sessions.store') }}">
                @csrf

                <div class="form-group">
                    <label>Session Name</label>
                    <input type="text" name="name" class="form-control" placeholder="e.g., Session 01" value="{{ old('name') }}" required>
                </div>

                <div class="form-group">
                    <label>Place Name (optional)</label>
                    <input type="text" name="place_name" class="form-control" placeholder="e.g., Temple - Kandy" value="{{ old('place_name') }}">
                </div>

                <div class="form-group">
                    <label>Notes (optional)</label>
                    <textarea name="notes" class="form-control" rows="4" placeholder="Any details about this dataset">{{ old('notes') }}</textarea>
                </div>

                <div class="d-flex gap-2">
                    <button class="btn btn-primary" type="submit">
                        <i class="mdi mdi-content-save"></i> Create
                    </button>
                    <a href="{{ route('face.sessions.index') }}" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
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





