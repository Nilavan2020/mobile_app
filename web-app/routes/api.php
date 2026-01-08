<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\API\ReliefController;
use App\Http\Controllers\API\FaceRecognitionController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Mobile Authentication Routes
Route::post('/register/mobile', [AuthController::class, 'register'])->name('api.register.mobile');
Route::post('/login/mobile', [AuthController::class, 'login'])->name('api.login.mobile');

// Mobile User Routes
Route::prefix('user')->name('api.user.')->group(function () {
    Route::get('/profile/mobile', [UserController::class, 'getProfile'])->name('profile.mobile');
    Route::post('/change-password', [UserController::class, 'changePassword'])->name('change-password');
    Route::post('/update-emergency-contacts', [UserController::class, 'updateEmergencyContacts'])->name('update-emergency-contacts');
});

// SOS Routes
Route::prefix('sos')->name('api.sos.')->group(function () {
    Route::post('/send-alert', [\App\Http\Controllers\API\SOSController::class, 'sendAlert'])->name('send-alert');
    Route::post('/send-stage3-alert', [\App\Http\Controllers\API\SOSController::class, 'sendStage3Alert'])->name('send-stage3-alert');
});

// Relief Routes
Route::prefix('relief')->name('api.relief.')->group(function () {
    // Requests
    Route::post('/request', [ReliefController::class, 'createRequest'])->name('request.create');
    Route::post('/requests/user', [ReliefController::class, 'getUserRequests'])->name('requests.user');
    Route::get('/requests/all', [ReliefController::class, 'getAllRequests'])->name('requests.all');
    Route::get('/requests/stats', [ReliefController::class, 'getRequestStats'])->name('requests.stats');
    
    // Donations
    Route::post('/donation', [ReliefController::class, 'createDonation'])->name('donation.create');
    Route::post('/donations/user', [ReliefController::class, 'getUserDonations'])->name('donations.user');
    Route::get('/donations/all', [ReliefController::class, 'getAllDonations'])->name('donations.all');
    Route::get('/donations/stats', [ReliefController::class, 'getDonationStats'])->name('donations.stats');
});

// Face Recognition (Find Person) Routes
Route::prefix('face')->name('api.face.')->group(function () {
    Route::get('/sessions', [FaceRecognitionController::class, 'listSessions'])->name('sessions');
    Route::post('/search', [FaceRecognitionController::class, 'search'])->name('search');
    Route::get('/image/{id}', [FaceRecognitionController::class, 'serveImage'])->name('image');
});
