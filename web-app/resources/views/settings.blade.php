@extends('layouts.dashboard_master_layout')

@section('HeaderAssets')
  <title>Settings - Smart Safety Welfare App</title>

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
            <div class="page-title-box">
                <h4 class="page-title">{{ __('messages.settings') }}</h4>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{ route('show.dashboard') }}">{{ __('messages.home') }}</a>
                    </li>
                    <li class="breadcrumb-item active">{{ __('messages.settings') }}</li>
                </ol>
            </div>
          </div>
        </div>
    </div>

    <!-- Settings Cards -->
    <div class="row">
        <!-- Update Username Card -->
        <div class="col-xl-6">
            <div class="card">
                <div class="card-body">
                    <h4 class="card-title mb-4">Update Username</h4>
                    
                    @if(session('success'))
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            {{ session('success') }}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    @endif

                    @if(session('error'))
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            {{ session('error') }}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    @endif

                    @if ($errors->any())
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <ul class="mb-0">
                                @foreach ($errors->all() as $error)
                                    <li>{{ $error }}</li>
                                @endforeach
                            </ul>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    @endif

                    <form action="{{ route('update.username') }}" method="POST">
                        @csrf
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" class="form-control" id="username" name="username" value="{{ $user->username }}" required>
                        </div>
                        <button type="submit" class="btn btn-primary">Update Username</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Update Password Card -->
        <div class="col-xl-6">
            <div class="card">
                <div class="card-body">
                    <h4 class="card-title mb-4">Update Password</h4>
                    
                    <form action="{{ route('update.password') }}" method="POST">
                        @csrf
                        <div class="form-group">
                            <label for="current_password">Current Password</label>
                            <input type="password" class="form-control" id="current_password" name="current_password" required>
                        </div>
                        <div class="form-group">
                            <label for="new_password">New Password</label>
                            <input type="password" class="form-control" id="new_password" name="new_password" required minlength="8">
                            <small class="form-text text-muted">Password must be at least 8 characters long.</small>
                        </div>
                        <div class="form-group">
                            <label for="new_password_confirmation">Confirm New Password</label>
                            <input type="password" class="form-control" id="new_password_confirmation" name="new_password_confirmation" required>
                        </div>
                        <button type="submit" class="btn btn-primary">Update Password</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

@endsection

@section('FooterAssets')
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="{{asset('assets')}}/js/app.js"></script>
@endsection





