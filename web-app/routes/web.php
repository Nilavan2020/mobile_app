<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\MobileUserController;
use App\Http\Controllers\AuthenticationController;
use App\Http\Controllers\LanguageController;
use App\Http\Controllers\SettingController;
use App\Http\Controllers\ReliefRequestController;
use App\Http\Controllers\ReliefDonationController;
use App\Http\Controllers\SOSController;
use App\Http\Controllers\FaceSessionController;
use Illuminate\Support\Facades\Storage;

Route::get('/language/{locale}', [LanguageController::class, 'switchLanguage'])->name('language.switch');

Route::get('/', [AuthenticationController::class, 'index'])->name("index");
Route::post('/login', [AuthenticationController::class, 'login'])->name("login");
Route::get('/logout', [AuthenticationController::class, 'logout'])->name("logout");

// Route to serve storage images directly (fallback if symlink doesn't work)
Route::get('/storage/{path}', function ($path) {
    $filePath = storage_path('app/public/' . $path);
    
    if (!file_exists($filePath)) {
        abort(404, 'File not found');
    }
    
    $file = file_get_contents($filePath);
    $type = mime_content_type($filePath);
    
    return response($file, 200)
        ->header('Content-Type', $type)
        ->header('Content-Disposition', 'inline; filename="' . basename($filePath) . '"');
})->where('path', '.*');


Route::middleware(['CheckAdminAuth'])->group(function () {

    Route::get('/dashboard', [DashboardController::class, 'showDashboard'])->name("show.dashboard");

    // User Accounts Routes
    Route::get('/users/mobile', [MobileUserController::class, 'showMobileUsers'])->name("show.mobile.users");
    Route::post('/users/mobile/ajax',  [MobileUserController::class, 'processMobileUsersAjax'])->name('process.mobile.users.ajax');
    Route::post('/users/mobile/approve/{id}', [MobileUserController::class, 'approveUser'])->name("approve.user");
    Route::delete('/users/delete/{id}', [MobileUserController::class, 'deleteUser'])->name('delete.user');

    // Settings Routes
    Route::get('/settings', [SettingController::class, 'showSettings'])->name("show.settings");
    Route::post('/update-username', [SettingController::class, 'updateUsername'])->name('update.username');
    Route::post('/update-password', [SettingController::class, 'updatePassword'])->name('update.password');

    // Relief Requests Routes
    Route::get('/relief/requests', [ReliefRequestController::class, 'index'])->name("relief.requests");
    Route::post('/relief/requests/ajax', [ReliefRequestController::class, 'processAjax'])->name('relief.requests.ajax');
    Route::post('/relief/requests/{id}/status', [ReliefRequestController::class, 'updateStatus'])->name('relief.requests.update.status');

    // Relief Donations Routes
    Route::get('/relief/donations', [ReliefDonationController::class, 'index'])->name("relief.donations");
    Route::post('/relief/donations/ajax', [ReliefDonationController::class, 'processAjax'])->name('relief.donations.ajax');
    Route::post('/relief/donations/{id}/status', [ReliefDonationController::class, 'updateStatus'])->name('relief.donations.update.status');

    // SOS Alerts Routes
    Route::get('/sos/alerts', [SOSController::class, 'index'])->name("sos.alerts");
    Route::post('/sos/alerts/ajax', [SOSController::class, 'processAjax'])->name('sos.alerts.ajax');
    Route::get('/sos/alerts/{id}', [SOSController::class, 'show'])->name('sos.alerts.show');
    Route::post('/sos/alerts/{id}/close', [SOSController::class, 'closeCase'])->name('sos.alerts.close');

    // Face Sessions (Camera Sessions) - Dataset management
    Route::get('/face-sessions', [FaceSessionController::class, 'index'])->name('face.sessions.index');
    Route::get('/face-sessions/create', [FaceSessionController::class, 'create'])->name('face.sessions.create');
    Route::post('/face-sessions', [FaceSessionController::class, 'store'])->name('face.sessions.store');
    Route::get('/face-sessions/{id}', [FaceSessionController::class, 'show'])->name('face.sessions.show');
    Route::post('/face-sessions/{id}/images', [FaceSessionController::class, 'uploadImages'])->name('face.sessions.images.store');

});

