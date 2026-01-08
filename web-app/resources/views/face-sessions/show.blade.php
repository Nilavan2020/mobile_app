@extends('layouts.dashboard_master_layout')

@section('HeaderAssets')
    <title>Manage Camera Session - Smart Safety Welfare App</title>
    <link href="{{asset('assets')}}/css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link href="{{asset('assets')}}/css/metismenu.min.css" rel="stylesheet" type="text/css">
    <link href="{{asset('assets')}}/css/icons.css" rel="stylesheet" type="text/css">
    <link href="{{asset('assets')}}/css/style.css" rel="stylesheet" type="text/css">
    <style>
        .thumb {
            width: 90px;
            height: 90px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.15);
        }
    </style>
@endsection

@section('PageContent')
<div class="container-fluid">
    <div class="page-title-box">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h4 class="page-title">Manage Camera Session</h4>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="{{ route('show.dashboard') }}">Home</a></li>
                    <li class="breadcrumb-item"><a href="{{ route('face.sessions.index') }}">Camera Sessions</a></li>
                    <li class="breadcrumb-item active">{{ $session->name }}</li>
                </ol>
            </div>
            <div class="col-md-4 text-right">
                <a href="{{ route('face.sessions.index') }}" class="btn btn-secondary">Back</a>
            </div>
        </div>
    </div>

    @if(session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @endif

    @if ($errors->any())
        <div class="alert alert-danger">
            <ul class="mb-0">
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <div class="row">
        <div class="col-lg-4">
            <div class="card" style="background-color: rgba(30, 41, 59, 0.8); border: 1px solid rgba(255, 255, 255, 0.1);">
                <div class="card-body" style="color: #dee2e6;">
                    <h5 class="mb-3">Session Info</h5>
                    <p class="mb-1"><strong>Name:</strong> {{ $session->name }}</p>
                    <p class="mb-1"><strong>Place:</strong> {{ $session->place_name ?? '—' }}</p>
                    <p class="mb-1"><strong>ID:</strong> {{ $session->id }}</p>
                    <p class="mb-0"><strong>Images:</strong> {{ $session->images->count() }}</p>
                    @if($session->notes)
                        <hr style="border-color: rgba(255,255,255,0.1);" />
                        <p class="mb-0"><strong>Notes:</strong><br>{{ $session->notes }}</p>
                    @endif
                </div>
            </div>

            <div class="card" style="background-color: rgba(30, 41, 59, 0.8); border: 1px solid rgba(255, 255, 255, 0.1);">
                <div class="card-body" style="color: #dee2e6;">
                    <h5 class="mb-3">Upload Dataset Images</h5>
                    <form method="POST" action="{{ route('face.sessions.images.store', $session->id) }}" enctype="multipart/form-data">
                        @csrf
                        <div class="form-group">
                            <label>Select images (multiple)</label>
                            <input type="file" name="images[]" class="form-control" accept="image/*" multiple required>
                            <small class="text-muted">Tip: upload clear face images for best matching.</small>
                        </div>
                        <button class="btn btn-primary" type="submit">
                            <i class="mdi mdi-upload"></i> Upload
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="card" style="background-color: rgba(30, 41, 59, 0.8); border: 1px solid rgba(255, 255, 255, 0.1);">
                <div class="card-body" style="color: #dee2e6;">
                    <h5 class="mb-3">Dataset Images</h5>
                    @if($session->images->isEmpty())
                        <p class="text-muted mb-0">No images uploaded yet.</p>
                    @else
                        <div class="table-responsive">
                            <table class="table table-bordered" style="color: #dee2e6;">
                                <thead>
                                    <tr>
                                        <th>Preview</th>
                                        <th>File</th>
                                        <th>Uploaded</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach($session->images as $img)
                                        <tr>
                                            <td style="width: 110px;">
                                                <img class="thumb" src="{{ url('/api/face/image/' . $img->id) }}" alt="img" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=%27http://www.w3.org/2000/svg%27 width=%27100%27 height=%27100%27%3E%3Crect fill=%27%23ddd%27 width=%27100%27 height=%27100%27/%3E%3Ctext fill=%27%23999%27 font-family=%27sans-serif%27 font-size=%2714%27 x=%2750%27 y=%2750%27 text-anchor=%27middle%27 dy=%27.3em%27%3ENo Image%3C/text%3E%3C/svg%3E';">
                                            </td>
                                            <td>
                                                <div><strong>{{ $img->original_name ?? 'image' }}</strong></div>
                                                <small class="text-muted">{{ $img->file_path }}</small>
                                            </td>
                                            <td>{{ $img->created_at ? $img->created_at->format('Y-m-d H:i') : '—' }}</td>
                                        </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                    @endif
                </div>
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





