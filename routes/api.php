<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\Api\UserApiController;

// Route root API - untuk test
Route::get('/', function () {
    return response()->json(['status' => true, 'message' => 'Yazaki API Running']);
});

// Route Users
Route::get('/users', [UserApiController::class, 'index']);


// Route Login - POST
Route::post('/login', [AuthController::class, 'login']);
Route::post('/heartbeat', [AuthController::class, 'heartbeat']);

// Route Logout - POST
Route::post('/logout', [AuthController::class, 'logout']);

// Route Register - POST
Route::post('/users', [UserApiController::class, 'store']);

// Route Reports
Route::prefix('reports')->group(function () {
    Route::get('/', [ReportController::class, 'index']);
    Route::get('/{id}', [ReportController::class, 'show']);
    Route::post('/', [ReportController::class, 'store']);
    Route::put('/{id}', [ReportController::class, 'update']);
    Route::delete('/{id}', [ReportController::class, 'destroy']);
});

// Tambahkan route untuk cek shift user
Route::post('/check-shift', function (Request $request) {
    $user = App\Models\User::where('nama', $request->nama)->first();
    if (!$user) {
        return response()->json(['status' => false, 'message' => 'User tidak ditemukan']);
    }
    return response()->json([
        'status' => true,
        'data' => [
            'nama' => $user->nama,
            'shift' => $user->shift,
        ]
    ]);
});

